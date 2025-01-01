package com.covoiturage.covoiturage;

import com.covoiturage.covoiturage.models.ERole;
import com.covoiturage.covoiturage.models.Role;
import com.covoiturage.covoiturage.repositories.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Arrays;

@Component
public class CommandLineAppStartupRunner implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Override
    public void run(String... args) throws Exception {
        createRolesIfMissing();
    }

    private void createRolesIfMissing() {
        Arrays.asList(ERole.values()).forEach(role -> {
            if (!roleRepository.findByName(role).isPresent()) {
                Role newRole = new Role();
                newRole.setName(role);
                roleRepository.save(newRole);
                System.out.println("Role " + role + " created.");
            } else {
                System.out.println("Role " + role + " already exists.");
            }
        });
    }
}
