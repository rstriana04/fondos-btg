import { Component, inject, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { SidebarComponent } from '../../components/sidebar/sidebar.component';
import { BottomNavComponent } from '../../components/bottom-nav/bottom-nav.component';
import { BalanceHeaderComponent } from '../../../features/balance/presentation/components/balance-header/balance-header.component';
import { BalanceStore } from '../../../features/balance/presentation/state/balance.store';

@Component({
  selector: 'app-main-layout',
  standalone: true,
  imports: [RouterOutlet, SidebarComponent, BottomNavComponent, BalanceHeaderComponent],
  templateUrl: './main-layout.component.html',
  styleUrl: './main-layout.component.scss',
})
export class MainLayoutComponent implements OnInit {
  private readonly balanceStore = inject(BalanceStore);

  ngOnInit(): void {
    this.balanceStore.loadUser();
  }
}
