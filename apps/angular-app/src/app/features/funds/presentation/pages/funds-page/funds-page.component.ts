import { Component, inject, OnInit, signal, effect } from '@angular/core';
import { FundsStore } from '../../state/funds.store';
import { BalanceStore } from '../../../../balance/presentation/state/balance.store';
import { Fund } from '../../../domain/entities/fund.entity';
import { FundCardComponent } from '../../components/fund-card/fund-card.component';
import { SubscribeDialogComponent } from '../../components/subscribe-dialog/subscribe-dialog.component';
import { LoadingSpinnerComponent } from '../../../../../shared/components/loading-spinner/loading-spinner.component';
import { ErrorMessageComponent } from '../../../../../shared/components/error-message/error-message.component';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';

@Component({
  selector: 'app-funds-page',
  standalone: true,
  imports: [
    FundCardComponent,
    SubscribeDialogComponent,
    LoadingSpinnerComponent,
    ErrorMessageComponent,
    CopCurrencyPipe,
  ],
  templateUrl: './funds-page.component.html',
  styleUrl: './funds-page.component.scss',
})
export class FundsPageComponent implements OnInit {
  readonly fundsStore = inject(FundsStore);
  readonly balanceStore = inject(BalanceStore);
  readonly selectedFund = signal<Fund | null>(null);
  readonly toastMessage = signal<string | null>(null);
  readonly toastType = signal<'success' | 'error'>('success');

  private toastTimer: ReturnType<typeof setTimeout> | null = null;

  constructor() {
    effect(() => {
      const success = this.fundsStore.subscribeSuccess();
      if (success) {
        this.showToast(success, 'success');
        this.fundsStore.clearSubscribeSuccess();
      }
    });
  }

  ngOnInit(): void {
    this.fundsStore.loadFunds();
  }

  openSubscribe(fund: Fund): void {
    this.selectedFund.set(fund);
  }

  closeSubscribe(): void {
    this.selectedFund.set(null);
    this.fundsStore.loadFunds();
  }

  showToast(message: string, type: 'success' | 'error'): void {
    if (this.toastTimer) clearTimeout(this.toastTimer);
    this.toastMessage.set(message);
    this.toastType.set(type);
    this.toastTimer = setTimeout(() => this.dismissToast(), 4000);
  }

  dismissToast(): void {
    this.toastMessage.set(null);
    if (this.toastTimer) {
      clearTimeout(this.toastTimer);
      this.toastTimer = null;
    }
  }
}
