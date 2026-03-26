import { Component, inject, OnInit, signal, computed } from '@angular/core';
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

  readonly searchQuery = signal('');
  readonly typeFilter = signal<string | null>(null);
  readonly categoryFilter = signal<string | null>(null);
  readonly notificationFilter = signal<string | null>(null);
  readonly showCharts = signal(true);

  readonly filteredTransactions = computed(() => {
    let txs = this.store.transactions();
    const query = this.searchQuery().toLowerCase();
    const type = this.typeFilter();
    const cat = this.categoryFilter();
    const notif = this.notificationFilter();

    if (query) {
      txs = txs.filter(t => t.fundName.toLowerCase().includes(query));
    }
    if (type) {
      txs = txs.filter(t => t.type === type);
    }
    if (cat) {
      txs = txs.filter(t => t.category === cat);
    }
    if (notif) {
      txs = txs.filter(t => t.notification.toLowerCase() === notif.toLowerCase());
    }
    return txs;
  });

  readonly hasActiveFilters = computed(() =>
    !!this.searchQuery() || !!this.typeFilter() || !!this.categoryFilter() || !!this.notificationFilter()
  );

  readonly subscriptionPct = computed(() => {
    const stats = this.store.stats();
    return stats.total > 0 ? Math.round((stats.subscriptions / stats.total) * 100) : 0;
  });

  readonly cancellationPct = computed(() => {
    const stats = this.store.stats();
    return stats.total > 0 ? Math.round((stats.cancellations / stats.total) * 100) : 0;
  });

  ngOnInit(): void {
    this.store.loadTransactions();
  }

  onSearchInput(event: Event): void {
    this.searchQuery.set((event.target as HTMLInputElement).value);
  }

  setTypeFilter(value: string | null): void {
    this.typeFilter.set(value);
  }

  setCategoryFilter(value: string | null): void {
    this.categoryFilter.set(value);
  }

  setNotificationFilter(value: string | null): void {
    this.notificationFilter.set(value);
  }

  clearFilters(): void {
    this.searchQuery.set('');
    this.typeFilter.set(null);
    this.categoryFilter.set(null);
    this.notificationFilter.set(null);
  }

  toggleCharts(): void {
    this.showCharts.update(v => !v);
  }

  formatCurrency(value: number): string {
    return '$' + Math.round(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  }
}
