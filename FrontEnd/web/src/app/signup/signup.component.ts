import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { from } from 'rxjs';

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {
  loading = false;
  errorMessage: string = ''; 
  user = {
    name: '',
    email: '',
    password: '',
    phone: '',
    gender: '',
    city: ''
  };

  constructor(private authService: AuthService, private router: Router, @Inject(PLATFORM_ID) private platformId: Object) {}

  ngOnInit(): void {
    this.initStarfield();
  }

  onSubmit(): void {
    this.loading = true;
    this.errorMessage = ''; // Réinitialiser le message d'erreur

    this.authService.register(
      this.user.email,
      this.user.password,
      this.user.name,
      this.user.phone,
      this.user.gender,
      this.user.city
    ).subscribe({
      next: () => {
        alert('Inscription réussie !');
        this.router.navigateByUrl('/login');
      },
      error: (error) => {
        console.error('Erreur lors de l\'inscription:', error);
        this.errorMessage = (error as Error).message || 'Erreur lors de l\'inscription';
      },
      complete: () => {
        this.loading = false; // Réinitialiser le chargement
      }
    });
  }

  signInWithGoogle() {
    console.log('Google sign-in clicked');
  }

  initStarfield() {
    if (isPlatformBrowser(this.platformId)) {
      const canvas = document.getElementById('starfield') as HTMLCanvasElement;
      const ctx = canvas.getContext('2d')!;

      const resizeCanvas = () => {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
      };
      resizeCanvas();
      window.addEventListener('resize', resizeCanvas);

      const stars: Star[] = [];
      const numStars = 200;
      const centerX = canvas.width / 2;
      const centerY = canvas.height / 2;

      class Star {
        x: number;
        y: number;
        z: number;
        pz: number;

        constructor() {
          this.x = Math.random() * canvas.width - centerX;
          this.y = Math.random() * canvas.height - centerY;
          this.z = Math.random() * canvas.width;
          this.pz = this.z;
        }

        update() {
          this.z = this.z - 10;
          if (this.z < 1) {
            this.z = canvas.width;
            this.x = Math.random() * canvas.width - centerX;
            this.y = Math.random() * canvas.height - centerY;
            this.pz = this.z;
          }
        }

        draw() {
          const sx = this.x / this.z * canvas.width + centerX;
          const sy = this.y / this.z * canvas.height + centerY;
          const px = this.x / this.pz * canvas.width + centerX;
          const py = this.y / this.pz * canvas.height + centerY;
          
          this.pz = this.z;
          
          ctx.beginPath();
          ctx.moveTo(px, py);
          ctx.lineTo(sx, sy);
          ctx.strokeStyle = 'rgba(255, 255, 255, 0.5)';
          ctx.stroke();
        }
      }

      for (let i = 0; i < numStars; i++) {
        stars.push(new Star());
      }

      function animate() {
        ctx.fillStyle = 'rgb(13, 17, 23)';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        stars.forEach(star => {
          star.update();
          star.draw();
        });

        requestAnimationFrame(animate);
      }

      animate();
    }
  }
}
