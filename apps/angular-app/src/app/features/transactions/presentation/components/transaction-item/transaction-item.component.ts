import { Component, input } from '@angular/core';
import { Transaction } from '../../../domain/entities/transaction.entity';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';
import { FundNamePipe } from '../../../../../core/utils/fund-name.pipe';
import { FriendlyDatePipe } from '../../../../../core/utils/date.pipe';

@Component({
  selector: 'app-transaction-item',
  standalone: true,
  imports: [CopCurrencyPipe, FundNamePipe, FriendlyDatePipe],
  templateUrl: './transaction-item.component.html',
  styleUrl: './transaction-item.component.scss',
})
export class TransactionItemComponent {
  transaction = input.required<Transaction>();
}
