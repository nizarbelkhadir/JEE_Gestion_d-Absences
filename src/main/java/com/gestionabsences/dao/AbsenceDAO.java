package com.gestionabsences.dao;

import com.gestionabsences.config.JPAUtil;
import com.gestionabsences.model.Absence;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;

/**
 * Data Access Object for managing Absence persistence in PostgreSQL database.
 */
public class AbsenceDAO {

    /**
     * Persist a new absence in the database.
     */
    public void save(Absence absence) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (absence.getId() == null) {
                em.persist(absence);
                System.out.println("[AbsenceDAO] Persisted new absence: " + absence);
            } else {
                em.merge(absence);
                System.out.println("[AbsenceDAO] Merged updated absence: " + absence);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("[AbsenceDAO] ERROR saving/updating absence");
            e.printStackTrace();
            throw e;
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Find an absence by its unique identifier.
     */
    public Absence findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Absence.class, id);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Retrieve all logged absences.
     */
    public List<Absence> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Absence a ORDER BY a.dateSaisie DESC", Absence.class)
                    .getResultList();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Update an existing absence.
     */
    public void update(Absence absence) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(absence);
            tx.commit();
            System.out.println("[AbsenceDAO] Updated absence id: " + absence.getId());
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("[AbsenceDAO] ERROR updating absence id " + absence.getId());
            e.printStackTrace();
            throw e;
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Delete an absence by its ID.
     */
    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Absence absence = em.find(Absence.class, id);
            if (absence != null) {
                em.remove(absence);
            }
            tx.commit();
            System.out.println("[AbsenceDAO] Deleted absence id: " + id);
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("[AbsenceDAO] ERROR deleting absence id " + id);
            e.printStackTrace();
            throw e;
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
    /**
     * Count the total number of registered absences.
     */
    public long countTotalAbsences() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(a) FROM Absence a", Long.class).getSingleResult();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Count only justified absences.
     */
    public long countJustifiedAbsences() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(a) FROM Absence a WHERE a.estJustifiee = true", Long.class).getSingleResult();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Find the name and absence count of the student who has the most absences.
     */
    public String getMostAbsentStudentName() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Object[]> results = em.createQuery(
                    "SELECT a.etudiant.nom, a.etudiant.prenom, COUNT(a) " +
                    "FROM Absence a " +
                    "GROUP BY a.etudiant.nom, a.etudiant.prenom " +
                    "ORDER BY COUNT(a) DESC", Object[].class)
                    .setMaxResults(1)
                    .getResultList();
            if (!results.isEmpty()) {
                Object[] row = results.get(0);
                return row[1] + " " + row[0] + " (" + row[2] + " abs)";
            }
            return "Aucun";
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Find all absences for a specific student, ordered by date descending.
     */
    public List<Absence> findByEtudiantId(Long etudiantId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Absence a WHERE a.etudiant.id = :etudiantId ORDER BY a.dateSaisie DESC", Absence.class)
                    .setParameter("etudiantId", etudiantId)
                    .getResultList();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Find all absences with pending justifications or pending reclamations.
     */
    public List<Absence> findPendingRequests() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Absence a WHERE a.statusJustification = 'PENDING' OR a.statusReclamation = 'PENDING' ORDER BY a.dateSaisie DESC", Absence.class)
                    .getResultList();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    /**
     * Find an absence record for a specific student and a specific seance.
     */
    public Absence findByEtudiantAndSeance(Long etudiantId, Long seanceId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Absence> list = em.createQuery("SELECT a FROM Absence a WHERE a.etudiant.id = :etudiantId AND a.seance.id = :seanceId", Absence.class)
                    .setParameter("etudiantId", etudiantId)
                    .setParameter("seanceId", seanceId)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
}
