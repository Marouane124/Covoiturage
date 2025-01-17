package com.covoiturage.covoiturage.models;

import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "evaluation")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Evaluation {
    @Id
    private String id;
    private String note;
    private String commentaire;
}
