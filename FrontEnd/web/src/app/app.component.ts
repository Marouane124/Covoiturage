import { Component } from '@angular/core';
import { NavbarComponent } from './navbar/navbar.component';
import { MapComponent } from "./map/map.component";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  standalone: true,
  imports: [NavbarComponent, MapComponent]
})
export class AppComponent {
  // Le composant est maintenant vide car toute la logique de la carte
  // a été déplacée vers MapComponent
}
