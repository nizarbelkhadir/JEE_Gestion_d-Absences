package com.gestionabsences.model;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Entity representing a Student (Etudiant).
 */
@Entity
@Table(name = "etudiants")
public class Etudiant implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "cne", unique = true, nullable = false, length = 50)
    private String cne;

    @Column(name = "nom", nullable = false, length = 100)
    private String nom;

    @Column(name = "prenom", nullable = false, length = 100)
    private String prenom;

    @Column(name = "email", unique = true, nullable = false, length = 150)
    private String email;

    // Constructors
    public Etudiant() {
    }

    public Etudiant(String cne, String nom, String prenom, String email) {
        this.cne = cne;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCne() {
        return cne;
    }

    public void setCne(String cne) {
        this.cne = cne;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // Helper for displaying full name
    public String getNomComplet() {
        return nom.toUpperCase() + " " + prenom;
    }

    @Override
    public String toString() {
        return "Etudiant{" +
                "id=" + id +
                ", cne='" + cne + '\'' +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
