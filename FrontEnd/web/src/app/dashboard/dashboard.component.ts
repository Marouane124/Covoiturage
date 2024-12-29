import { CommonModule } from '@angular/common';
import { Component, OnInit, AfterViewInit, ViewChild, ElementRef } from '@angular/core';
import { Chart, registerables } from 'chart.js';
import { FormsModule } from '@angular/forms';
import { TrajetService } from '../../services/trajet.service';
import { Trajet } from '../../models/trajet.model';
import { HttpClientModule } from '@angular/common/http';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, FormsModule, HttpClientModule],
  providers: [TrajetService],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit, AfterViewInit {
  @ViewChild('tripsChart') tripsChartRef!: ElementRef;
  @ViewChild('distributionChart') distributionChartRef!: ElementRef;

  trajets: Trajet[] = [];
  trajetsPageCourante: Trajet[] = [];
  pageCourante: number = 1;
  trajetsParPage: number = 8;
  nombreTotalPages: number = 0;
  
  error: string = '';
  searchForm = {
    villeDepart: '',
    villeArrivee: '',
    date: ''
  };
  isSearching: boolean = false;
  searchMessage: string = ''; 

  showingStats: boolean = false;
  showingTrajets: boolean = false;
  showingHistorique: boolean = false;
  showingSettings: boolean = false;
  showingProfile: boolean = false;
  showAddTrajetModal = false;
  showEditProfileModal: boolean = false;
  showEditTrajetModal = false;
  showDetailsModal = false;
  selectedTrajet: any = null;
  
  newTrajet = {
    nomConducteur: '',
    villeDepart: '',
    villeArrivee: '',
    date: '',
    heure: '',
    placesDisponibles: 1,
    prix: 0,
    voiture: ''
  };

  trajetToEdit: Trajet = {
    nomConducteur: '',
    villeDepart: '',
    villeArrivee: '',
    date: '',
    heure: '',
    placesDisponibles: 1,
    prix: 0,
    voiture: ''
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
 

  constructor(
    private trajetService: TrajetService,
    private router: Router,
    private authService: AuthService
  ) {
    Chart.register(...registerables);
  }

  ngOnInit() {
    this.showStats();
    this.loadTrajets();
  }

  ngAfterViewInit() {
    if (this.showingStats) {
      this.initCharts();
    }
  }

  loadTrajets(): void {
    console.log('Chargement des trajets...');
    this.trajetService.getAllTrajets().subscribe({
      next: (data) => {
        this.trajets = data;
        this.calculerTrajetsPageCourante();
      },
      error: (error) => {
        console.error('Erreur lors du chargement des trajets:', error);
        this.error = 'Erreur lors du chargement des trajets';
      }
    });
  }

  calculerTrajetsPageCourante() {
    const indexDebut = (this.pageCourante - 1) * this.trajetsParPage;
    const indexFin = indexDebut + this.trajetsParPage;
    this.trajetsPageCourante = this.trajets.slice(indexDebut, indexFin);
    this.nombreTotalPages = Math.ceil(this.trajets.length / this.trajetsParPage);
  }

  changerPage(page: number) {
    this.pageCourante = page;
    this.calculerTrajetsPageCourante();
  }
  
  showStats(): void {
    this.resetDisplayStates();
    this.showingStats = true;
    setTimeout(() => {
      this.initCharts();
    }, 100);
  }

  showTrajets(): void {
    this.resetDisplayStates();
    this.showingTrajets = true;
  }

  showHistorique(): void {
    this.resetDisplayStates();
    this.showingHistorique = true;
  }

  showProfile(): void {
    this.resetDisplayStates();
    this.showingProfile = true;
  }

  showSettings(): void {
    this.resetDisplayStates();
    this.showingSettings = true;
  }

  private resetDisplayStates(): void {
    this.showingStats = false;
    this.showingTrajets = false;
    this.showingHistorique = false;
    this.showingProfile = false;
    this.showingSettings = false;
  }

  // Données des paramètres
  settings = {
    notifications: {
      email: true,
      push: true,
      sms: false,
      nouveauxTrajets: true,
      messages: true,
      rappels: true
    },
    confidentialite: {
      profilPublic: true,
      afficherEmail: false,
      afficherTelephone: true,
      partagePosition: false
    },
    preferences: {
      langue: 'Français',
      devise: 'EUR',
      theme: 'Clair',
      fuseau: 'Europe/Paris'
    },
    paiement: {
      methodePrincipale: 'Carte Visa ****4242',
      methodesEnregistrees: [
        { type: 'card', nom: 'Visa', numero: '****4242', expiration: '12/25' },
        { type: 'paypal', email: 'user@email.com' }
      ]
    }
  };
  

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
      nomConducteur: '',
      villeDepart: '',
      villeArrivee: '',
      date: '',
      heure: '',
      placesDisponibles: 1,
      prix: 0,
      voiture: ''
    };
  }
  
  private formatDate(date: string): string {
    const d = new Date(date);
    const day = String(d.getDate()).padStart(2, '0');
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const year = d.getFullYear();
    return `${day}/${month}/${year}`; // Format dd/MM/yyyy
  }
  
  onSubmitTrajet() {
    // Formatage des données avant envoi
    const trajetToSend = {
      nomConducteur: this.newTrajet.nomConducteur,
      villeDepart: this.newTrajet.villeDepart,
      villeArrivee: this.newTrajet.villeArrivee,
      date: this.formatDate(this.newTrajet.date), // Utilisation du format correct
      heure: this.newTrajet.heure,
      placesDisponibles: parseInt(this.newTrajet.placesDisponibles.toString()),
      prix: parseFloat(this.newTrajet.prix.toString()),
      voiture: this.newTrajet.voiture
    };

    console.log('Données à envoyer:', trajetToSend); // Pour vérifier le format

    this.trajetService.createTrajet(trajetToSend).subscribe({
      next: (response) => {
        console.log('Réponse du serveur:', response);
        this.loadTrajets();
        this.closeAddTrajetModal();
        alert('Trajet créé avec succès!');
      },
      error: (error) => {
        console.error('Erreur détaillée:', error);
        if (error.error && error.error.message) {
          alert(error.error.message);
        } else {
          alert('Erreur lors de la création du trajet');
        }
      }
    });
  }
  

  openEditProfileModal(): void {
    this.showEditProfileModal = true;
  }

  closeEditProfileModal(): void {
    this.showEditProfileModal = false;
  }

  saveProfileChanges(): void {
    // Logique pour sauvegarder les modifications du profil
    console.log('Sauvegarde des modifications du profil');
    this.closeEditProfileModal();
  }

  searchTrajets(): void {
    this.isSearching = true;
    this.searchMessage = '';
    
    if (!this.searchForm.villeDepart && !this.searchForm.villeArrivee && !this.searchForm.date) {
      this.loadTrajets();
      this.isSearching = false;
      return;
    }

    this.trajetService.searchTrajets(
      this.searchForm.villeDepart,
      this.searchForm.villeArrivee,
      this.searchForm.date
    ).subscribe({
      next: (results) => {
        this.trajets = results || [];
        this.pageCourante = 1;
        this.calculerTrajetsPageCourante();
        if (!results || results.length === 0) {
          this.searchMessage = 'Aucun trajet trouvé';
        }
        this.isSearching = false;
      },
      error: (error) => {
        console.error('Erreur lors de la recherche:', error);
        this.searchMessage = 'Erreur lors de la recherche des trajets';
        this.trajets = [];
        this.isSearching = false;
      }
    });
  }

  resetSearch(): void {
    // Réinitialiser le formulaire de recherche
    this.searchForm = {
      villeDepart: '',
      villeArrivee: '',
      date: ''
    };
    this.searchMessage = '';
    this.isSearching = false;
    
    // Recharger tous les trajets
    this.loadTrajets();
  }

  // Méthode pour ouvrir le modal d'édition
  openEditTrajetModal(trajet: Trajet) {
    this.trajetToEdit = { ...trajet }; // Copie du trajet à éditer
    this.showEditTrajetModal = true;
  }

  // Méthode pour fermer le modal d'édition
  closeEditTrajetModal() {
    this.showEditTrajetModal = false;
    this.trajetToEdit = {
      nomConducteur: '',
      villeDepart: '',
      villeArrivee: '',
      date: '',
      heure: '',
      placesDisponibles: 1,
      prix: 0,
      voiture: ''
    };
  }

  // Méthode pour sauvegarder les modifications
  onSubmitEditTrajet() {
    if (this.trajetToEdit.id) {
      this.trajetService.updateTrajet(this.trajetToEdit.id, this.trajetToEdit).subscribe({
        next: (response) => {
          console.log('Trajet mis à jour:', response);
          this.loadTrajets(); // Recharger la liste des trajets
          this.closeEditTrajetModal();
          alert('Trajet mis à jour avec succès!');
        },
        error: (error) => {
          console.error('Erreur lors de la mise à jour:', error);
          if (error.error && error.error.message) {
            alert(error.error.message);
          } else {
            alert('Erreur lors de la mise à jour du trajet');
          }
        }
      });
    }
  }

  // Méthode pour supprimer un trajet
  deleteTrajet(id: string | undefined) {
    if (!id) {
      console.error('ID du trajet non défini');
      alert('Impossible de supprimer ce trajet : ID non défini');
      return;
    }

    if (confirm('Êtes-vous sûr de vouloir supprimer ce trajet ?')) {
      this.trajetService.deleteTrajet(id).subscribe({
        next: () => {
          console.log('Trajet supprimé avec succès');
          this.loadTrajets();
          alert('Trajet supprimé avec succès!');
        },
        error: (error) => {
          console.error('Erreur lors de la suppression:', error);
          alert('Erreur lors de la suppression du trajet');
        }
      });
    }
  }

  logout() {
    // Appeler la méthode de déconnexion du service d'authentification
    this.authService.logout().subscribe({
      next: () => {
        this.router.navigate(['/login']);
      },
      error: (error) => {
        console.error('Erreur lors de la déconnexion:', error);
      }
    });
  }

  showDetails(trajet: any) {
    this.selectedTrajet = trajet;
    this.showDetailsModal = true;
  }

  closeDetailsModal() {
    this.showDetailsModal = false;
    this.selectedTrajet = null;
  }
}
