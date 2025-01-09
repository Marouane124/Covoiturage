package com.covoiturage.covoiturage.services;


import com.covoiturage.covoiturage.models.Paiement;
import com.covoiturage.covoiturage.repositories.PaiementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PaiementService {
    @Autowired
    private PaiementRepository paiementRepository;

    public List<Paiement> getAllPaiements() {
        return paiementRepository.findAll();
    }

    public Optional<Paiement> getPaiementById(String id) {
        return paiementRepository.findById(id);
    }

    public Paiement savePaiement(Paiement paiement) {
        return paiementRepository.save(paiement);
    }

    public void deletePaiement(String id) {
        paiementRepository.deleteById(id);
    }

    public Paiement updatePaiement(String id, Paiement paiementDetails) {
        Paiement paiement = paiementRepository.findById(id).orElseThrow(() -> new RuntimeException("Paiement not found"));
        paiement.setCarteBancaire(paiementDetails.getCarteBancaire());
        paiement.setNumeroCarte(paiementDetails.getNumeroCarte());
        paiement.setDateExpiration(paiementDetails.getDateExpiration());
        paiement.setMontant(paiementDetails.getMontant());
        return paiementRepository.save(paiement);
    }
}

