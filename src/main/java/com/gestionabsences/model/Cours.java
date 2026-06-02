package com.gestionabsences.model;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Entity representing a Course (Cours).
 */
@Entity
@Table(name = "cours")
public class Cours implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nom_cours", nullable = false, length = 100)
    private String nomCours;

    @Column(name = "description", length = 255)
    private String description;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "professeur_id")
    private Professeur professeur;

    // Constructors
    public Cours() {
    }

    public Cours(String nomCours, String description) {
        this.nomCours = nomCours;
        this.description = description;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNomCours() {
        return nomCours;
    }

    public void setNomCours(String nomCours) {
        this.nomCours = nomCours;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Professeur getProfesseur() {
        return professeur;
    }

    public void setProfesseur(Professeur professeur) {
        this.professeur = professeur;
    }

    @Override
    public String toString() {
        return "Cours{" +
                "id=" + id +
                ", nomCours='" + nomCours + '\'' +
                ", description='" + description + '\'' +
                ", professeur=" + (professeur != null ? professeur.getNomComplet() : "null") +
                '}';
    }
}
