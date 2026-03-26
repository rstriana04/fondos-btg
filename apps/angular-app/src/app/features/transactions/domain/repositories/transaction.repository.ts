import { Observable } from 'rxjs';
import { Result } from '../../../../core/errors/either';
import { Transaction } from '../entities/transaction.entity';

export abstract class TransactionRepository {
  abstract getTransactions(): Observable<Result<Transaction[]>>;
}
