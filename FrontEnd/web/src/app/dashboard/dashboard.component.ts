import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Chart } from 'chart.js';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {
  showingStats: boolean = false;

  showStats() {
    this.showingStats = !this.showingStats;
    if (this.showingStats) {
      setTimeout(() => {
        this.initCharts();
      }, 0);
    }
  }

  ngOnInit() {
    // Initialiser les graphiques si nécessaire
  }

  initCharts() {
    // Graphique des trajets par mois
    const tripsChart = new Chart('tripsChart', {
      type: 'line',
      data: {
        labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin'],
        datasets: [{
          label: 'Nombre de trajets',
          data: [12, 19, 15, 25, 22, 30],
          borderColor: '#4CAF50',
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
          }
        }
      }
    });

    // Graphique de répartition
    const distributionChart = new Chart('distributionChart', {
      type: 'doughnut',
      data: {
        labels: ['Matin', 'Après-midi', 'Soir'],
        datasets: [{
          data: [35, 40, 25],
          backgroundColor: [
            '#4CAF50',
            '#2196F3',
            '#FFC107'
          ]
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
          }
        }
      }
    });
  }
}
