package com.covoiturage.covoiturage.repositories;

import com.covoiturage.covoiturage.models.Trajet;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface TrajetRepository extends MongoRepository<Trajet, String> {
    // Recherche par ville de départ
    List<Trajet> findByVilleDepart(String villeDepart);

    // Recherche par ville d'arrivée
    List<Trajet> findByVilleArrivee(String villeArrivee);

    // Recherche par prix inférieur ou égal
    List<Trajet> findByPrixLessThanEqual(double prix);
    @Query("{'villeDepart': ?0, 'villeArrivee': ?1, 'date': {$gte: ?2, $lt: ?3}}")
    List<Trajet> findByVilleDepartAndVilleArriveeAndDateBetween(
            String villeDepart,
            String villeArrivee,
            Date startDate,
            Date endDate
    );

    // Recherche par nom du conducteur
    List<Trajet> findByNomConducteur(String nomConducteur);

    // Recherche par date
    List<Trajet> findByDate(Date date);

    // Recherche par places disponibles supérieures ou égales
    List<Trajet> findByPlacesDisponiblesGreaterThanEqual(int places);

    // Recherche combinée ville départ et ville arrivée
    List<Trajet> findByVilleDepartAndVilleArrivee(String villeDepart, String villeArrivee);

    // Recherche par ville de départ et prix max
    List<Trajet> findByVilleDepartAndPrixLessThanEqual(String villeDepart, double prix);

    // Requête personnalisée pour rechercher des trajets avec plusieurs critères
    @Query("{ 'villeDepart': ?0, 'villeArrivee': ?1, 'date': ?2, 'placesDisponibles': { $gte: ?3 } }")
    List<Trajet> rechercherTrajets(String villeDepart, String villeArrivee, Date date, int placesMinimum);

    // Requête pour trouver les trajets disponibles (places > 0)
    @Query("{ 'placesDisponibles': { $gt: 0 } }")
    List<Trajet> findTrajetsDisponibles();
}