package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.Trajet;
import com.covoiturage.covoiturage.repositories.TrajetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.HashMap;

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
    @GetMapping("/recherche")
    public ResponseEntity<List<Trajet>> rechercherTrajets(
            @RequestParam(required = false) String villeDepart,
            @RequestParam(required = false) String villeArrivee,
            @RequestParam(required = false) String date
    ) {
        try {
            List<Trajet> trajets;

            if (villeDepart != null && villeArrivee != null && date != null) {
                // Convertir la date du format dd/MM/yyyy en format ISO
                SimpleDateFormat inputFormat = new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");

                Date parsedDate = inputFormat.parse(date);
                String isoDate = outputFormat.format(parsedDate);

                // Créer les dates de début et fin pour la recherche
                Date startDate = outputFormat.parse(isoDate);
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(startDate);
                calendar.add(Calendar.DAY_OF_MONTH, 1);
                Date endDate = calendar.getTime();

                trajets = trajetRepository.findByVilleDepartAndVilleArriveeAndDateBetween(
                        villeDepart,
                        villeArrivee,
                        startDate,
                        endDate
                );
            } else if (villeDepart != null && villeArrivee != null) {
                trajets = trajetRepository.findByVilleDepartAndVilleArrivee(villeDepart, villeArrivee);
            } else if (villeDepart != null) {
                trajets = trajetRepository.findByVilleDepart(villeDepart);
            } else if (villeArrivee != null) {
                trajets = trajetRepository.findByVilleArrivee(villeArrivee);
            } else {
                trajets = trajetRepository.findAll();
            }

            return trajets.isEmpty()
                    ? new ResponseEntity<>(HttpStatus.NO_CONTENT)
                    : new ResponseEntity<>(trajets, HttpStatus.OK);

        } catch (Exception e) {
            e.printStackTrace(); // Pour le débogage
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
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
    public ResponseEntity<Trajet> createTrajet(@RequestBody @DateTimeFormat(pattern = "dd/MM/yyyy") Trajet trajet) {
        try {
            Trajet newTrajet = trajetRepository.save(trajet);
            return new ResponseEntity<>(newTrajet, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Mettre à jour un trajet
    @PutMapping("/{id}")
    public ResponseEntity<Trajet> updateTrajet(@PathVariable("id") String id, @RequestBody @DateTimeFormat(pattern = "dd/MM/yyyy") Trajet trajet) {
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

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // Total trajets
        long totalTrajets = trajetRepository.count();
        
        // Total passagers
        long totalPassagers = trajetRepository.findAll().stream()
            .mapToInt(Trajet::getPlacesDisponibles) // Assuming placesDisponibles represents the number of passengers
            .sum();
        
        // Total économies (assuming prix is the price per trajet)
        double totalEconomies = trajetRepository.findAll().stream()
            .mapToDouble(Trajet::getPrix) // Assuming prix is the price of each trajet
            .sum();

        stats.put("totalTrajets", totalTrajets);
        stats.put("totalPassagers", totalPassagers);
        stats.put("economies", totalEconomies);
        
        return new ResponseEntity<>(stats, HttpStatus.OK);
    }

    @GetMapping("/recent")
    public ResponseEntity<List<Trajet>> getRecentTrajets() {
        try {
            List<Trajet> recentTrajets = trajetRepository.findTop2ByOrderByDateDesc(); // Assuming you have this method in your repository
            if (recentTrajets.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            return new ResponseEntity<>(recentTrajets, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}