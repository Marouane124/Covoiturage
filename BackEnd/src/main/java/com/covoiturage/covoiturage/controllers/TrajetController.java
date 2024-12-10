package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.Trajet;
import com.covoiturage.covoiturage.repositories.TrajetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("/api/trajets")
public class TrajetController {

    @Autowired
    private TrajetRepository trajetRepository;

    // Récupérer tous les trajets
    @GetMapping
    public ResponseEntity<List<Trajet>> getAllTrajets() {
        try {
            List<Trajet> trajets = trajetRepository.findAll();
            if (trajets.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            return new ResponseEntity<>(trajets, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Récupérer un trajet par son ID
    @GetMapping("/{id}")
    public ResponseEntity<Trajet> getTrajetById(@PathVariable("id") String id) {
        Optional<Trajet> trajetData = trajetRepository.findById(id);
        if (trajetData.isPresent()) {
            return new ResponseEntity<>(trajetData.get(), HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Créer un nouveau trajet
    @PostMapping
    public ResponseEntity<Trajet> createTrajet(@RequestBody Trajet trajet) {
        try {
            Trajet newTrajet = trajetRepository.save(trajet);
            return new ResponseEntity<>(newTrajet, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Mettre à jour un trajet
    @PutMapping("/{id}")
    public ResponseEntity<Trajet> updateTrajet(@PathVariable("id") String id, @RequestBody Trajet trajet) {
        Optional<Trajet> trajetData = trajetRepository.findById(id);

        if (trajetData.isPresent()) {
            Trajet updatedTrajet = trajetData.get();
            updatedTrajet.setNomConducteur(trajet.getNomConducteur());
            updatedTrajet.setVilleDepart(trajet.getVilleDepart());
            updatedTrajet.setVilleArrivee(trajet.getVilleArrivee());
            updatedTrajet.setDate(trajet.getDate());
            updatedTrajet.setHeure(trajet.getHeure());
            updatedTrajet.setPlacesDisponibles(trajet.getPlacesDisponibles());
            updatedTrajet.setPrix(trajet.getPrix());
            updatedTrajet.setVoiture(trajet.getVoiture());

            return new ResponseEntity<>(trajetRepository.save(updatedTrajet), HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Supprimer un trajet
    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> deleteTrajet(@PathVariable("id") String id) {
        try {
            trajetRepository.deleteById(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Supprimer tous les trajets
    @DeleteMapping
    public ResponseEntity<HttpStatus> deleteAllTrajets() {
        try {
            trajetRepository.deleteAll();
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Rechercher des trajets par ville de départ
    @GetMapping("/depart/{villeDepart}")
    public ResponseEntity<List<Trajet>> findByVilleDepart(@PathVariable String villeDepart) {
        try {
            List<Trajet> trajets = trajetRepository.findByVilleDepart(villeDepart);
            if (trajets.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            return new ResponseEntity<>(trajets, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Rechercher des trajets par ville d'arrivée
    @GetMapping("/arrivee/{villeArrivee}")
    public ResponseEntity<List<Trajet>> findByVilleArrivee(@PathVariable String villeArrivee) {
        try {
            List<Trajet> trajets = trajetRepository.findByVilleArrivee(villeArrivee);
            if (trajets.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            return new ResponseEntity<>(trajets, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Rechercher des trajets par prix maximum
    @GetMapping("/prix/{maxPrix}")
    public ResponseEntity<List<Trajet>> findByPrixLessThanEqual(@PathVariable double maxPrix) {
        try {
            List<Trajet> trajets = trajetRepository.findByPrixLessThanEqual(maxPrix);
            if (trajets.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            return new ResponseEntity<>(trajets, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}