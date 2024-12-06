import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule, RouterModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  email: string = '';
  password: string = '';

  onSubmit() {
    // Logique de soumission du formulaire
    console.log('Email:', this.email);
    console.log('Password:', this.password);
    // Vous pouvez ajouter ici la logique pour authentifier l'utilisateur
  }
}
