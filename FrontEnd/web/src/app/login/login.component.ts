import { AfterViewInit, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { from } from 'rxjs';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule, RouterModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit, AfterViewInit {
  email: string = '';
  password: string = '';
  loading: boolean = false;
  errorMessage: string = '';

  constructor(private authService: AuthService, private router: Router) {}

  ngOnInit() {}

  onSubmit() {
    this.loading = true;
    this.errorMessage = '';

    this.authService.login(this.email, this.password).subscribe({
      next: () => {
        this.router.navigate(['/dashboard']);
      },
      error: (error) => {
        console.error('Erreur lors de la connexion:', error);
        this.errorMessage = (error as Error).message || 'Erreur lors de la connexion';
      },
      complete: () => {
        this.loading = false;
      }
    });
  }

  ngAfterViewInit() {
    this.initStarfield();
  }

  initStarfield() {
    const canvas = document.getElementById('starfield') as HTMLCanvasElement;
    const ctx = canvas.getContext('2d')!;

    // Ajuster la taille du canvas
    const resizeCanvas = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    // Créer les étoiles
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

    // Initialiser les étoiles
    for (let i = 0; i < numStars; i++) {
      stars.push(new Star());
    }

    // Animation
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
