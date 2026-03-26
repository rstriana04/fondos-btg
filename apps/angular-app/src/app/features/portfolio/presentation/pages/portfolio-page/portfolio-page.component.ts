import { Component, inject, OnInit, signal, effect } from '@angular/core';
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
  readonly toastMessage = signal<string | null>(null);
  readonly toastType = signal<'success' | 'error'>('success');

  private toastTimer: ReturnType<typeof setTimeout> | null = null;

  constructor() {
    effect(() => {
      const success = this.store.cancelSuccess();
      if (success) {
        this.showToast(success, 'success');
        this.store.clearCancelSuccess();
      }
    });

    effect(() => {
      const error = this.store.error();
      if (error && !this.store.loading()) {
        this.showToast(error, 'error');
      }
    });
  }

  ngOnInit(): void {
    this.store.loadSubscriptions();
  }

  onCancel(subscription: Subscription): void {
    this.store.cancelSubscription(subscription);
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
