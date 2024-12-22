package com.covoiturage.covoiturage.repositories;

import com.covoiturage.covoiturage.models.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    Optional<User> findByUid(String uid);
    Boolean existsByUsername(String username);
    Boolean existsByEmail(String email);
    Boolean existsByUid(String uid);
}
