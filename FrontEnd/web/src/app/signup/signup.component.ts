import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
//import { Icons } from '../shared/icons';

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {
  loading = false;
  //googleIcon: string;
  user = {
    name: '',
    email: '',
    password: ''
  };

  constructor() {
   // this.googleIcon = Icons.google({ width: 24, height: 24 });
  }

  ngOnInit(): void {}

  onSubmit() {
    if (this.loading) return;
    
    this.loading = true;
    // Ajoutez ici votre logique d'inscription
    console.log('Form submitted:', this.user);
    setTimeout(() => this.loading = false, 1500); // Simulation
  }

  signInWithGoogle() {
    // Ajoutez ici votre logique de connexion Google
    console.log('Google sign-in clicked');
  }
}
