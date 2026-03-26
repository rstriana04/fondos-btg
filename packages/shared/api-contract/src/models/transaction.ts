import { NotificationMethod } from '../enums/notification-method';

export type TransactionType = 'subscription' | 'cancellation';

export interface Transaction {
  readonly id: string;
  readonly fundId: string;
  readonly fundName: string;
  readonly type: TransactionType;
  readonly amount: number;
  readonly date: string;
  readonly notificationMethod?: NotificationMethod;
}
