import { Component, input } from '@angular/core';

@Component({
  selector: 'app-fund-category-badge',
  standalone: true,
  templateUrl: './fund-category-badge.component.html',
  styleUrl: './fund-category-badge.component.scss',
})
export class FundCategoryBadgeComponent {
  category = input.required<'FPV' | 'FIC'>();
}
