package com.covoiturage.covoiturage.models;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Document(collection = "users")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    @Id
    private String id;
    private String uid;
    private String username;
    private String email;
    private String password;
    private String phone;
    private String gender;
   // private String adresse;
    //private String photo;
    private String city;

    // Relations
    @OneToMany(mappedBy = "utilisateur", cascade = CascadeType.ALL)
    private List<Evaluation> evaluations;

    @OneToMany(mappedBy = "conducteur", cascade = CascadeType.ALL)
    private List<Trajet> trajets;

    @DBRef
    private Set<Role> roles = new HashSet<>();

    public User(String uid, String username, String email, String phone, String gender, String city) {
        this.uid = uid;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.city = city;
    }

    public void proposerTrajet(Trajet trajet) {
        if (roles.contains("CONDUCTEUR")) {
            this.getTrajets().add(trajet);
        } else {
            throw new IllegalStateException("Only conducteurs can propose trajets.");
        }
    }

    public void rechercherTrajet() {
        if (roles.contains("PASSAGER")) {
            // Logic for searching a trajet (ride)
        } else {
            throw new IllegalStateException("Only passagers can search for trajets.");
        }
    }
}
