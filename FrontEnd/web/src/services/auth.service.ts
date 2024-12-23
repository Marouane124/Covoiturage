import { Injectable, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common'; // Importer la fonction pour vérifier l'environnement
import { Auth, createUserWithEmailAndPassword, signInWithEmailAndPassword } from '@angular/fire/auth';
import { catchError, from, map, Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'http://192.168.100.94:8080/api';

  constructor(
    private auth: Auth, 
    private http: HttpClient, 
    @Inject(PLATFORM_ID) private platformId: Object
  ) {}

  register(email: string, password: string, username: string, phone: string, gender: string, city: string): Observable<void> {
    return new Observable<void>((observer) => {
      createUserWithEmailAndPassword(this.auth, email, password)
        .then((userCredential) => {
          const user = {
            uid: userCredential.user.uid,
            email: email,
            username: username,
            phone: phone,
            gender: gender,
            city: city,
          };

          // Configuration HTTP modifiée
          const httpOptions = {
            headers: new HttpHeaders({
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // Ajout du header CORS
              'Access-Control-Allow-Origin': 'http://192.168.100.94:8080'
            }),
            withCredentials: true,
            observe: 'response' as 'response'  // Pour avoir accès à la réponse complète
          };

          console.log('Données envoyées au backend:', user);
          
          // Gestion améliorée des erreurs
          this.http.post(`${this.apiUrl}/signup`, user, httpOptions).subscribe({
            next: (response) => {
              console.log('Réponse du serveur:', response);
              observer.next();
              observer.complete();
            },
            error: (error) => {
              console.error('Erreur détaillée lors de l\'enregistrement:', {
                status: error.status,
                statusText: error.statusText,
                error: error.error,
                headers: error.headers
              });
              observer.error(error);
            }
          });
        })
        .catch((error) => {
          console.error('Échec de l\'inscription Firebase:', error.message);
          observer.error(error);
        });
    });
  }

  // Méthode de login améliorée avec gestion d'erreur
  login(email: string, password: string): Observable<any> {
    return from(signInWithEmailAndPassword(this.auth, email, password))
      .pipe(
        map(() => {
          console.log('Login successful!');
          return true;
        }),
        catchError(error => {
          console.error('Login failed:', error.message);
          throw error;
        })
      );
  }

  // Méthode pour vérifier l'état de la connexion au serveur
  checkServerConnection(): Observable<boolean> {
    return this.http.get(`${this.apiUrl}/health-check`, { observe: 'response' })
      .pipe(
        map(response => response.status === 200),
        catchError(error => {
          console.error('Erreur de connexion au serveur:', error);
          return of(false);
        })
      );
  }
}