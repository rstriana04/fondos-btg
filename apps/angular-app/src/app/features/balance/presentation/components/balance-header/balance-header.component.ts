import { Component, inject } from '@angular/core';
import { BalanceStore } from '../../state/balance.store';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';

@Component({
  selector: 'app-balance-header',
  standalone: true,
  imports: [CopCurrencyPipe],
  templateUrl: './balance-header.component.html',
  styleUrl: './balance-header.component.scss',
})
export class BalanceHeaderComponent {
  readonly store = inject(BalanceStore);
}
