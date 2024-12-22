import { isPlatformBrowser } from '@angular/common';
import { Component, Inject, OnInit, PLATFORM_ID } from '@angular/core';
import mapboxgl from 'mapbox-gl';
import { environment } from '../../environments/environment';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-map',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './map.component.html',
  styleUrl: './map.component.css'
})
export class MapComponent implements OnInit {
  map!: mapboxgl.Map;
  searchInput: string = '';

  constructor(@Inject(PLATFORM_ID) private platformId: object) {}

  ngOnInit(): void {
    if (isPlatformBrowser(this.platformId)) {
      this.map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/satellite-streets-v12',
        center: [0, 0],
        zoom: 2,
        pitch: 0,
        bearing: 0,
        antialias: true,
        accessToken: environment.mapboxToken,
        maxTileCacheSize: 50,
        fadeDuration: 100,
        preserveDrawingBuffer: true,
        trackResize: true
      });

      this.map.on('movestart', () => {
        this.map.getCanvas().style.imageRendering = 'pixelated';
      });

      this.map.on('moveend', () => {
        this.map.getCanvas().style.imageRendering = 'auto';
      });

      this.map.on('load', () => {
        this.map.addLayer({
          'id': '3d-buildings',
          'source': 'composite',
          'source-layer': 'building',
          'filter': ['==', 'extrude', 'true'],
          'type': 'fill-extrusion',
          'minzoom': 15,
          'paint': {
            'fill-extrusion-color': '#aaa',
            'fill-extrusion-height': [
              'interpolate',
              ['linear'],
              ['zoom'],
              15,
              0,
              15.05,
              ['get', 'height']
            ],
            'fill-extrusion-base': [
              'interpolate',
              ['linear'],
              ['zoom'],
              15,
              0,
              15.05,
              ['get', 'min_height']
            ],
            'fill-extrusion-opacity': 0.8
          }
        });

        this.map.addControl(new mapboxgl.NavigationControl({
          visualizePitch: true
        }));
      });
    }
  }

  onSearch(searchValue: string) {
    if (!searchValue.trim()) return;
    
    fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(searchValue)}.json?access_token=${environment.mapboxToken}`)
      .then(response => response.json())
      .then(data => {
        if (data.features && data.features.length > 0) {
          const coordinates = data.features[0].center;
          this.map.flyTo({
            center: coordinates,
            zoom: 15,
            pitch: 60,
            bearing: -60,
            duration: 2000
          });
        }
      })
      .catch(error => console.error('Error searching location:', error));
  }

  getCurrentLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords;
          this.map.flyTo({
            center: [longitude, latitude],
            zoom: 15,
            pitch: 60,
            bearing: -60,
            duration: 2000
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

  resetMap() {
    this.map.flyTo({
      center: [0, 0],
      zoom: 2,
      pitch: 0,
      bearing: 0,
      duration: 2000
    });
  }
}


