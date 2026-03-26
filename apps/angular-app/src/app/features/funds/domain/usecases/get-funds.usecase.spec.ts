import { TestBed } from '@angular/core/testing';
import { of } from 'rxjs';
import { GetFundsUseCase } from './get-funds.usecase';
import { FundRepository } from '../repositories/fund.repository';
import { FUND_REPOSITORY } from '../../../../core/di/tokens';
import { right, left } from '../../../../core/errors/either';
import { ServerFailure } from '../../../../core/errors/failures';
import { Fund } from '../entities/fund.entity';

describe('GetFundsUseCase', () => {
  let useCase: GetFundsUseCase;
  let mockRepo: jasmine.SpyObj<FundRepository>;

  const testFunds: Fund[] = [
    { id: 1, name: 'FPV_BTG_PACTUAL_RECAUDADORA', minAmount: 75000, category: 'FPV' },
    { id: 3, name: 'DEUDAPRIVADA', minAmount: 50000, category: 'FIC' },
  ];

  beforeEach(() => {
    mockRepo = jasmine.createSpyObj('FundRepository', ['getFunds', 'subscribeTo']);

    TestBed.configureTestingModule({
      providers: [
        GetFundsUseCase,
        { provide: FUND_REPOSITORY, useValue: mockRepo },
      ],
    });

    useCase = TestBed.inject(GetFundsUseCase);
  });

  it('should return list of funds from the repository', (done) => {
    mockRepo.getFunds.and.returnValue(of(right(testFunds)));

    useCase.execute().subscribe((result) => {
      expect(result.isRight()).toBeTrue();
      result.fold(
        () => fail('Should be Right'),
        (funds) => {
          expect(funds.length).toBe(2);
          expect(funds[0].name).toBe('FPV_BTG_PACTUAL_RECAUDADORA');
        },
      );
      expect(mockRepo.getFunds).toHaveBeenCalledTimes(1);
      done();
    });
  });

  it('should return ServerFailure when repository fails', (done) => {
    mockRepo.getFunds.and.returnValue(of(left(new ServerFailure())));

    useCase.execute().subscribe((result) => {
      expect(result.isLeft()).toBeTrue();
      result.fold(
        (failure) => expect(failure).toBeInstanceOf(ServerFailure),
        () => fail('Should be Left'),
      );
      done();
    });
  });
});
