import { Injectable, inject } from '@angular/core';
import { Observable, map, catchError, of, switchMap } from 'rxjs';
import { Result, right, left } from '../../../../core/errors/either';
import { ServerFailure, NetworkFailure } from '../../../../core/errors/failures';
import { Fund } from '../../domain/entities/fund.entity';
import { FundRepository } from '../../domain/repositories/fund.repository';
import { FundRemoteDatasource } from '../datasources/fund-remote.datasource';
import { FundMapper } from '../mappers/fund.mapper';

@Injectable({ providedIn: 'root' })
export class FundRepositoryImpl extends FundRepository {
  private readonly datasource = inject(FundRemoteDatasource);

  getFunds(): Observable<Result<Fund[]>> {
    return this.datasource.getFunds().pipe(
      map((dtos) => right<Fund[]>(FundMapper.fromDtoList(dtos))),
      catchError((error) => {
        if (error.status === 0) {
          return of(left<NetworkFailure>(new NetworkFailure()));
        }
        return of(left<ServerFailure>(new ServerFailure(error.message)));
      })
    );
  }

  subscribeTo(fundId: number, amount: number, notification: string): Observable<Result<void>> {
    return this.datasource.getUser().pipe(
      switchMap((user) => {
        const newBalance = user.balance - amount;
        const newSubscribed = [...user.subscribedFunds, fundId];
        return this.datasource.subscribe(fundId, amount, notification).pipe(
          switchMap(() => this.datasource.updateUser(newBalance, newSubscribed)),
          map(() => right<void>(undefined)),
        );
      }),
      catchError((error) => {
        return of(left<ServerFailure>(new ServerFailure(error.message)));
      })
    );
  }
}
