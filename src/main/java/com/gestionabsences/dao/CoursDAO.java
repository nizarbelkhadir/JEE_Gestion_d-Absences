package com.gestionabsences.dao;

import com.gestionabsences.config.JPAUtil;
import com.gestionabsences.model.Cours;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;

public class CoursDAO {

    public void save(Cours cours) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(cours);
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

    public Cours findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Cours.class, id);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    public List<Cours> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Cours c ORDER BY c.nomCours", Cours.class)
                    .getResultList();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
}
