package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.Trajet;
import com.covoiturage.covoiturage.repositories.TrajetRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import static org.hamcrest.Matchers.any;
import static org.springframework.data.mongodb.core.aggregation.ConditionalOperators.Switch.CaseOperator.when;
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
        trajetRepository.save(new Trajet("Paris", "Lyon", 50.0));
        trajetRepository.save(new Trajet("Marseille", "Nice", 75.0));
    }

    @AfterEach
    void cleanup() {
        // Clear test data
        trajetRepository.deleteAll();
    }

    @Test
    void getAllTrajets_ReturnsTrajets() throws Exception {
        mockMvc.perform(get("/api/trajets")
                        .with(user("admin").roles("ADMIN")))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2));
    }

    @Test
    void getTrajetById_ReturnsTrajet() throws Exception {
        Trajet trajet = trajetRepository.save(new Trajet("Bordeaux", "Toulouse", 60.0));
        mockMvc.perform(get("/api/trajets/" + trajet.getId())
                        .with(user("admin").roles("ADMIN")))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(trajet.getId()))
                .andExpect(MockMvcResultMatchers.jsonPath("$.villeDepart").value("Bordeaux"))
                .andExpect(MockMvcResultMatchers.jsonPath("$.villeArrivee").value("Toulouse"));
    }

    @Test
    void deleteTrajet_ReturnsNoContent() throws Exception {
        Trajet trajet = trajetRepository.save(new Trajet("Toulouse", "Lille", 100.0));
        mockMvc.perform(delete("/api/trajets/" + trajet.getId())
                        .with(user("admin").roles("ADMIN")))
                .andExpect(status().isNoContent());
    }

    @Test
    void findByVilleDepart_ReturnsTrajets() throws Exception {
        mockMvc.perform(get("/api/trajets/depart/Paris")
                        .with(user("admin").roles("ADMIN")))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].villeDepart").value("Paris"));
    }

    @Test
    void findByVilleArrivee_ReturnsTrajets() throws Exception {
        mockMvc.perform(get("/api/trajets/arrivee/Lyon")
                        .with(user("admin").roles("ADMIN")))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].villeArrivee").value("Lyon"));
    }

    @Test
    void findByPrixLessThanEqual_ReturnsTrajets() throws Exception {
        mockMvc.perform(get("/api/trajets/prix/60.0")
                        .with(user("admin").roles("ADMIN")))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].prix").value(50.0));
    }

}
