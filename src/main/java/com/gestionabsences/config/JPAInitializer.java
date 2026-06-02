package com.gestionabsences.config;

import javax.persistence.Persistence;
import javax.persistence.EntityManagerFactory;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * Listener that controls the JPA lifecycle synchronized with Tomcat's startup and shutdown.
 * Prevents memory leaks and ensures database connections are established on start.
 */
@WebListener
public class JPAInitializer implements ServletContextListener {

    private EntityManagerFactory emf;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[JPAInitializer] Initializing JPA EntityManagerFactory (AbsencePU)...");
        try {
            // Create the factory using the configuration defined in persistence.xml
            emf = Persistence.createEntityManagerFactory("AbsencePU");
            JPAUtil.setEntityManagerFactory(emf);
            System.out.println("[JPAInitializer] JPA EntityManagerFactory successfully initialized.");
        } catch (Exception e) {
            System.err.println("[JPAInitializer] ERROR: Failed to initialize JPA EntityManagerFactory!");
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[JPAInitializer] Closing JPA EntityManagerFactory...");
        try {
            if (emf != null && emf.isOpen()) {
                emf.close();
                System.out.println("[JPAInitializer] JPA EntityManagerFactory successfully closed.");
            }
        } catch (Exception e) {
            System.err.println("[JPAInitializer] ERROR while closing EntityManagerFactory.");
            e.printStackTrace();
        }
    }
}
