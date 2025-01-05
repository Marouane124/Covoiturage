package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.Trajet;
import com.covoiturage.covoiturage.repositories.TrajetRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import java.util.List;
import java.util.Optional;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;

@ExtendWith(MockitoExtension.class)
class TrajetControllerTest {
    @InjectMocks
    private TrajetController trajetController;
    @Mock
    private TrajetRepository trajetRepository;
    @Test
    void getAllTrajets_ReturnsList() {
        List<Trajet> mockTrajets = List.of(new Trajet(), new Trajet());
        Mockito.when(trajetRepository.findAll()).thenReturn(mockTrajets);
        ResponseEntity<List<Trajet>> response = trajetController.getAllTrajets();
        Assertions.assertEquals(HttpStatus.OK, response.getStatusCode());
        Assertions.assertEquals(2, response.getBody().size());
    }
    @Test
    void getTrajetById_ReturnsTrajet() {
        Trajet trajet = new Trajet();
        trajet.setId("1");
        Mockito.when(trajetRepository.findById(anyString())).thenReturn(Optional.of(trajet));
        ResponseEntity<Trajet> response = trajetController.getTrajetById("1");
        Assertions.assertEquals(HttpStatus.OK, response.getStatusCode());
        Assertions.assertEquals("1", response.getBody().getId());
    }
//    @Test
//    void createTrajet_ReturnsCreatedTrajet() {
//        Trajet trajet = new Trajet();
//        Mockito.when(trajetRepository.save(any(Trajet.class))).thenReturn(trajet);
//        ResponseEntity<Trajet> response = trajetController.createTrajet(trajet);
//        Assertions.assertEquals(HttpStatus.CREATED, response.getStatusCode());
//        Assertions.assertNotNull(response.getBody());
//    }
    @Test
    void updateTrajet_ReturnsUpdatedTrajet() {
        Trajet trajet = new Trajet();
        trajet.setId("1");
        Mockito.when(trajetRepository.findById(anyString())).thenReturn(Optional.of(trajet));
        Mockito.when(trajetRepository.save(any(Trajet.class))).thenReturn(trajet);
        ResponseEntity<Trajet> response = trajetController.updateTrajet("1", trajet);
        Assertions.assertEquals(HttpStatus.OK, response.getStatusCode());
        Assertions.assertEquals("1", response.getBody().getId());
    }
    @Test
    void deleteTrajet_ReturnsNoContent() {
        Mockito.doNothing().when(trajetRepository).deleteById(anyString());
        ResponseEntity<HttpStatus> response = trajetController.deleteTrajet("1");
        Assertions.assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
    }
    @Test
    void findByVilleDepart_ReturnsTrajets() {
        List<Trajet> mockTrajets = List.of(new Trajet(), new Trajet());
        Mockito.when(trajetRepository.findByVilleDepart("Paris")).thenReturn(mockTrajets);
        ResponseEntity<List<Trajet>> response = trajetController.findByVilleDepart("Paris");
        Assertions.assertEquals(HttpStatus.OK, response.getStatusCode());
        Assertions.assertEquals(2, response.getBody().size());
    }
    @Test
    void findByVilleArrivee_ReturnsTrajets() {
        List<Trajet> mockTrajets = List.of(new Trajet(), new Trajet());
        Mockito.when(trajetRepository.findByVilleArrivee("Lyon")).thenReturn(mockTrajets);
        ResponseEntity<List<Trajet>> response = trajetController.findByVilleArrivee("Lyon");
        Assertions.assertEquals(HttpStatus.OK, response.getStatusCode());
        Assertions.assertEquals(2, response.getBody().size());
    }
    @Test
    void findByPrixLessThanEqual_ReturnsTrajets() {
        List<Trajet> mockTrajets = List.of(new Trajet(), new Trajet());
        Mockito.when(trajetRepository.findByPrixLessThanEqual(50.0)).thenReturn(mockTrajets);
        ResponseEntity<List<Trajet>> response = trajetController.findByPrixLessThanEqual(50.0);
        Assertions.assertEquals(HttpStatus.OK, response.getStatusCode());
        Assertions.assertEquals(2, response.getBody().size());
    }
}
