package com.covoiturage.covoiturage.models;

import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("utilisateur")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Utilisateur {
    @Id
    private String id;
    private String name;
    private String password;
}
