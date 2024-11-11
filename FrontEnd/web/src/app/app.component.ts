import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import * as mapboxgl from 'mapbox-gl';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  standalone: true
})
export class AppComponent implements OnInit {
  map!: mapboxgl.Map;

  constructor(@Inject(PLATFORM_ID) private platformId: object) {}

  ngOnInit(): void {
    if (isPlatformBrowser(this.platformId)) {
      this.map = new mapboxgl.Map({
        container: 'map', // container ID in HTML
        style: 'mapbox://styles/mapbox/streets-v11', // style URL
        center: [0, 0], // initial map center in [lng, lat]
        zoom: 2, // initial zoom level
        accessToken: environment.mapboxToken // add the token here
      });
    }
  }

  // Get current location
  getCurrentLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords;
          this.map.flyTo({
            center: [longitude, latitude],
            zoom: 12,
          });
        },
        (error) => {
          console.error('Error getting location', error);
          alert('Failed to get location');
        }
      );
    } else {
      alert('Geolocation is not supported by this browser.');
    }
  }

  // Get location for a city or country (using simple coordinates)
  getLocation(location: string) {
    let coords: [number, number];
    switch (location.toLowerCase()) {
      case 'paris':
        coords = [2.3522, 48.8566]; // Paris coordinates
        break;
      case 'new york':
        coords = [-74.0060, 40.7128]; // New York coordinates
        break;
      case 'london':
        coords = [-0.1276, 51.5074]; // London coordinates
        break;
      default:
        alert('Location not recognized');
        return;
    }
    this.map.flyTo({
      center: coords,
      zoom: 12,
    });
  }
  resetMap() {
    this.map.flyTo({
      center: [0, 0],
      zoom: 2, // Adjust the zoom level to show the whole world
    });
  }
}
