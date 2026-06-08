package com.gestionabsences;

import com.gestionabsences.model.Etudiant;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Unit tests for the Etudiant model class.
 */
public class EtudiantTest {

    @Test
    public void testConstructorAndGetters() {
        Etudiant etudiant = new Etudiant("CNE123456", "Belkhadir", "Nizar", "nizar.belkhadir@univ.fr");

        assertEquals("CNE123456", etudiant.getCne());
        assertEquals("Belkhadir", etudiant.getNom());
        assertEquals("Nizar", etudiant.getPrenom());
        assertEquals("nizar.belkhadir@univ.fr", etudiant.getEmail());
    }

    @Test
    public void testSetters() {
        Etudiant etudiant = new Etudiant();
        etudiant.setId(10L);
        etudiant.setCne("CNE789");
        etudiant.setNom("Dupont");
        etudiant.setPrenom("Jean");
        etudiant.setEmail("jean.dupont@univ.fr");

        assertEquals(Long.valueOf(10L), etudiant.getId());
        assertEquals("CNE789", etudiant.getCne());
        assertEquals("Dupont", etudiant.getNom());
        assertEquals("Jean", etudiant.getPrenom());
        assertEquals("jean.dupont@univ.fr", etudiant.getEmail());
    }

    @Test
    public void testGetNomComplet() {
        Etudiant etudiant = new Etudiant("CNE999", "belkhadir", "nizar", "nizar@univ.fr");
        // getNomComplet should capitalize the last name and keep the first name as is
        assertEquals("BELKHADIR nizar", etudiant.getNomComplet());
    }
}
