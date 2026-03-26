import { Injectable, inject, signal, computed } from '@angular/core';
import { ApiClientService } from '../../../../core/http/api-client.service';
import { UserDto } from '../../../funds/data/dtos/fund.dto';

@Injectable({ providedIn: 'root' })
export class BalanceStore {
  private readonly api = inject(ApiClientService);

  private readonly _balance = signal<number>(500000);
  private readonly _subscribedFunds = signal<number[]>([]);
  private readonly _loading = signal<boolean>(false);

  readonly balance = this._balance.asReadonly();
  readonly subscribedFunds = this._subscribedFunds.asReadonly();
  readonly loading = this._loading.asReadonly();

  readonly investedAmount = computed(() => {
    return 500000 - this._balance();
  });

  loadUser(): void {
    this._loading.set(true);
    this.api.get<UserDto>('/user').subscribe({
      next: (user) => {
        this._balance.set(user.balance);
        this._subscribedFunds.set(user.subscribedFunds || []);
        this._loading.set(false);
      },
      error: () => {
        this._loading.set(false);
      },
    });
  }

  refresh(): void {
    this.loadUser();
  }
}
