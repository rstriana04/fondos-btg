import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';
import { AppComponent } from './app.component';
import { FUND_REPOSITORY, PORTFOLIO_REPOSITORY, TRANSACTION_REPOSITORY } from './core/di/tokens';
import { FundRepositoryImpl } from './features/funds/data/repositories/fund.repository-impl';
import { PortfolioRepositoryImpl } from './features/portfolio/data/repositories/portfolio.repository-impl';
import { TransactionRepositoryImpl } from './features/transactions/data/repositories/transaction.repository-impl';

describe('AppComponent', () => {
  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AppComponent],
      providers: [
        provideRouter([]),
        provideHttpClient(),
        { provide: FUND_REPOSITORY, useClass: FundRepositoryImpl },
        { provide: PORTFOLIO_REPOSITORY, useClass: PortfolioRepositoryImpl },
        { provide: TRANSACTION_REPOSITORY, useClass: TransactionRepositoryImpl },
      ],
    }).compileComponents();
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.componentInstance;
    expect(app).toBeTruthy();
  });

  it('should render main layout', () => {
    const fixture = TestBed.createComponent(AppComponent);
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('app-main-layout')).toBeTruthy();
  });
});
