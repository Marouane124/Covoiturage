import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut } from 'firebase/auth';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  constructor(private auth: Auth) {}

  async signIn(email: string, password: string) {
    return signInWithEmailAndPassword(this.auth, email, password);
  }

  async signUp(email: string, password: string) {
    return createUserWithEmailAndPassword(this.auth, email, password);
  }

  async signOut() {
    return signOut(this.auth);
  }

  getUser() {
    return this.auth.currentUser;
  }
}
