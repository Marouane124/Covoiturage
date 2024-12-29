package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.Trajet;
import com.covoiturage.covoiturage.repositories.TrajetRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.util.List;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.security.user.name=admin",
        "spring.security.user.password=admin",
        "spring.security.user.roles=ADMIN"
})
class TrajetControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TrajetRepository trajetRepository;

    @BeforeEach
    void setup() {
        // Add test data
        trajetRepository.save(new Trajet());
        trajetRepository.save(new Trajet());
    }

    @AfterEach
    void cleanup() {
        // Clear test data
        trajetRepository.deleteAll();
    }

    @Test
    void getAllTrajets_ReturnsTrajets() throws Exception {
        mockMvc.perform(get("/api/trajets")
                        .with(user("admin").roles("ADMIN")))  // Add this line
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2));
    }

    @Test
    void getTrajetById_ReturnsTrajet() throws Exception {
        Trajet trajet = trajetRepository.save(new Trajet());
        mockMvc.perform(get("/api/trajets/" + trajet.getId()))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(trajet.getId()));
    }

    @Test
    void deleteTrajet_ReturnsNoContent() throws Exception {
        Trajet trajet = trajetRepository.save(new Trajet());
        mockMvc.perform(delete("/api/trajets/" + trajet.getId()))
                .andExpect(status().isNoContent());
    }
}
