package com.covoiturage.covoiturage.models;

import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "voiture")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Voiture {
    @Id
    private String id;
    private String marque;
    private String matricule;
    private String couleur;
}
