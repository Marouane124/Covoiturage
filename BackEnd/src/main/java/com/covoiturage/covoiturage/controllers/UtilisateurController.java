package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.Trajet;
import com.covoiturage.covoiturage.models.Utilisateur;
import com.covoiturage.covoiturage.repositories.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class UtilisateurController {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @GetMapping("/utilisateurs")
    public List<Utilisateur> getAll() {
        return utilisateurRepository.findAll();
    }

    @GetMapping("/utilisateur")
    public Optional<Utilisateur> getUserById(@RequestParam(value = "id") String id) {
        return utilisateurRepository.findById(id);
    }

    @PostMapping("/utilisateur")
    public void saveUser(@RequestBody Utilisateur utilisateur) {
        utilisateurRepository.save(utilisateur);
    }

    @PostMapping("/utilisateur/{id}/proposerTrajet")
    public void proposerTrajet(@PathVariable String id, @RequestBody Trajet trajet) {
        Optional<Utilisateur> utilisateurOptional = utilisateurRepository.findById(id);
        if (utilisateurOptional.isPresent()) {
            Utilisateur utilisateur = utilisateurOptional.get();
            utilisateur.proposerTrajet(trajet);
            utilisateurRepository.save(utilisateur);
        }
    }

    @GetMapping("/utilisateur/{id}/rechercherTrajet")
    public void rechercherTrajet(@PathVariable String id) {
        Optional<Utilisateur> utilisateurOptional = utilisateurRepository.findById(id);
        if (utilisateurOptional.isPresent()) {
            Utilisateur utilisateur = utilisateurOptional.get();
            utilisateur.rechercherTrajet();
        }
    }
}
