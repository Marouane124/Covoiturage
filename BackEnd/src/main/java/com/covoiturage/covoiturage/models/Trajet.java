package com.covoiturage.covoiturage.models;

import com.fasterxml.jackson.annotation.JsonFormat;
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
    private String conducteurId;
    private String villeDepart;
    private String villeArrivee;
    @JsonFormat(pattern = "dd/MM/yyyy")
    private Date date;
    private String heure;
    private int placesDisponibles;
    private double prix;
    private String voiture;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private Date timestamp;


    // Constructor without ID (useful for new Trajet creation)
    public Trajet(String conducteurId, String villeDepart, String villeArrivee, Date date, String heure, int placesDisponibles, double prix, String voiture, Date timestamp) {
        this.conducteurId = conducteurId;
        this.villeDepart = villeDepart;
        this.villeArrivee = villeArrivee;
        this.date = date;
        this.heure = heure;
        this.placesDisponibles = placesDisponibles;
        this.prix = prix;
        this.voiture = voiture;
        this.timestamp = timestamp;
    }

    // Constructor with only mandatory fields
    public Trajet(String villeDepart, String villeArrivee, double prix) {
        this.villeDepart = villeDepart;
        this.villeArrivee = villeArrivee;
        this.prix = prix;
    }

}

