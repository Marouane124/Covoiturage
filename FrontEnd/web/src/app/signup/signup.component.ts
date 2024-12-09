import { AfterViewInit, Component, OnInit } from '@angular/core';
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
export class SignupComponent implements OnInit, AfterViewInit {
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

  ngAfterViewInit() {
    this.initStarfield();
  }

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

  initStarfield() {
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
