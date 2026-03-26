import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../../../../core/http/api-client.service';
import { TransactionDto } from '../dtos/subscription.dto';
import { FundDto, UserDto } from '../../../funds/data/dtos/fund.dto';

@Injectable({ providedIn: 'root' })
export class PortfolioRemoteDatasource {
  private readonly api = inject(ApiClientService);

  getTransactions(): Observable<TransactionDto[]> {
    return this.api.get<TransactionDto[]>('/transactions');
  }

  getFunds(): Observable<FundDto[]> {
    return this.api.get<FundDto[]>('/funds');
  }

  getUser(): Observable<UserDto> {
    return this.api.get<UserDto>('/user');
  }

  cancelSubscription(fundId: number, amount: number, notification: string): Observable<void> {
    return this.api.post<void>('/transactions', {
      type: 'cancellation',
      fundId,
      amount,
      notification,
      date: new Date().toISOString(),
    });
  }

  updateUser(balance: number, subscribedFunds: number[]): Observable<UserDto> {
    return this.api.patch<UserDto>('/user', { balance, subscribedFunds });
  }
}
