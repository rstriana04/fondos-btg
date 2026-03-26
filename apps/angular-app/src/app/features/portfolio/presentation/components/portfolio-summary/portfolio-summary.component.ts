import { Component, inject } from '@angular/core';
import { BalanceStore } from '../../../../balance/presentation/state/balance.store';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';

@Component({
  selector: 'app-portfolio-summary',
  standalone: true,
  imports: [CopCurrencyPipe],
  templateUrl: './portfolio-summary.component.html',
  styleUrl: './portfolio-summary.component.scss',
})
export class PortfolioSummaryComponent {
  readonly balanceStore = inject(BalanceStore);
}
