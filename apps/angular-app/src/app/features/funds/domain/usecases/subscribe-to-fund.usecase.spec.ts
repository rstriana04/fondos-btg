import { TestBed } from '@angular/core/testing';
import { of } from 'rxjs';
import { SubscribeToFundUseCase, SubscribeParams } from './subscribe-to-fund.usecase';
import { FundRepository } from '../repositories/fund.repository';
import { FUND_REPOSITORY } from '../../../../core/di/tokens';
import { right } from '../../../../core/errors/either';
import { InsufficientBalanceFailure, AlreadySubscribedFailure } from '../../../../core/errors/failures';
import { Fund } from '../entities/fund.entity';

describe('SubscribeToFundUseCase', () => {
  let useCase: SubscribeToFundUseCase;
  let mockRepo: jasmine.SpyObj<FundRepository>;

  const testFund: Fund = {
    id: 4,
    name: 'FDO-ACCIONES',
    minAmount: 250000,
    category: 'FIC',
  };

  beforeEach(() => {
    mockRepo = jasmine.createSpyObj('FundRepository', ['getFunds', 'subscribeTo']);

    TestBed.configureTestingModule({
      providers: [
        SubscribeToFundUseCase,
        { provide: FUND_REPOSITORY, useValue: mockRepo },
      ],
    });

    useCase = TestBed.inject(SubscribeToFundUseCase);
  });

  it('should return InsufficientBalanceFailure when balance is less than minAmount', (done) => {
    const params: SubscribeParams = {
      fund: testFund,
      amount: 250000,
      notification: 'EMAIL',
      currentBalance: 100000,
      subscribedFundIds: [],
    };

    useCase.execute(params).subscribe((result) => {
      expect(result.isLeft()).toBeTrue();
      result.fold(
        (failure) => expect(failure).toBeInstanceOf(InsufficientBalanceFailure),
        () => fail('Should be Left'),
      );
      expect(mockRepo.subscribeTo).not.toHaveBeenCalled();
      done();
    });
  });

  it('should return AlreadySubscribedFailure when fund is already subscribed', (done) => {
    const params: SubscribeParams = {
      fund: testFund,
      amount: 250000,
      notification: 'SMS',
      currentBalance: 500000,
      subscribedFundIds: [4],
    };

    useCase.execute(params).subscribe((result) => {
      expect(result.isLeft()).toBeTrue();
      result.fold(
        (failure) => expect(failure).toBeInstanceOf(AlreadySubscribedFailure),
        () => fail('Should be Left'),
      );
      expect(mockRepo.subscribeTo).not.toHaveBeenCalled();
      done();
    });
  });

  it('should call repository when validation passes', (done) => {
    mockRepo.subscribeTo.and.returnValue(of(right(undefined as void)));

    const params: SubscribeParams = {
      fund: testFund,
      amount: 250000,
      notification: 'EMAIL',
      currentBalance: 500000,
      subscribedFundIds: [],
    };

    useCase.execute(params).subscribe((result) => {
      expect(result.isRight()).toBeTrue();
      expect(mockRepo.subscribeTo).toHaveBeenCalledWith(4, 250000, 'EMAIL');
      done();
    });
  });
});
