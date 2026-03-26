import { InjectionToken } from '@angular/core';
import { FundRepository } from '../../features/funds/domain/repositories/fund.repository';
import { PortfolioRepository } from '../../features/portfolio/domain/repositories/portfolio.repository';
import { TransactionRepository } from '../../features/transactions/domain/repositories/transaction.repository';

export const FUND_REPOSITORY = new InjectionToken<FundRepository>('FundRepository');
export const PORTFOLIO_REPOSITORY = new InjectionToken<PortfolioRepository>('PortfolioRepository');
export const TRANSACTION_REPOSITORY = new InjectionToken<TransactionRepository>('TransactionRepository');
