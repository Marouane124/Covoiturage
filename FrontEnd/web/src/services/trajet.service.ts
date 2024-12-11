import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Trajet } from '../models/trajet.model';

const API_URL = 'http://localhost:8080/api/trajets';

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

  getTrajetById(id: string): Observable<Trajet> {
    return this.http.get<Trajet>(`${API_URL}/${id}`);
  }

  createTrajet(trajet: Trajet): Observable<Trajet> {
    return this.http.post<Trajet>(API_URL, trajet);
  }

  updateTrajet(id: string, trajet: Trajet): Observable<Trajet> {
    return this.http.put<Trajet>(`${API_URL}/${id}`, trajet);
  }

  deleteTrajet(id: string): Observable<any> {
    return this.http.delete(`${API_URL}/${id}`);
  }

  searchTrajets(villeDepart: string, villeArrivee: string): Observable<Trajet[]> {
    return this.http.get<Trajet[]>(`${API_URL}/recherche?villeDepart=${villeDepart}&villeArrivee=${villeArrivee}`);
  }
}