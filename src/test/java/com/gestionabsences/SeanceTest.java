package com.gestionabsences;

import com.gestionabsences.model.Cours;
import com.gestionabsences.model.Seance;
import org.junit.Test;
import java.time.LocalDate;
import java.time.LocalTime;
import static org.junit.Assert.*;

/**
 * Unit tests for the Seance model class.
 */
public class SeanceTest {

    @Test
    public void testGetFormattedDate() {
        Cours cours = new Cours("JEE", "Java Enterprise Edition");
        Seance seance = new Seance(LocalDate.of(2026, 6, 8), LocalTime.of(9, 0), LocalTime.of(12, 0), cours);

        assertEquals("08/06/2026", seance.getFormattedDate());
    }

    @Test
    public void testGetLabel() {
        Cours cours = new Cours("Genie Logiciel", "Conception et UML");
        Seance seance = new Seance(LocalDate.of(2026, 6, 8), LocalTime.of(14, 30), LocalTime.of(17, 30), cours);

        // Expected output format: "Genie Logiciel (08/06/2026 14:30 - 17:30)"
        assertEquals("Genie Logiciel (08/06/2026 14:30 - 17:30)", seance.getLabel());
    }

    @Test
    public void testGetFormattedDateWithNull() {
        Seance seance = new Seance();
        assertEquals("", seance.getFormattedDate());
    }
}
