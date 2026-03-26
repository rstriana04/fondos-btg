import { Component, input, output } from '@angular/core';
import { Fund } from '../../../domain/entities/fund.entity';
import { FundCategoryBadgeComponent } from '../fund-category-badge/fund-category-badge.component';
import { CopCurrencyPipe } from '../../../../../core/utils/currency.pipe';
import { FundNamePipe } from '../../../../../core/utils/fund-name.pipe';

@Component({
  selector: 'app-fund-card',
  standalone: true,
  imports: [FundCategoryBadgeComponent, CopCurrencyPipe, FundNamePipe],
  templateUrl: './fund-card.component.html',
  styleUrl: './fund-card.component.scss',
})
export class FundCardComponent {
  fund = input.required<Fund>();
  subscribe = output<Fund>();

  onSubscribe(): void {
    this.subscribe.emit(this.fund());
  }
}
