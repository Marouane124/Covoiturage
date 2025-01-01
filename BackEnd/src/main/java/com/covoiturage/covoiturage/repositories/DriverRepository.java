package com.covoiturage.covoiturage.repositories;


import com.covoiturage.covoiturage.models.Driver;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface DriverRepository extends MongoRepository<Driver, String> {
}
