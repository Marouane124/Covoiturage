import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { TrajetService } from '../../services/trajet.service';
import { Trajet } from '../../models/trajet.model';

@Component({
  selector: 'app-trajet',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  providers: [TrajetService],
  templateUrl: './trajet.component.html',
  styleUrl: './trajet.component.css'
})
export class TrajetComponent implements OnInit {
  trajets: Trajet[] = [];
  error: string = '';

  constructor(private trajetService: TrajetService) {
    console.log('TrajetComponent construit');
  }

  ngOnInit(): void {
    console.log('TrajetComponent initialisé');
    this.loadTrajets();
  }

  loadTrajets(): void {
    console.log('Chargement des trajets...');
    this.trajetService.getAllTrajets().subscribe({
      next: (data) => {
        console.log('Trajets reçus:', data);
        this.trajets = data;
      },
      error: (e) => {
        console.error('Erreur lors du chargement:', e);
        this.error = 'Erreur lors du chargement des trajets';
      }
    });
  }
}
