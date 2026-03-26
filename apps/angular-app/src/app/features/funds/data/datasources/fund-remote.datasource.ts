import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../../../../core/http/api-client.service';
import { FundDto, UserDto } from '../dtos/fund.dto';

@Injectable({ providedIn: 'root' })
export class FundRemoteDatasource {
  private readonly api = inject(ApiClientService);

  getFunds(): Observable<FundDto[]> {
    return this.api.get<FundDto[]>('/funds');
  }

  getUser(): Observable<UserDto> {
    return this.api.get<UserDto>('/user');
  }

  subscribe(fundId: number, amount: number, notification: string): Observable<void> {
    return this.api.post<void>('/transactions', {
      type: 'subscription',
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
