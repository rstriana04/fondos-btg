import { Component, inject, OnInit, signal } from '@angular/core';
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
}
