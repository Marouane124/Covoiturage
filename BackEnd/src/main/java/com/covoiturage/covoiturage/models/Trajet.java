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
    private String pointDeDepart;
    private String destination;
    private Date horaireDepart;
    private int placesDispo;
    private float prix;
    private Voiture voiture;
}
