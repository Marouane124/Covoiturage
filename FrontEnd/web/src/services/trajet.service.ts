import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Trajet } from '../models/trajet.model';

const API_URL = 'http://192.168.100.94:8080/api/trajets';

@Injectable({
  providedIn: 'root'
})
export class TrajetService {
  constructor(private http: HttpClient) { }

  getAllTrajets(): Observable<Trajet[]> {
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    return this.http.get<Trajet[]>(API_URL, { headers });
  }

  searchTrajets(villeDepart?: string, villeArrivee?: string, date?: string): Observable<Trajet[]> {
    let params = new HttpParams();
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    if (villeDepart) {
      params = params.set('villeDepart', villeDepart);
    }
    
    if (villeArrivee) {
      params = params.set('villeArrivee', villeArrivee);
    }
    
    if (date) {
      const formattedDate = this.formatDate(date);
      params = params.set('date', formattedDate);
    }

    return this.http.get<Trajet[]>(`${API_URL}/recherche`, { headers, params });
  }

  private formatDate(date: string): string {
    if (!date) return '';
    const d = new Date(date);
    const day = String(d.getDate()).padStart(2, '0');
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const year = d.getFullYear();
    return `${day}/${month}/${year}`;
  }
  
  getTrajetById(id: string): Observable<Trajet> {
    return this.http.get<Trajet>(`${API_URL}/${id}`);
  }

  createTrajet(trajet: Trajet): Observable<Trajet> {
    return this.http.post<Trajet>(API_URL, trajet);
  }

  updateTrajet(id: string, trajet: Trajet): Observable<Trajet> {
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    return this.http.put<Trajet>(`${API_URL}/${id}`, trajet, { headers });
  }

  deleteTrajet(id: string): Observable<any> {
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    return this.http.delete(`${API_URL}/${id}`, { headers });
  }

  getStatistics(): Observable<any> {
    return this.http.get(`${API_URL}/stats`);
  }

  getRecentTrajets(): Observable<Trajet[]> {
    return this.http.get<Trajet[]>(`${API_URL}/recent`);
  }
  updateUserPreferences(preferences: any) {
    // Mock implementation: Log the preferences to the console
    console.log('Updated preferences:', preferences);
    return {
      subscribe: (callback: any) => {
        // Simulate a successful response
        setTimeout(() => {
          callback({ success: true });
        }, 1000); // Simulate a delay
      }
    };
  }
}