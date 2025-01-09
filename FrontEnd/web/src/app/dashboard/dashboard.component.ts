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
  
  newTrajet: Trajet = {
    conducteurId: '',
    villeDepart: '',
    villeArrivee: '',
    date: '',
    heure: '',
    placesDisponibles: 1,
    prix: 0,
    voiture: ''
  };

  trajetToEdit: Trajet = {
    conducteurId: '',
    villeDepart: '',
    villeArrivee: '',
    date: '',
    heure: '',
    placesDisponibles: 1,
    prix: 0,
    voiture: ''
  };

  userProfile: any; // Ensure this is properly typed based on your user profile structure

  /*historique = [
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
  ];*/
 
  recentTrajets: Trajet[] = [];

  conducteurNames: Map<string, string> = new Map();

  notificationMessage: string | null = null;
  isSuccess: boolean = false;

  constructor(
    private trajetService: TrajetService,
    private authService: AuthService,
    private router: Router
  ) {
    Chart.register(...registerables);
  }

  ngOnInit() {
    this.loadTrajets();
    this.loadUserProfile();
    this.loadStatistics();
    this.loadRecentTrajets();
    this.showStats();

  }

  ngAfterViewInit() {
    if (this.showingStats) {
        if (this.trajets.length > 0) {
            this.initCharts();
        }
    }
  }

  loadTrajets(): void {
    console.log('Chargement des trajets...');
    this.trajetService.getAllTrajets().subscribe({
        next: (data) => {
            this.trajets = data;
            this.calculerTrajetsPageCourante();
            this.initCharts();
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
    // Prepare data for the trips chart
    const tripsPerMonth = Array(12).fill(0); // Array to hold counts for each month
    const distributionData = [0, 0, 0]; // Morning, Afternoon, Evening

    this.trajets.forEach(trajet => {
        if (trajet.date) { // Check if date is not null or undefined
            const dateParts = trajet.date.split('/'); // Assuming date is in dd/MM/yyyy format
            if (dateParts.length === 3) {
                const date = new Date(`${dateParts[2]}-${dateParts[1]}-${dateParts[0]}`); // Convert to YYYY-MM-DD
                const month = date.getMonth(); // Get month (0-11)
                if (!isNaN(month)) {
                    tripsPerMonth[month] += 1; // Increment the count for the corresponding month
                }
            } else {
                console.warn('Invalid date format:', trajet.date);
            }

            // Determine the time of day for distribution
            const hour = parseInt(trajet.heure.split(':')[0]);
            if (hour >= 5 && hour < 12) {
                distributionData[0] += 1; // Morning
            } else if (hour >= 12 && hour < 18) {
                distributionData[1] += 1; // Afternoon
            } else {
                distributionData[2] += 1; // Evening
            }
        } else {
            console.warn('Date is null or undefined for trajet:', trajet);
        }
    });

    console.log('Trips per month:', tripsPerMonth); // Log the trips per month for debugging
    console.log('Distribution data:', distributionData); // Log the distribution data for debugging

    // Graphique des trajets par mois
    const tripsChart = new Chart('tripsChart', {
        type: 'line',
        data: {
            labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'],
            datasets: [{
                label: 'Nombre de trajets',
                data: tripsPerMonth,
                borderColor: '#4CAF50',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: true
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
                data: distributionData,
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
      conducteurId: '',
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
    // Get the current user's data first
    this.authService.getCurrentUser().subscribe({
        next: (user) => {
            // Format the date to match backend expectations
            const formattedDate = this.formatDate(this.newTrajet.date);
            
            const trajetData = {
                ...this.newTrajet,
                conducteurId: user.uid, // Use the user's uid
                date: formattedDate,
                timestamp: new Date()
            };

            this.trajetService.createTrajet(trajetData).subscribe({
                next: (response) => {
                    console.log('Trajet created successfully:', response);
                    this.showNotification('Trajet added successfully!', true);
                    this.closeAddTrajetModal();
                    this.loadTrajets();
                },
                error: (error) => {
                    console.error('Error creating trajet:', error);
                    this.showNotification('Error adding trajet. Please try again.', false);
                }
            });
        },
        error: (error) => {
            console.error('Error getting current user:', error);
        }
    });
  }

  showNotification(message: string, success: boolean) {
    this.notificationMessage = message;
    this.isSuccess = success;

    // Automatically close the notification after 3 seconds
    setTimeout(() => {
      this.closeNotification();
    }, 3000);
  }

  closeNotification() {
    this.notificationMessage = null;
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
      conducteurId: '',
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
        // Format the date before sending
        this.trajetToEdit.date = this.formatDate(this.trajetToEdit.date);

        this.trajetService.updateTrajet(this.trajetToEdit.id, this.trajetToEdit).subscribe({
            next: (response) => {
                console.log('Trajet mis à jour:', response);
                this.loadTrajets(); // Recharger la liste des trajets
                this.closeEditTrajetModal();
                this.showNotification('Trajet mis à jour avec succès!', true);              
            },
            error: (error) => {
                console.error('Erreur lors de la mise à jour:', error);
                if (error.error && error.error.message) {
                    alert(error.error.message);
                } else {
                  this.showNotification('Erreur lors de la mise à jour du trajet!', true); 
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
                this.loadTrajets(); // Reload trajets
                this.loadStatistics(); // Refresh statistics
                this.showNotification('Trajet supprimé avec succès!', true);  
            },
            error: (error) => {
                console.error('Erreur lors de la suppression:', error);
                this.showNotification('Erreur lors de la suppression du trajet!', true);  
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

  async loadUserProfile() {
    try {
      const user = await this.authService.getCurrentUser().toPromise();
      if (user) {
        this.userProfile = {
          id: user.id,
          nom: user.username,
          email: user.email,
          telephone: user.phone || '',
          dateInscription: new Date().toISOString().split('T')[0], // You might want to store this in your user model
          voiture: {
            marque: user.vehicleModel || '',
            modele: user.vehicleType || '',
            annee: 2024,
            couleur: ''
          },
          statistiques: {
            totalTrajets: 45,
            totalPassagers: 132,
            evaluationMoyenne: 4.8,
            economiesCO2: 234
          },
          preferences: {
            fumeur: false,
            animaux: false,
            musique: false,
            discussion: false
          }
        };
      }
      console.log('Fetched user data:', user);
    } catch (error) {
      console.error('Error loading user profile:', error);
      // Handle error appropriately
    }
  }

  loadStatistics(): void {
    this.trajetService.getStatistics().subscribe({
        next: (data) => {
            this.totalTrajets = data.totalTrajets;
            this.totalPassagers = data.totalPassagers;
            this.economies = data.economies;
        },
        error: (error) => {
            console.error('Erreur lors du chargement des statistiques:', error);
        }
    });
  }

  totalTrajets: number = 0;
  totalPassagers: number = 0;
  economies: number = 0;

  loadRecentTrajets(): void {
    this.trajetService.getRecentTrajets().subscribe({
        next: (data) => {
            this.recentTrajets = data;
        },
        error: (error) => {
            console.error('Erreur lors du chargement des trajets récents:', error);
        }
    });
  }

  calculateDuration(date: string): string {

    // Convert DD/MM/YYYY to YYYY-MM-DD
    const parts = date.split('/');
    if (parts.length === 3) {
        const formattedDate = `${parts[2]}-${parts[1]}-${parts[0]}`; // Convert to YYYY-MM-DD
        const trajetDate = new Date(formattedDate);
        
       
        // Check if the date is valid
        if (isNaN(trajetDate.getTime())) {
            return 'Date invalide';
        }

        const now = new Date();
        const diffInMs = now.getTime() - trajetDate.getTime();
        const diffInSeconds = Math.floor(diffInMs / 1000);
        const diffInMinutes = Math.floor(diffInSeconds / 60);
        const diffInHours = Math.floor(diffInMinutes / 60);
        const diffInDays = Math.floor(diffInHours / 24);

        if (diffInDays > 0) {
            return `Il y a ${diffInDays} jour${diffInDays > 1 ? 's' : ''}`;
        } else if (diffInHours > 0) {
            return `Il y a ${diffInHours} heure${diffInHours > 1 ? 's' : ''}`;
        } else if (diffInMinutes > 0) {
            return `Il y a ${diffInMinutes} minute${diffInMinutes > 1 ? 's' : ''}`;
        } else {
            return 'Il y a quelques instants';
        }
    } else {
        return 'Date invalide';
    }
  }

  loadConducteurName(conducteurId: string) {
    if (!this.conducteurNames.has(conducteurId)) {
        this.authService.getUserByUid(conducteurId).subscribe({
            next: (user) => {
                if (user && user.username) {
                    this.conducteurNames.set(conducteurId, user.username);
                } else {
                    this.conducteurNames.set(conducteurId, 'Unknown User');
                }
            },
            error: (error) => {
                console.error('Error loading conductor name:', error);
                this.conducteurNames.set(conducteurId, 'Unknown');
            }
        });
    }
  }

  getConducteurName(conducteurId: string): string {
    if (!this.conducteurNames.has(conducteurId)) {
        this.loadConducteurName(conducteurId); // Trigger loading if not already loaded
        return 'Loading...'; // Return loading state
    }
    return this.conducteurNames.get(conducteurId) || 'Unknown User'; // Return the name or unknown
  }

  togglePreference(preference: string) {
    // Toggle the preference
    this.userProfile.preferences[preference] = !this.userProfile.preferences[preference];

    // Save the updated preferences
    this.savePreferences();
  }

  savePreferences() {
    // Call the mock method to update preferences
    this.trajetService.updateUserPreferences(this.userProfile.preferences).subscribe({
      next: (response: any) => {
        console.log('Preferences updated successfully:', response);
      },
      error: (error: any) => {
        console.error('Error updating preferences:', error);
      }
    });
  }
}
