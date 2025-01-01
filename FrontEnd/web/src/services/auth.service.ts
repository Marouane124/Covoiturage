import { Injectable, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { Auth, createUserWithEmailAndPassword, signInWithEmailAndPassword } from '@angular/fire/auth';
import { catchError, from, map, Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {throwError} from 'rxjs';

interface StoredCredentials {
  email: string;
  password: string;
  timestamp: number;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly CREDENTIALS_KEY = 'remembered_credentials';
  private readonly EXPIRATION_TIME = 5 * 60 * 60 * 1000; // 5 heures en millisecondes
  private apiUrl = 'http://192.168.100.94:8080/api';

  constructor(
    private auth: Auth,
    private http: HttpClient,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
    // Vérifier et nettoyer les credentials expirés au démarrage
    this.checkStoredCredentials();
  }

  // Nouvelles méthodes pour "Se souvenir de moi"
  saveCredentials(email: string, password: string): void {
    if (isPlatformBrowser(this.platformId)) {
      const credentials: StoredCredentials = {
        email,
        password,
        timestamp: new Date().getTime()
      };
      localStorage.setItem(this.CREDENTIALS_KEY, JSON.stringify(credentials));
    }
  }

  getStoredCredentials(): StoredCredentials | null {
    if (!isPlatformBrowser(this.platformId)) return null;

    const stored = localStorage.getItem(this.CREDENTIALS_KEY);
    if (!stored) return null;

    const credentials: StoredCredentials = JSON.parse(stored);
    const now = new Date().getTime();

    if (now - credentials.timestamp > this.EXPIRATION_TIME) {
      this.clearStoredCredentials();
      return null;
    }

    return credentials;
  }

  clearStoredCredentials(): void {
    if (isPlatformBrowser(this.platformId)) {
      localStorage.removeItem(this.CREDENTIALS_KEY);
    }
  }

  private checkStoredCredentials(): void {
    this.getStoredCredentials(); // Cela nettoiera automatiquement si expiré
  }

  register(username: string, email: string, password: string, phone: string, gender: string, city: string): Observable<any> {
    return new Observable((observer) => {
      createUserWithEmailAndPassword(this.auth, email, password)
        .then((userCredential) => {
          const userData = {
            uid: userCredential.user.uid,  
            username: username,
            email: email,
            phone: phone,
            gender: gender,
            city: city,
            password: password
          };

          // Ensuite envoyer les données au backend Spring
          this.http.post(`${this.apiUrl}/signup`, userData).subscribe({
            next: (response) => {
              observer.next(response);
              observer.complete();
            },
            error: (error) => {
              observer.error(error);
            }
          });
        })
        .catch((error) => {
          observer.error(error);
        });
    });
  }

  // register(email: string, password: string, username: string, phone: string, gender: string, city: string): Observable<void> {
  //   return new Observable<void>((observer) => {
  //     createUserWithEmailAndPassword(this.auth, email, password)
  //       .then((userCredential) => {
  //         const user = {
  //           uid: userCredential.user.uid,
  //           email: email,
  //           username: username,
  //           phone: phone,
  //           gender: gender,
  //           city: city,
  //         };

  //         // Configuration HTTP simplifiée sans CORS
  //         const httpOptions = {
  //           headers: new HttpHeaders({
  //             'Content-Type': 'application/json'
  //           })
  //         };

  //         console.log('Données envoyées au backend:', user);
          
  //         this.http.post(`${this.apiUrl}/signup`, user, httpOptions).subscribe({
  //           next: (response) => {
  //             console.log('Réponse du serveur:', response);
  //             observer.next();
  //             observer.complete();
  //           },
  //           error: (error) => {
  //             console.error('Erreur lors de l\'enregistrement:', error);
  //             observer.error(error);
  //           }
  //         });
  //       })
  //       .catch((error) => {
  //         console.error('Échec de l\'inscription Firebase:', error.message);
  //         observer.error(error);
  //       });
  //   });
  // }

  // Méthode de login améliorée avec gestion d'erreur
  login(email: string, password: string, rememberMe: boolean = false): Observable<any> {
    return from(signInWithEmailAndPassword(this.auth, email, password))
      .pipe(
        map(() => {
          console.log('Login successful!');
          if (rememberMe) {
            this.saveCredentials(email, password);
          }
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
  logout(): Observable<any> {
    return from(this.auth.signOut()).pipe(
      map(() => {
        // Ne pas effacer les credentials si l'utilisateur a choisi de s'en souvenir
        const credentials = this.getStoredCredentials();
        if (!credentials) {
          this.clearStoredCredentials();
        }
        return true;
      }),
      catchError(error => {
        console.error('Logout failed:', error);
        throw error;
      })
    );
  }

  getCurrentUser(): Observable<any> {
    const user = this.auth.currentUser;
    if (!user) {
      return throwError(() => new Error('No authenticated user'));
    }

    return this.http.get(`${this.apiUrl}/utilisateur/${user.uid}`).pipe(
      catchError(error => {
        console.error('Error fetching user data:', error);
        return throwError(() => error);
      })
    );
  }
}

//   logout(): Observable<any> {
//     return from(this.auth.signOut()).pipe(
//       map(() => {
//         this.clearStoredCredentials(); // Nettoyer les credentials stockés
//         return true;
//       }),
//       catchError(error => {
//         console.error('Logout failed:', error);
//         throw error;
//       })
//     );
//   }
// }