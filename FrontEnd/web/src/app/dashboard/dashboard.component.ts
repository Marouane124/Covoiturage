import { CommonModule } from '@angular/common';
import { Component, OnInit, AfterViewInit, ViewChild, ElementRef } from '@angular/core';
import { Chart, registerables } from 'chart.js';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit, AfterViewInit {
  @ViewChild('tripsChart') tripsChartRef!: ElementRef;
  @ViewChild('distributionChart') distributionChartRef!: ElementRef;
  
  showingStats: boolean = false;
  showingTrajets: boolean = false;
  showingHistorique: boolean = false;
  showingProfile: boolean = false;

  showAddTrajetModal = false;
  newTrajet = {
    depart: '',
    arrivee: '',
    date: '',
    heure: '',
    prix: 0,
    places: 1,
    voiture: '',
    conducteur: '',
    statut: 'disponible'
  };

  userProfile = {
    id: 1,
    nom: 'Jean Dupont',
    email: 'jean.dupont@email.com',
    telephone: '06 12 34 56 78',
    dateInscription: '2024-01-15',
    voiture: {
      marque: 'Peugeot',
      modele: '308',
      annee: 2022,
      couleur: 'Gris'
    },
    statistiques: {
      totalTrajets: 45,
      totalPassagers: 132,
      evaluationMoyenne: 4.8,
      economiesCO2: 234
    },
    preferences: {
      fumeur: false,
      animaux: true,
      musique: true,
      discussion: true
    }
  };

  historique = [
    {
      id: 1,
      date: '2024-03-20',
      depart: 'Paris',
      arrivee: 'Lyon',
      prix: 35,
      statut: 'Terminé',
      conducteur: 'Jean Dupont',
      evaluation: 4.5
    },
    {
      id: 2,
      date: '2024-03-15',
      depart: 'Marseille',
      arrivee: 'Nice',
      prix: 25,
      statut: 'Terminé',
      conducteur: 'Marie Martin',
      evaluation: 5
    },
    {
      id: 3,
      date: '2024-03-10',
      depart: 'Toulouse',
      arrivee: 'Bordeaux',
      prix: 30,
      statut: 'Terminé',
      conducteur: 'Pierre Dubois',
      evaluation: 4.8
    },
    {
      id: 4,
      date: '2024-03-05',
      depart: 'Lille',
      arrivee: 'Paris',
      prix: 40,
      statut: 'Terminé',
      conducteur: 'Sophie Laurent',
      evaluation: 4.7
    },
    {
      id: 5,
      date: '2024-03-01',
      depart: 'Nantes',
      arrivee: 'Rennes',
      prix: 20,
      statut: 'Annulés',
      conducteur: 'Lucas Martin',
      evaluation: 4.9
    },
    {
      id: 6,
      date: '2024-02-28',
      depart: 'Strasbourg',
      arrivee: 'Lyon',
      prix: 45,
      statut: 'Terminé',
      conducteur: 'Emma Bernard',
      evaluation: 4.6
    },
    {
      id: 7,
      date: '2024-02-25',
      depart: 'Montpellier',
      arrivee: 'Toulouse',
      prix: 28,
      statut: 'Terminé',
      conducteur: 'Thomas Petit',
      evaluation: 4.8
    },
    {
      id: 8,
      date: '2024-02-20',
      depart: 'Bordeaux',
      arrivee: 'Paris',
      prix: 50,
      statut: 'Terminé',
      conducteur: 'Julie Moreau',
      evaluation: 4.7
    },
    {
      id: 9,
      date: '2024-02-15',
      depart: 'Lyon',
      arrivee: 'Marseille',
      prix: 38,
      statut: 'Terminé',
      conducteur: 'Antoine Durand',
      evaluation: 4.9
    },
    {
      id: 10,
      date: '2024-02-10',
      depart: 'Nice',
      arrivee: 'Montpellier',
      prix: 32,
      statut: 'Terminé',
      conducteur: 'Claire Leroy',
      evaluation: 4.8
    }
  ];
  trajets = [
    {
      id: 1,
      depart: 'Paris',
      arrivee: 'Lyon',
      date: '2024-03-25',
      heure: '08:00',
      prix: 35,
      places: 3,
      conducteur: 'Jean Dupont',
      voiture: 'Peugeot 308',
      statut: 'disponible'
    },
    {
      id: 2,
      depart: 'Marseille',
      arrivee: 'Nice',
      date: '2024-03-26',
      heure: '10:00',
      prix: 25,
      places: 4,
      conducteur: 'Marie Martin',
      voiture: 'Renault Clio',
      statut: 'disponible'
    },
    {
      id: 3,
      depart: 'Toulouse',
      arrivee: 'Bordeaux',
      date: '2024-03-27',
      heure: '09:30',
      prix: 30,
      places: 3,
      conducteur: 'Pierre Dubois',
      voiture: 'Citroën C3',
      statut: 'disponible'
    },
    {
      id: 4,
      depart: 'Lyon',
      arrivee: 'Paris',
      date: '2024-03-28',
      heure: '07:00',
      prix: 38,
      places: 4,
      conducteur: 'Sophie Laurent',
      voiture: 'Volkswagen Golf',
      statut: 'disponible'
    },
    {
      id: 5,
      depart: 'Nantes',
      arrivee: 'Rennes',
      date: '2024-03-29',
      heure: '11:00',
      prix: 20,
      places: 3,
      conducteur: 'Lucas Martin',
      voiture: 'Ford Fiesta',
      statut: 'disponible'
    },
    {
      id: 6,
      depart: 'Strasbourg',
      arrivee: 'Lyon',
      date: '2024-03-30',
      heure: '08:30',
      prix: 45,
      places: 4,
      conducteur: 'Emma Bernard',
      voiture: 'Toyota Yaris',
      statut: 'disponible'
    },
    {
      id: 7,
      depart: 'Lille',
      arrivee: 'Paris',
      date: '2024-03-31',
      heure: '09:00',
      prix: 32,
      places: 3,
      conducteur: 'Thomas Petit',
      voiture: 'Opel Corsa',
      statut: 'disponible'
    },
    {
      id: 8,
      depart: 'Bordeaux',
      arrivee: 'Toulouse',
      date: '2024-04-01',
      heure: '10:30',
      prix: 28,
      places: 4,
      conducteur: 'Julie Moreau',
      voiture: 'Seat Ibiza',
      statut: 'disponible'
    },
    {
      id: 9,
      depart: 'Nice',
      arrivee: 'Marseille',
      date: '2024-04-02',
      heure: '14:00',
      prix: 27,
      places: 3,
      conducteur: 'Antoine Durand',
      voiture: 'Fiat 500',
      statut: 'disponible'
    },
    {
      id: 10,
      depart: 'Rennes',
      arrivee: 'Nantes',
      date: '2024-04-03',
      heure: '15:30',
      prix: 22,
      places: 4,
      conducteur: 'Claire Leroy',
      voiture: 'Peugeot 208',
      statut: 'disponible'
    },
    {
      id: 11,
      depart: 'Montpellier',
      arrivee: 'Lyon',
      date: '2024-04-04',
      heure: '08:45',
      prix: 42,
      places: 3,
      conducteur: 'Hugo Martin',
      voiture: 'Renault Captur',
      statut: 'disponible'
    },
    {
      id: 12,
      depart: 'Paris',
      arrivee: 'Strasbourg',
      date: '2024-04-05',
      heure: '07:30',
      prix: 48,
      places: 4,
      conducteur: 'Laura Blanc',
      voiture: 'Volkswagen Polo',
      statut: 'disponible'
    },
    {
      id: 13,
      depart: 'Lyon',
      arrivee: 'Marseille',
      date: '2024-04-06',
      heure: '11:15',
      prix: 36,
      places: 3,
      conducteur: 'Nicolas Roux',
      voiture: 'Citroën C4',
      statut: 'disponible'
    },
    {
      id: 14,
      depart: 'Toulouse',
      arrivee: 'Montpellier',
      date: '2024-04-07',
      heure: '13:00',
      prix: 26,
      places: 4,
      conducteur: 'Sarah Dubois',
      voiture: 'Dacia Sandero',
      statut: 'disponible'
    },
    {
      id: 15,
      depart: 'Bordeaux',
      arrivee: 'Paris',
      date: '2024-04-08',
      heure: '06:45',
      prix: 52,
      places: 3,
      conducteur: 'Paul Lambert',
      voiture: 'Skoda Fabia',
      statut: 'disponible'
    }
  ];

  constructor() {
    Chart.register(...registerables);
  }

  ngOnInit() {
    this.showStats();
  }

  ngAfterViewInit() {
    if (this.showingStats) {
      this.initCharts();
    }
  }

  showStats() {
    this.showingStats = true;
    this.showingTrajets = false;
    this.showingHistorique = false;
    this.showingProfile = false;
    setTimeout(() => {
      this.initCharts();
    }, 100);
  }

  showTrajets() {
    this.showingStats = false;
    this.showingTrajets = true;
    this.showingHistorique = false;
    this.showingProfile = false;
  }

  showHistorique() {
    this.showingStats = false;
    this.showingTrajets = false;
    this.showingHistorique = true;
    this.showingProfile = false;
  }

  showProfile() {
    this.showingStats = false;
    this.showingTrajets = false;
    this.showingHistorique = false;
    this.showingProfile = true;
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

  openAddTrajetModal() {
    this.showAddTrajetModal = true;
  }

  closeAddTrajetModal() {
    this.showAddTrajetModal = false;
    this.resetNewTrajet();
  }

  resetNewTrajet() {
    this.newTrajet = {
      depart: '',
      arrivee: '',
      date: '',
      heure: '',
      prix: 0,
      places: 1,
      voiture: '',
      conducteur: '',
      statut: 'disponible'
    };
  }

  onSubmitTrajet() {
    // Ajouter la logique pour sauvegarder le trajet
    console.log('Nouveau trajet:', this.newTrajet);
    this.trajets.push({
      id: this.trajets.length + 1,
      ...this.newTrajet
    });
    this.closeAddTrajetModal();
  }

  // État du modal d'édition du profil
  showEditProfileModal = false;
  editedProfile: any = {}; // Pour stocker les modifications temporaires

  openEditProfileModal() {
    this.editedProfile = { ...this.userProfile };
    this.showEditProfileModal = true;
  }

  closeEditProfileModal() {
    this.showEditProfileModal = false;
  }

  onSubmitProfile() {
    this.userProfile = { ...this.editedProfile };
    this.closeEditProfileModal();
  }
}
