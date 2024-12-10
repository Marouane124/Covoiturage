import { CommonModule } from '@angular/common';
import { Component, OnInit, AfterViewInit, ViewChild, ElementRef } from '@angular/core';
import { Chart, registerables } from 'chart.js';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit, AfterViewInit {
  @ViewChild('tripsChart') tripsChartRef!: ElementRef;
  @ViewChild('distributionChart') distributionChartRef!: ElementRef;
  
  showingStats: boolean = false;

  constructor() {
    Chart.register(...registerables);
  }

  ngOnInit() {
    this.showStats();
  }

  ngAfterViewInit() {
    // Attendre que le DOM soit complètement chargé
    setTimeout(() => {
      if (this.tripsChartRef && this.distributionChartRef) {
        this.initCharts();
      }
    }, 100);
  }

  showStats() {
    this.showingStats = true;
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
          ],
          borderWidth: 0,
          borderRadius: 3
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        cutout: '70%',
        layout: {
          padding: 20
        },
        plugins: {
          legend: {
            position: 'top',
            labels: {
              padding: 15,
              usePointStyle: true,
              font: {
                size: 12,
                family: "'Arial', sans-serif"
              }
            }
          }
        }
      }
    });
  }
}
