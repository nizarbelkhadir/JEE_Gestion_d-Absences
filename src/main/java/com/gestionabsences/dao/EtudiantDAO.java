package com.gestionabsences.dao;

import com.gestionabsences.config.JPAUtil;
import com.gestionabsences.model.Etudiant;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;

public class EtudiantDAO {

    public void save(Etudiant etudiant) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(etudiant);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    public Etudiant findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Etudiant.class, id);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    public List<Etudiant> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT e FROM Etudiant e ORDER BY e.nom, e.prenom", Etudiant.class)
                    .getResultList();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    public Etudiant findByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Etudiant> list = em.createQuery("SELECT e FROM Etudiant e WHERE LOWER(e.email) = LOWER(:email)", Etudiant.class)
                    .setParameter("email", email)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
}
