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
    private String nomConducteur;
    private String villeDepart;
    private String villeArrivee;
    @JsonFormat(pattern = "dd/MM/yyyy")
    private Date date;
    private String heure;
    private int placesDisponibles;
    private double prix;
    private String voiture;
}

