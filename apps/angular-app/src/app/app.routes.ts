import { Routes } from '@angular/router';
import { FundsPageComponent } from './features/funds/presentation/pages/funds-page/funds-page.component';
import { PortfolioPageComponent } from './features/portfolio/presentation/pages/portfolio-page/portfolio-page.component';
import { TransactionsPageComponent } from './features/transactions/presentation/pages/transactions-page/transactions-page.component';

export const routes: Routes = [
  { path: '', component: FundsPageComponent },
  { path: 'portfolio', component: PortfolioPageComponent },
  { path: 'transactions', component: TransactionsPageComponent },
  { path: '**', redirectTo: '' },
];
