package com.covoiturage.covoiturage.models;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "utilisateurs")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class  Utilisateur {
    @Id
    private String id;
    private String nom;
    private String email;
    private String motDePasse;
    private String adresse;
    private String photo;
    private String role;

    // Relations
    @OneToMany(mappedBy = "utilisateur", cascade = CascadeType.ALL)
    private List<Evaluation> evaluations;

    @OneToMany(mappedBy = "conducteur", cascade = CascadeType.ALL)
    private List<Trajet> trajets;

    public void proposerTrajet(Trajet trajet) {
        if ("conducteur".equals(this.role)) {
            this.getTrajets().add(trajet);
        } else {
            throw new IllegalStateException("Only conducteurs can propose trajets.");
        }
    }

    public void rechercherTrajet() {
        if ("passager".equals(this.role)) {
            // Logic for searching a trajet (ride)
        } else {
            throw new IllegalStateException("Only passagers can search for trajets.");
        }
    }
}
