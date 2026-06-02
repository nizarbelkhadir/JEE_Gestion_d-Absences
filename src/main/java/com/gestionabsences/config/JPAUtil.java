package com.gestionabsences.config;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

/**
 * Utility class to manage JPA EntityManager and EntityManagerFactory.
 * The factory is initialized at application startup by {@link JPAInitializer}.
 */
public class JPAUtil {

    private static EntityManagerFactory emf;
    private static final ThreadLocal<EntityManager> threadLocalEntityManager = new ThreadLocal<>();

    /**
     * Set the global EntityManagerFactory. Called by ServletContextListener at startup.
     */
    public static synchronized void setEntityManagerFactory(EntityManagerFactory factory) {
        emf = factory;
    }

    /**
     * Get the global EntityManagerFactory.
     */
    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        return emf;
    }

    /**
     * Returns a thread-safe EntityManager instance.
     */
    public static EntityManager getEntityManager() {
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory has not been initialized by the listener yet!");
        }
        EntityManager em = threadLocalEntityManager.get();
        if (em == null || !em.isOpen()) {
            em = emf.createEntityManager();
            threadLocalEntityManager.set(em);
        }
        return em;
    }

    /**
     * Closes the current thread's EntityManager.
     */
    public static void closeEntityManager() {
        EntityManager em = threadLocalEntityManager.get();
        if (em != null && em.isOpen()) {
            em.close();
        }
        threadLocalEntityManager.remove();
    }
}
