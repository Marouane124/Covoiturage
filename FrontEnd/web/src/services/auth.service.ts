import { Injectable } from '@angular/core';
import { Auth, createUserWithEmailAndPassword, signInWithEmailAndPassword } from '@angular/fire/auth';
import { from, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  constructor(private auth: Auth) {}

  register(email: string, password: string): Observable<void> {
    return from(
      createUserWithEmailAndPassword(this.auth, email, password)
        .then(() => {
          console.log('Registration successful!');
        })
        .catch((error) => {
          console.error('Registration failed:', error.message);
          throw error; // Propager l'erreur
        })
    );
  }

  login(email: string, password: string): Observable<void> {
    return from(
      signInWithEmailAndPassword(this.auth, email, password)
        .then(() => {
          console.log('Login successful!');
        })
        .catch((error) => {
          console.error('Login failed:', error.message);
          throw error; // Propager l'erreur
        })
    );
  }
}