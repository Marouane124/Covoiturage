package com.covoiturage.covoiturage.controllers;

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
    public UtilisateurRepository utilisateurRepository;

    @GetMapping("/utilisateurs")
    public List<Utilisateur> getAll(){
        return utilisateurRepository.findAll();
    }

    @GetMapping("/utilisateur")
    public Optional<Utilisateur> getUserByName(@RequestParam(value = "id") String id){
        return utilisateurRepository.findById(id);
    }

    @PostMapping("/utilisateur")
    public void saveUserByName(@RequestBody Utilisateur utilisateur){
        utilisateurRepository.save(utilisateur);
    }

}
