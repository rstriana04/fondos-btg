import { Component, inject, OnInit } from '@angular/core';
import { PortfolioStore } from '../../state/portfolio.store';
import { Subscription } from '../../../domain/entities/subscription.entity';
import { PortfolioSummaryComponent } from '../../components/portfolio-summary/portfolio-summary.component';
import { SubscriptionCardComponent } from '../../components/subscription-card/subscription-card.component';
import { LoadingSpinnerComponent } from '../../../../../shared/components/loading-spinner/loading-spinner.component';
import { ErrorMessageComponent } from '../../../../../shared/components/error-message/error-message.component';
import { FundCategoryBadgeComponent } from '../../../../funds/presentation/components/fund-category-badge/fund-category-badge.component';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';
import { FundNamePipe } from '../../../../../core/utils/fund-name.pipe';
import { FriendlyDatePipe } from '../../../../../core/utils/date.pipe';

@Component({
  selector: 'app-portfolio-page',
  standalone: true,
  imports: [
    PortfolioSummaryComponent,
    SubscriptionCardComponent,
    LoadingSpinnerComponent,
    ErrorMessageComponent,
    FundCategoryBadgeComponent,
    CopCurrencyPipe,
    FundNamePipe,
    FriendlyDatePipe,
  ],
  templateUrl: './portfolio-page.component.html',
  styleUrl: './portfolio-page.component.scss',
})
export class PortfolioPageComponent implements OnInit {
  readonly store = inject(PortfolioStore);

  ngOnInit(): void {
    this.store.loadSubscriptions();
  }

  onCancel(subscription: Subscription): void {
    this.store.cancelSubscription(subscription);
  }
}
