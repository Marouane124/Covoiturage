package com.covoiturage.covoiturage.models;

import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "paiement")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Paiement {
    @Id
    private String id;
    private float montant;
    private Date datePaiement;
}
