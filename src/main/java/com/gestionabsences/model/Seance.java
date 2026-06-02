package com.gestionabsences.model;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 * Entity representing a Class Session (Seance).
 */
@Entity
@Table(name = "seances")
public class Seance implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "date_seance", nullable = false)
    private LocalDate dateSeance;

    @Column(name = "heure_debut", nullable = false)
    private LocalTime heureDebut;

    @Column(name = "heure_fin", nullable = false)
    private LocalTime heureFin;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cours_id", nullable = false)
    private Cours cours;

    // Constructors
    public Seance() {
    }

    public Seance(LocalDate dateSeance, LocalTime heureDebut, LocalTime heureFin, Cours cours) {
        this.dateSeance = dateSeance;
        this.heureDebut = heureDebut;
        this.heureFin = heureFin;
        this.cours = cours;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getDateSeance() {
        return dateSeance;
    }

    public void setDateSeance(LocalDate dateSeance) {
        this.dateSeance = dateSeance;
    }

    public LocalTime getHeureDebut() {
        return heureDebut;
    }

    public void setHeureDebut(LocalTime heureDebut) {
        this.heureDebut = heureDebut;
    }

    public LocalTime getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(LocalTime heureFin) {
        this.heureFin = heureFin;
    }

    public Cours getCours() {
        return cours;
    }

    public void setCours(Cours cours) {
        this.cours = cours;
    }

    // Helper for display
    public String getLabel() {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        return cours.getNomCours() + " (" + dateSeance.format(dateFormatter) + " " + heureDebut.format(timeFormatter) + " - " + heureFin.format(timeFormatter) + ")";
    }

    public String getFormattedDate() {
        if (dateSeance == null) return "";
        return dateSeance.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    @Override
    public String toString() {
        return "Seance{" +
                "id=" + id +
                ", dateSeance=" + dateSeance +
                ", heureDebut=" + heureDebut +
                ", heureFin=" + heureFin +
                ", cours=" + (cours != null ? cours.getNomCours() : "null") +
                '}';
    }
}
