import { Component, inject, input, output, signal } from '@angular/core';
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
export class SubscribeDialogComponent {
  fund = input.required<Fund>();
  close = output<void>();

  private readonly store = inject(FundsStore);

  readonly notification = signal<string>('EMAIL');
  readonly subscribing = this.store.subscribing;
  readonly subscribeError = this.store.subscribeError;

  selectNotification(type: string): void {
    this.notification.set(type);
  }

  async onSubmit(): Promise<void> {
    this.store.clearSubscribeError();
    const success = await this.store.subscribeTo(
      this.fund(),
      this.fund().minAmount,
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
