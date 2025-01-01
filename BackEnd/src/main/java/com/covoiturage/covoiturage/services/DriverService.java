package com.covoiturage.covoiturage.services;

import com.covoiturage.covoiturage.models.Driver;
import com.covoiturage.covoiturage.models.ERole;
import com.covoiturage.covoiturage.models.Role;
import com.covoiturage.covoiturage.models.User;
import com.covoiturage.covoiturage.repositories.DriverRepository;
import com.covoiturage.covoiturage.repositories.RoleRepository;
import com.covoiturage.covoiturage.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class DriverService {
    @Autowired
    private DriverRepository driverRepository;

    public Driver createDriver(Driver driver) {
        return driverRepository.save(driver);
    }

    public Optional<Driver> getDriver(String id) {
        return driverRepository.findById(id);
    }

    public Driver updateDriver(String id, Driver driver) {
        driver.setId(id);
        return driverRepository.save(driver);
    }

    public void deleteDriver(String id) {
        driverRepository.deleteById(id);
    }

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    // Méthode pour ajouter un rôle à un utilisateur
    public void addRoleToUser(String userId, String roleName) {
        Optional<User> userOptional = userRepository.findByUid(userId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            Role role = roleRepository.findByName(ERole.valueOf(roleName))
                    .orElseThrow(() -> new RuntimeException("Error: Role not found"));

            user.getRoles().add(role);
            userRepository.save(user);
        } else {
            throw new RuntimeException("Error: User not found");
        }
    }

//    public String getUserRole(String userId) {
//        // Récupérer le rôle de l'utilisateur via UserRepository
//        return userRepository.findRoleByUserId(userId)
//                .orElseThrow(() -> new RuntimeException("Error: Role not found for User ID: " + userId));
//    }


}