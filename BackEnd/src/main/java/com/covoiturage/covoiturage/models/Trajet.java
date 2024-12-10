package com.covoiturage.covoiturage.models;

import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;



@Document(collection = "trajet")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Trajet {
    @Id
    private String id;
    private String nomConducteur;
    private String villeDepart;     // au lieu de pointDeDepart
    private String villeArrivee;    // au lieu de destination
    private Date date;              // pour la date
    private String heure;           // pour l'heure
    private int placesDisponibles;  // au lieu de placesDispo
    private double prix;            // float vers double pour plus de précision
    private String voiture;         // String au lieu de l'objet Voiture
}

