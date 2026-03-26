import { Injectable, inject, signal } from '@angular/core';
import { Transaction } from '../../domain/entities/transaction.entity';
import { GetTransactionsUseCase } from '../../domain/usecases/get-transactions.usecase';
import { Failure } from '../../../../core/errors/failures';

@Injectable({ providedIn: 'root' })
export class TransactionsStore {
  private readonly getTransactionsUseCase = inject(GetTransactionsUseCase);

  private readonly _transactions = signal<Transaction[]>([]);
  private readonly _loading = signal<boolean>(false);
  private readonly _error = signal<string | null>(null);

  readonly transactions = this._transactions.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly error = this._error.asReadonly();

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
