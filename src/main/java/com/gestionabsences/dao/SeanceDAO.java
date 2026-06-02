package com.gestionabsences.dao;

import com.gestionabsences.config.JPAUtil;
import com.gestionabsences.model.Seance;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import java.util.List;

public class SeanceDAO {

    public void save(Seance seance) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(seance);
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

    public Seance findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Seance.class, id);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }

    public List<Seance> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Seance s JOIN FETCH s.cours ORDER BY s.dateSeance DESC, s.heureDebut DESC", Seance.class)
                    .getResultList();
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
}
