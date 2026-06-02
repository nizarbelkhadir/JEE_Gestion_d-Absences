package com.gestionabsences.model;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entity representing an Absence.
 */
@Entity
@Table(name = "absences", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"etudiant_id", "seance_id"}) // Ensures an student cannot have multiple absence records for the same session
})
public class Absence implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "etudiant_id", nullable = false)
    private Etudiant etudiant;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "seance_id", nullable = false)
    private Seance seance;

    @Column(name = "date_saisie", nullable = false)
    private LocalDateTime dateSaisie;

    @Column(name = "est_justifiee", nullable = false)
    private boolean estJustifiee;

    @Column(name = "motif_justification", length = 500)
    private String motifJustification;

    @Column(name = "piece_justificative_path", length = 255)
    private String pieceJustificativePath;

    @Column(name = "status_justification", length = 50, nullable = false)
    private String statusJustification = "NONE";

    @Column(name = "motif_demande_justif", length = 1000)
    private String motifDemandeJustif;

    @Column(name = "demande_justif_file_path", length = 255)
    private String demandeJustifFilePath;

    @Column(name = "status_reclamation", length = 50, nullable = false)
    private String statusReclamation = "NONE";

    @Column(name = "motif_reclamation", length = 1000)
    private String motifReclamation;

    // Constructors
    public Absence() {
    }

    public Absence(Etudiant etudiant, Seance seance, LocalDateTime dateSaisie, boolean estJustifiee, String motifJustification) {
        this.etudiant = etudiant;
        this.seance = seance;
        this.dateSaisie = dateSaisie;
        this.estJustifiee = estJustifiee;
        this.motifJustification = motifJustification;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Etudiant getEtudiant() {
        return etudiant;
    }

    public void setEtudiant(Etudiant etudiant) {
        this.etudiant = etudiant;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public LocalDateTime getDateSaisie() {
        return dateSaisie;
    }

    public void setDateSaisie(LocalDateTime dateSaisie) {
        this.dateSaisie = dateSaisie;
    }

    public String getFormattedDateSaisie() {
        if (dateSaisie == null) return "";
        return dateSaisie.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public boolean isEstJustifiee() {
        return estJustifiee;
    }

    public void setEstJustifiee(boolean estJustifiee) {
        this.estJustifiee = estJustifiee;
    }

    public String getMotifJustification() {
        return motifJustification;
    }

    public void setMotifJustification(String motifJustification) {
        this.motifJustification = motifJustification;
    }

    public String getPieceJustificativePath() {
        return pieceJustificativePath;
    }

    public void setPieceJustificativePath(String pieceJustificativePath) {
        this.pieceJustificativePath = pieceJustificativePath;
    }

    public String getStatusJustification() {
        return statusJustification;
    }

    public void setStatusJustification(String statusJustification) {
        this.statusJustification = statusJustification;
    }

    public String getMotifDemandeJustif() {
        return motifDemandeJustif;
    }

    public void setMotifDemandeJustif(String motifDemandeJustif) {
        this.motifDemandeJustif = motifDemandeJustif;
    }

    public String getDemandeJustifFilePath() {
        return demandeJustifFilePath;
    }

    public void setDemandeJustifFilePath(String demandeJustifFilePath) {
        this.demandeJustifFilePath = demandeJustifFilePath;
    }

    public String getStatusReclamation() {
        return statusReclamation;
    }

    public void setStatusReclamation(String statusReclamation) {
        this.statusReclamation = statusReclamation;
    }

    public String getMotifReclamation() {
        return motifReclamation;
    }

    public void setMotifReclamation(String motifReclamation) {
        this.motifReclamation = motifReclamation;
    }

    @Override
    public String toString() {
        return "Absence{" +
                "id=" + id +
                ", etudiant=" + (etudiant != null ? etudiant.getNomComplet() : "null") +
                ", seance=" + (seance != null ? seance.getLabel() : "null") +
                ", dateSaisie=" + dateSaisie +
                ", estJustifiee=" + estJustifiee +
                ", motifJustification='" + motifJustification + '\'' +
                '}';
    }
}
