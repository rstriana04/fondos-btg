import { Injectable, inject, signal, computed } from '@angular/core';
import { Transaction } from '../../domain/entities/transaction.entity';
import { GetTransactionsUseCase } from '../../domain/usecases/get-transactions.usecase';
import { Failure } from '../../../../core/errors/failures';

export interface TransactionStats {
  total: number;
  subscriptions: number;
  cancellations: number;
  totalSubscribed: number;
  totalCancelled: number;
}

export interface FundTotal {
  name: string;
  amount: number;
  fraction: number;
}

@Injectable({ providedIn: 'root' })
export class TransactionsStore {
  private readonly getTransactionsUseCase = inject(GetTransactionsUseCase);

  private readonly _transactions = signal<Transaction[]>([]);
  private readonly _loading = signal<boolean>(false);
  private readonly _error = signal<string | null>(null);

  readonly transactions = this._transactions.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly error = this._error.asReadonly();

  readonly stats = computed<TransactionStats>(() => {
    const txs = this._transactions();
    const subs = txs.filter(t => t.type === 'subscription');
    const cans = txs.filter(t => t.type === 'cancellation');
    return {
      total: txs.length,
      subscriptions: subs.length,
      cancellations: cans.length,
      totalSubscribed: subs.reduce((s, t) => s + t.amount, 0),
      totalCancelled: cans.reduce((s, t) => s + t.amount, 0),
    };
  });

  readonly fundTotals = computed<FundTotal[]>(() => {
    const txs = this._transactions();
    const map = new Map<string, number>();
    for (const tx of txs) {
      const name = tx.fundName;
      map.set(name, (map.get(name) ?? 0) + tx.amount);
    }
    const entries = Array.from(map.entries())
      .map(([name, amount]) => ({ name, amount, fraction: 0 }))
      .sort((a, b) => b.amount - a.amount);
    const max = entries.length > 0 ? entries[0].amount : 1;
    return entries.map(e => ({ ...e, fraction: e.amount / max }));
  });

  loadTransactions(): void {
    this._loading.set(true);
    this._error.set(null);

    this.getTransactionsUseCase.execute().subscribe({
      next: (result) => {
        result.fold(
          (failure: Failure) => {
            this._error.set(failure.message);
            this._loading.set(false);
          },
          (txs: Transaction[]) => {
            this._transactions.set(txs);
            this._loading.set(false);
          }
        );
      },
      error: () => {
        this._error.set('Error inesperado al cargar historial');
        this._loading.set(false);
      },
    });
  }
}
