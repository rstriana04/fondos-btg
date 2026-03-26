import { Component, input, output } from '@angular/core';
import { Subscription } from '../../../domain/entities/subscription.entity';
import { FundCategoryBadgeComponent } from '../../../../funds/presentation/components/fund-category-badge/fund-category-badge.component';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';
import { FundNamePipe } from '../../../../../core/utils/fund-name.pipe';
import { FriendlyDatePipe } from '../../../../../core/utils/date.pipe';

@Component({
  selector: 'app-subscription-card',
  standalone: true,
  imports: [FundCategoryBadgeComponent, CopCurrencyPipe, FundNamePipe, FriendlyDatePipe],
  templateUrl: './subscription-card.component.html',
  styleUrl: './subscription-card.component.scss',
})
export class SubscriptionCardComponent {
  subscription = input.required<Subscription>();
  cancelling = input<boolean>(false);
  cancel = output<Subscription>();

  onCancel(): void {
    this.cancel.emit(this.subscription());
  }
}
