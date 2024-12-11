export interface Trajet {
    id?: string;
    nomConducteur: string;
    villeDepart: string;
    villeArrivee: string;
    date: string;
    heure: string;
    placesDisponibles: number;
    prix: number;
    voiture: string;
  }