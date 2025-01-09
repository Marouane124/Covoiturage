export interface Trajet {
    id?: string;
    conducteurId: string;
    villeDepart: string;
    villeArrivee: string;
    date: string;
    heure: string;
    placesDisponibles: number;
    prix: number;
    voiture: string;
    timestamp?: Date;
}