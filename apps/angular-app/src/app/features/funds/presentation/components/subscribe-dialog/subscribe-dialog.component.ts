import { Component, inject, input, output, signal, OnInit } from '@angular/core';
import { Fund } from '../../../domain/entities/fund.entity';
import { FundsStore } from '../../state/funds.store';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';
import { FundNamePipe } from '../../../../../core/utils/fund-name.pipe';
import { ErrorMessageComponent } from '../../../../../shared/components/error-message/error-message.component';

@Component({
  selector: 'app-subscribe-dialog',
  standalone: true,
  imports: [CopCurrencyPipe, FundNamePipe, ErrorMessageComponent],
  templateUrl: './subscribe-dialog.component.html',
  styleUrl: './subscribe-dialog.component.scss',
})
export class SubscribeDialogComponent implements OnInit {
  fund = input.required<Fund>();
  close = output<void>();

  private readonly store = inject(FundsStore);

  readonly notification = signal<string>('EMAIL');
  readonly subscribing = this.store.subscribing;
  readonly subscribeError = this.store.subscribeError;
  readonly amountValue = signal<string>('');
  readonly amountError = signal<string | null>(null);

  ngOnInit(): void {
    this.amountValue.set(this.formatNumber(this.fund().minAmount.toString()));
  }

  selectNotification(type: string): void {
    this.notification.set(type);
  }

  onAmountInput(event: Event): void {
    const input = event.target as HTMLInputElement;
    const raw = input.value.replace(/\D/g, '');
    const formatted = this.formatNumber(raw);
    this.amountValue.set(formatted);
    input.value = formatted;

    if (this.amountError()) {
      this.validateAmount();
    }
  }

  onAmountKeydown(event: KeyboardEvent): void {
    const allowed = [
      'Backspace', 'Delete', 'Tab', 'ArrowLeft', 'ArrowRight',
      'Home', 'End', 'Enter',
    ];
    if (allowed.includes(event.key)) return;
    if (event.ctrlKey || event.metaKey) return;
    if (!/^\d$/.test(event.key)) {
      event.preventDefault();
    }
  }

  validateAmount(): boolean {
    const raw = this.amountValue().replace(/\./g, '');
    if (!raw) {
      this.amountError.set('Ingrese un monto');
      return false;
    }
    const amount = parseInt(raw, 10);
    if (isNaN(amount)) {
      this.amountError.set('Solo se permiten numeros');
      return false;
    }
    if (amount < this.fund().minAmount) {
      const min = this.fund().minAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
      this.amountError.set(`El monto minimo es $${min}`);
      return false;
    }
    this.amountError.set(null);
    return true;
  }

  private parseAmount(): number {
    return parseInt(this.amountValue().replace(/\./g, ''), 10) || 0;
  }

  private formatNumber(value: string): string {
    const digits = value.replace(/\D/g, '');
    if (!digits) return '';
    return digits.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  }

  async onSubmit(): Promise<void> {
    if (!this.validateAmount()) return;

    this.store.clearSubscribeError();
    const success = await this.store.subscribeTo(
      this.fund(),
      this.parseAmount(),
      this.notification()
    );
    if (success) {
      this.close.emit();
    }
  }

  onClose(): void {
    this.store.clearSubscribeError();
    this.close.emit();
  }

  onOverlayClick(event: MouseEvent): void {
    if ((event.target as HTMLElement).classList.contains('overlay')) {
      this.onClose();
    }
  }
}
