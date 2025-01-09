import { isPlatformBrowser } from '@angular/common';
import { Component, Inject, OnDestroy, OnInit, PLATFORM_ID } from '@angular/core';
import mapboxgl from 'mapbox-gl';
import { environment } from '../../environments/environment';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { TrajetService } from '../../services/trajet.service';
import { AuthService } from '../../services/auth.service';

@Component({
    selector: 'app-map',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './map.component.html',
    styleUrls: ['./map.component.css']
})
export class MapComponent implements OnInit, OnDestroy {
  map!: mapboxgl.Map;
  startCity: string = '';
  destinationCity: string = '';
  private rotationInterval: any;
  private startMarker: mapboxgl.Marker | null = null;
  private destinationMarker: mapboxgl.Marker | null = null;
  private isFirstStartSearch: boolean = true;
  showAddTrajetModal = false;
  newTrajet = {
    conducteurId: '',
    villeDepart: '',
    villeArrivee: '',
    date: '',
    heure: '',
    placesDisponibles: 1,
    prix: 0,
    voiture: ''
  };
  notificationMessage: string | null = null;
  isSuccess: boolean = false;

  constructor(
    @Inject(PLATFORM_ID) private platformId: object,
    private router: Router,
    private trajetService: TrajetService,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    if (isPlatformBrowser(this.platformId)) {
      this.map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/satellite-streets-v12',
        center: [0, 25],    
        zoom: 1.7,          
        pitch: 40,          
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

      this.map.on('dragstart', () => this.stopAutoRotation());
      this.map.on('zoomstart', () => this.stopAutoRotation());
      this.map.on('pitchstart', () => this.stopAutoRotation());

      this.map.on('load', () => {
        this.map.setPitch(55);
        this.map.setCenter([0, 25]); 
        
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

        this.startAutoRotation();
      });
    }
  }

  private startAutoRotation() {
    this.rotationInterval = setInterval(() => {
      const currentBearing = this.map.getBearing();
      this.map.setBearing(currentBearing + 0.25);
    }, 28);
  }

  private stopAutoRotation() {
    if (this.rotationInterval) {
      clearInterval(this.rotationInterval);
      this.rotationInterval = null;
    }
  }

  ngOnDestroy() {
    this.stopAutoRotation();
    if (this.startMarker) {
      this.startMarker.remove();
    }
    if (this.destinationMarker) {
      this.destinationMarker.remove();
    }
  }

  onSearchStart(city: string) {
    if (!city.trim()) return;

    fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(city)}.json?access_token=${environment.mapboxToken}`)
        .then(response => response.json())
        .then(data => {
            if (data.features && data.features.length > 0) {
                const coordinates = data.features[0].center;

                // Remove the existing start marker if it exists
                if (this.startMarker) {
                    this.startMarker.remove();
                }

                // Create a new marker for the starting city
                this.startMarker = new mapboxgl.Marker().setLngLat(coordinates).addTo(this.map);

                // Check if this is the first search
                if (this.isFirstStartSearch) {
                    // Zoom in on the new marker for the first search
                    this.map.flyTo({ center: coordinates, zoom: 10, duration: 2000 });
                    this.isFirstStartSearch = false; // Set the flag to false after the first search
                } else {
                    // If no destination is set, just move to the new position without zooming
                    if (!this.destinationMarker) {
                        this.map.setCenter(coordinates); // Move to the new position without zooming
                    } else {
                        // If a destination is set, update the route line
                        this.updateRouteLine(); // Call to update the line
                    }
                }

            }
        })
        .catch(error => console.error('Error searching location:', error));
  }

  onSearchDestination(city: string) {
    if (!city.trim()) return;

    fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(city)}.json?access_token=${environment.mapboxToken}`)
        .then(response => response.json())
        .then(data => {
            if (data.features && data.features.length > 0) {
                const coordinates = data.features[0].center;

                // Remove the existing destination marker if it exists
                if (this.destinationMarker) {
                    this.destinationMarker.remove();
                }

                // Create a new marker for the destination city
                this.destinationMarker = new mapboxgl.Marker().setLngLat(coordinates).addTo(this.map);

                // Center the map on the midpoint of the two markers
                this.centerMapOnMarkers(); // Call the new method to center the map

                // Update the route line
                this.updateRouteLine(); // Call to update the line
            }
        })
        .catch(error => console.error('Error searching location:', error));
  }

  getCurrentLocation(): Promise<[number, number]> {
    return new Promise((resolve, reject) => {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const { latitude, longitude } = position.coords;
                    resolve([longitude, latitude]);
                },
                (error) => {
                    console.error('Error getting location', error);
                    reject('Failed to get location');
                }
            );
        } else {
            reject('Geolocation is not supported by this browser.');
        }
    });
  }

  goToCurrentLocation() {
    this.getCurrentLocation().then((coordinates) => {
        this.map.flyTo({
            center: coordinates,
            zoom: 15,
            pitch: 0,
            bearing: 0,
            duration: 2000
        });

        new mapboxgl.Marker()
            .setLngLat(coordinates)
            .addTo(this.map);
    }).catch((error) => {
        console.error('Error getting current location:', error);
    });
  }

  resetMap() {
    this.stopAutoRotation();
    this.map.flyTo({
        center: [0, 25],    
        zoom: 1.7,          
        pitch: 40,
        bearing: 0,
        duration: 2000
    });

    setTimeout(() => {
        this.startAutoRotation();
    }, 2000);
  }

  private centerMapOnMarkers() {
    // Create a bounds object to fit both markers
    const bounds = new mapboxgl.LngLatBounds();

    // Add the starting marker's coordinates if it exists
    if (this.startMarker) {
        bounds.extend(this.startMarker.getLngLat());
    }

    // Add the destination marker's coordinates if it exists
    if (this.destinationMarker) {
        bounds.extend(this.destinationMarker.getLngLat());
    }

    // Calculate the center point between the two markers
    const center = bounds.getCenter();

    // Fly to the center of the two markers with zoom level 7
    this.map.flyTo({
        center: [center.lng, center.lat],
        zoom:8, // Set zoom level to 8
        duration: 2000 // Animation duration
    });
  }

  private updateRouteLine() {
    // Remove the existing route line if it exists
    if (this.map.getSource('route')) {
        this.map.removeLayer('route');
        this.map.removeSource('route');
    }

    // Only create a new route line if both markers exist
    if (this.startMarker && this.destinationMarker) {
        this.map.addSource('route', {
            type: 'geojson',
            data: {
                type: 'Feature',
                properties: {},
                geometry: {
                    type: 'LineString',
                    coordinates: [this.startMarker.getLngLat().toArray(), this.destinationMarker.getLngLat().toArray()]
                }
            }
        });

        this.map.addLayer({
            id: 'route',
            type: 'line',
            source: 'route',
            layout: {
                'line-join': 'round',
                'line-cap': 'round'
            },
            paint: {
                'line-color': '#888',
                'line-width': 8
            }
        });
    }
  }

  openAddTripComponent() {
    this.newTrajet.villeDepart = this.startCity;
    this.newTrajet.villeArrivee = this.destinationCity;
    this.showAddTrajetModal = true;
  }

  closeAddTrajetModal() {
    this.showAddTrajetModal = false;
    this.resetNewTrajet();
  }

  resetNewTrajet() {
    this.newTrajet = {
      conducteurId: '',
      villeDepart: this.startCity,
      villeArrivee: this.destinationCity,
      date: '',
      heure: '',
      placesDisponibles: 1,
      prix: 0,
      voiture: ''
    };
  }

  onSubmitTrajet() {
    this.authService.getCurrentUser().subscribe({
      next: (user) => {
        const formattedDate = this.formatDate(this.newTrajet.date);
        
        const trajetData = {
          ...this.newTrajet,
          conducteurId: user.uid,
          date: formattedDate,
          timestamp: new Date()
        };

        this.trajetService.createTrajet(trajetData).subscribe({
          next: (response) => {
            console.log('Trajet created successfully:', response);
            this.closeAddTrajetModal();
            this.showNotification('Trajet added successfully!', true);
          },
          error: (error) => {
            console.error('Error creating trajet:', error);
            this.showNotification('Error adding trajet. Please try again.', false);
          }
        });
      },
      error: (error) => {
        console.error('Error getting current user:', error);
        this.showNotification('Error retrieving user information.', false);
      }
    });
  }

  // Add this method to format the date
  private formatDate(date: string): string {
    const d = new Date(date);
    const day = String(d.getDate()).padStart(2, '0');
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const year = d.getFullYear();
    return `${day}/${month}/${year}`; // Format dd/MM/yyyy
  }

  showNotification(message: string, success: boolean) {
    this.notificationMessage = message;
    this.isSuccess = success;

    // Automatically close the notification after 3 seconds
    setTimeout(() => {
      this.closeNotification();
    }, 3000);
  }

  closeNotification() {
    this.notificationMessage = null;
  }
}




