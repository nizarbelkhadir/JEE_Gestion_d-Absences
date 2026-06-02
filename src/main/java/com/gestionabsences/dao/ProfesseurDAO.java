package com.gestionabsences.dao;

import com.gestionabsences.config.JPAUtil;
import com.gestionabsences.model.Professeur;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;

public class ProfesseurDAO {

    public void save(Professeur professeur) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(professeur);
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

    public Professeur findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Professeur.class, id);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    public List<Professeur> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Professeur p ORDER BY p.nom, p.prenom", Professeur.class)
                    .getResultList();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    public Professeur findByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Professeur> list = em.createQuery("SELECT p FROM Professeur p WHERE LOWER(p.email) = LOWER(:email)", Professeur.class)
                    .setParameter("email", email)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
}
