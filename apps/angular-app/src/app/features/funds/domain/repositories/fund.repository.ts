import { Observable } from 'rxjs';
import { Result } from '../../../../core/errors/either';
import { Fund } from '../entities/fund.entity';

export abstract class FundRepository {
  abstract getFunds(): Observable<Result<Fund[]>>;
  abstract subscribeTo(fundId: number, amount: number, notification: string): Observable<Result<void>>;
}
