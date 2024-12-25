import { Injectable, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common'; // Importer la fonction pour vérifier l'environnement
import { Auth, createUserWithEmailAndPassword, signInWithEmailAndPassword } from '@angular/fire/auth';
import { catchError, from, map, Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
@Injectable({
  providedIn: 'root'
})
export class AuthService {
 // private apiUrl = 'http://localhost:8080/api';
  private apiUrl = 'http://192.168.137.27:8080/api';
  


  constructor(
    private auth: Auth, 
    private http: HttpClient, 
    @Inject(PLATFORM_ID) private platformId: Object
  ) {}

  register(username: string, email: string, password: string, phone: string, gender: string, city: string): Observable<any> {
    return new Observable((observer) => {
      // D'abord créer l'utilisateur dans Firebase
      createUserWithEmailAndPassword(this.auth, email, password)
        .then((userCredential) => {
          // Récupérer l'uid généré par Firebase
          const userData = {
            uid: userCredential.user.uid,  // uid généré par Firebase
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

  logout(): Observable<any> {
    return from(this.auth.signOut()).pipe(
      map(() => {
        // Nettoyer les données locales si nécessaire
        return true;
      }),
      catchError(error => {
        console.error('Logout failed:', error);
        throw error;
      })
    );
  }
}