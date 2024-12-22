import { Routes } from '@angular/router';
import { MapComponent } from './map/map.component';
import { LoginComponent } from './login/login.component';
import { AboutComponent } from './about/about.component';
import { SignupComponent } from './signup/signup.component';
import { DashboardComponent } from './dashboard/dashboard.component';

export const routes: Routes = [
  { path: '', component: MapComponent },
  { path: 'login', component: LoginComponent },
  { path: 'map', component: MapComponent },
  { path: 'about', component: AboutComponent },
  { path: 'signup', component: SignupComponent },
  { path: 'dashboard', component: DashboardComponent},
  { path: '**', redirectTo: '' }
];
