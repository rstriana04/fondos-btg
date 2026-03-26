import { Injectable, inject } from '@angular/core';
import { Observable, map, catchError, of, forkJoin } from 'rxjs';
import { Result, right, left } from '../../../../core/errors/either';
import { ServerFailure } from '../../../../core/errors/failures';
import { Transaction } from '../../domain/entities/transaction.entity';
import { TransactionRepository } from '../../domain/repositories/transaction.repository';
import { TransactionRemoteDatasource } from '../datasources/transaction-remote.datasource';
import { TransactionMapper } from '../mappers/transaction.mapper';

@Injectable({ providedIn: 'root' })
export class TransactionRepositoryImpl extends TransactionRepository {
  private readonly datasource = inject(TransactionRemoteDatasource);

  getTransactions(): Observable<Result<Transaction[]>> {
    return forkJoin({
      transactions: this.datasource.getTransactions(),
      funds: this.datasource.getFunds(),
    }).pipe(
      map(({ transactions, funds }) => {
        const sorted = [...transactions].sort(
          (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
        );
        return right<Transaction[]>(TransactionMapper.fromDtoList(sorted, funds));
      }),
      catchError((error) => {
        return of(left<ServerFailure>(new ServerFailure(error.message)));
      })
    );
  }
}
