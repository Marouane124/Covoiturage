package com.covoiturage.covoiturage.repositories;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.covoiturage.covoiturage.models.RefreshToken;

public interface RefreshTokenRepository extends MongoRepository<RefreshToken, String> {
    Optional<RefreshToken> findByToken(String token);
}
