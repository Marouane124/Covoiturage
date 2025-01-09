package com.covoiturage.covoiturage.controllers;


import com.covoiturage.covoiturage.models.Paiement;
import com.covoiturage.covoiturage.services.PaiementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/paiements")
@CrossOrigin(origins = "http://localhost:3000")
public class PaiementController {
    @Autowired
    private PaiementService paiementService;

    @GetMapping
    public List<Paiement> getAllPayments() {
        return paiementService.getAllPaiements();
    }

    @GetMapping("/{id}")
    public Paiement getPaiementById(@PathVariable String id) {
        return paiementService.getPaiementById(id).orElseThrow(() -> new RuntimeException("Paiement not found"));
    }

    @PostMapping
    public Paiement createPaiement(@RequestBody Paiement paiement) {
        return paiementService.savePaiement(paiement);
    }

    @PutMapping("/{id}")
    public Paiement updatePaiement(@PathVariable String id, @RequestBody Paiement paiementDetails) {
        return paiementService.updatePaiement(id, paiementDetails);
    }

    @DeleteMapping("/{id}")
    public void deletePaiement(@PathVariable String id) {
        paiementService.deletePaiement(id);
    }
}

