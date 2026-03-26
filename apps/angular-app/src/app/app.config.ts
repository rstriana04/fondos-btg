import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';

import { routes } from './app.routes';

import { FUND_REPOSITORY, PORTFOLIO_REPOSITORY, TRANSACTION_REPOSITORY } from './core/di/tokens';
import { FundRepositoryImpl } from './features/funds/data/repositories/fund.repository-impl';
import { PortfolioRepositoryImpl } from './features/portfolio/data/repositories/portfolio.repository-impl';
import { TransactionRepositoryImpl } from './features/transactions/data/repositories/transaction.repository-impl';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(),
    { provide: FUND_REPOSITORY, useClass: FundRepositoryImpl },
    { provide: PORTFOLIO_REPOSITORY, useClass: PortfolioRepositoryImpl },
    { provide: TRANSACTION_REPOSITORY, useClass: TransactionRepositoryImpl },
  ],
};
