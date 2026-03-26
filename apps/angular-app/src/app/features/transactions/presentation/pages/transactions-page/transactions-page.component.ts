import { Component, inject, OnInit } from '@angular/core';
import { TransactionsStore } from '../../state/transactions.store';
import { TransactionItemComponent } from '../../components/transaction-item/transaction-item.component';
import { LoadingSpinnerComponent } from '../../../../../shared/components/loading-spinner/loading-spinner.component';
import { ErrorMessageComponent } from '../../../../../shared/components/error-message/error-message.component';
import { FundCategoryBadgeComponent } from '../../../../funds/presentation/components/fund-category-badge/fund-category-badge.component';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';
import { FundNamePipe } from '../../../../../core/utils/fund-name.pipe';
import { FriendlyDatePipe } from '../../../../../core/utils/date.pipe';

@Component({
  selector: 'app-transactions-page',
  standalone: true,
  imports: [
    TransactionItemComponent,
    LoadingSpinnerComponent,
    ErrorMessageComponent,
    FundCategoryBadgeComponent,
    CopCurrencyPipe,
    FundNamePipe,
    FriendlyDatePipe,
  ],
  templateUrl: './transactions-page.component.html',
  styleUrl: './transactions-page.component.scss',
})
export class TransactionsPageComponent implements OnInit {
  readonly store = inject(TransactionsStore);

  ngOnInit(): void {
    this.store.loadTransactions();
  }
}
