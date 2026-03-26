import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClientService } from '../../../../core/http/api-client.service';
import { TransactionDto } from '../dtos/transaction.dto';
import { FundDto } from '../../../funds/data/dtos/fund.dto';

@Injectable({ providedIn: 'root' })
export class TransactionRemoteDatasource {
  private readonly api = inject(ApiClientService);

  getTransactions(): Observable<TransactionDto[]> {
    return this.api.get<TransactionDto[]>('/transactions');
  }

  getFunds(): Observable<FundDto[]> {
    return this.api.get<FundDto[]>('/funds');
  }
}
