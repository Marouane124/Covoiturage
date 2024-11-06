package com.covoiturage.covoiturage.repositories;

import com.covoiturage.covoiturage.models.Utilisateur;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UtilisateurRepository extends MongoRepository<Utilisateur, String> {
}
