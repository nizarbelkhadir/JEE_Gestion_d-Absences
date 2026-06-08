package com.gestionabsences;

import com.gestionabsences.config.JPAUtil;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Unit tests for JPAUtil class configuration and safety gates.
 */
public class JPAUtilTest {

    @Test
    public void testUninitializedFactoryThrowsException() {
        // Since we run unit tests in isolation without Tomcat booting,
        // JPAUtil.getEntityManagerFactory() might be null.
        // Let's assert that calling getEntityManager throws the expected IllegalStateException.
        if (JPAUtil.getEntityManagerFactory() == null) {
            try {
                JPAUtil.getEntityManager();
                fail("Expected IllegalStateException to be thrown since EntityManagerFactory is null");
            } catch (IllegalStateException e) {
                assertEquals("EntityManagerFactory has not been initialized by the listener yet!", e.getMessage());
            }
        }
    }
}
