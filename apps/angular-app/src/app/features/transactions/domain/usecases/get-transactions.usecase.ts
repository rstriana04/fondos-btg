import { Injectable, Inject } from '@angular/core';
import { Observable } from 'rxjs';
import { Result } from '../../../../core/errors/either';
import { Transaction } from '../entities/transaction.entity';
import { TransactionRepository } from '../repositories/transaction.repository';
import { TRANSACTION_REPOSITORY } from '../../../../core/di/tokens';

@Injectable({ providedIn: 'root' })
export class GetTransactionsUseCase {
  constructor(@Inject(TRANSACTION_REPOSITORY) private readonly repository: TransactionRepository) {}

  execute(): Observable<Result<Transaction[]>> {
    return this.repository.getTransactions();
  }
}
