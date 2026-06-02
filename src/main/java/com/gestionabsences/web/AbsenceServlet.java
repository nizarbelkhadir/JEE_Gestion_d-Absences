package com.gestionabsences.web;

import com.gestionabsences.dao.AbsenceDAO;
import com.gestionabsences.dao.CoursDAO;
import com.gestionabsences.dao.EtudiantDAO;
import com.gestionabsences.dao.SeanceDAO;
import com.gestionabsences.dao.ProfesseurDAO;
import com.gestionabsences.model.Absence;
import com.gestionabsences.model.Cours;
import com.gestionabsences.model.Etudiant;
import com.gestionabsences.model.Seance;
import com.gestionabsences.model.Professeur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.File;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

/**
 * Controller Servlet (Front Controller Pattern).
 * Maps URL actions, coordinates with JPA DAOs, and routes to JSP views.
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AbsenceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AbsenceDAO absenceDAO;
    private EtudiantDAO etudiantDAO;
    private SeanceDAO seanceDAO;
    private CoursDAO coursDAO;
    private ProfesseurDAO professeurDAO;

    /**
     * Servlet Lifecycle: Initialization.
     * We initialize DAOs and pre-populate the database with demo records if empty.
     */
    @Override
    public void init() throws ServletException {
        System.out.println("[AbsenceServlet] Initializing Servlet and DAOs...");
        absenceDAO = new AbsenceDAO();
        etudiantDAO = new EtudiantDAO();
        seanceDAO = new SeanceDAO();
        coursDAO = new CoursDAO();
        professeurDAO = new ProfesseurDAO();

        try {
            seedDemoData();
        } catch (Exception e) {
            System.err.println("[AbsenceServlet] Warning: Failed to seed demo data. Database might already be seeded.");
            e.printStackTrace();
        }
    }

    /**
     * Servlet Lifecycle: Request Handling (GET).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            // Actions open to non-authenticated users
            if ("login".equals(action)) {
                showLoginForm(request, response);
                return;
            } else if ("logout".equals(action)) {
                logout(request, response);
                return;
            }

            // Security Gate: Protect all other actions
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userRole") == null) {
                response.sendRedirect(request.getContextPath() + "/absences?action=login");
                return;
            }

            String userRole = (String) session.getAttribute("userRole");

            // Role-Based Routing
            if ("ADMIN".equals(userRole)) {
                switch (action) {
                    case "new":
                        showNewForm(request, response);
                        break;
                    case "delete":
                        deleteAbsence(request, response);
                        break;
                    case "export":
                        exportToCSV(request, response);
                        break;
                    case "adminRequests":
                        showAdminRequests(request, response);
                        break;
                    case "resolveJustification":
                        resolveJustification(request, response);
                        break;
                    case "resolveReclamation":
                        resolveReclamation(request, response);
                        break;
                    case "list":
                    default:
                        listAbsences(request, response);
                        break;
                }
            } else if ("ETUDIANT".equals(userRole)) {
                if ("studentDashboard".equals(action) || "list".equals(action)) {
                    showStudentDashboard(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/absences?action=studentDashboard");
                }
            } else if ("PROFESSEUR".equals(userRole)) {
                if ("profDashboard".equals(action) || "list".equals(action)) {
                    showProfDashboard(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/absences?action=profDashboard");
                }
            }
        } catch (Exception e) {
            System.err.println("[AbsenceServlet] ERROR in doGet processing action: " + action);
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    /**
     * Servlet Lifecycle: Request Handling (POST).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Enforce UTF-8 coding for request parameters
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        // Handle login submit
        if ("loginSubmit".equals(action)) {
            processLogin(request, response);
            return;
        }

        // Security Gate: Protect other actions
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/absences?action=login");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");

        try {
            if ("ADMIN".equals(userRole)) {
                if ("insert".equals(action)) {
                    insertAbsence(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/absences?action=list");
                }
            } else if ("ETUDIANT".equals(userRole)) {
                if ("submitJustification".equals(action)) {
                    processStudentJustification(request, response);
                } else if ("submitReclamation".equals(action)) {
                    processStudentReclamation(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/absences?action=studentDashboard");
                }
            } else if ("PROFESSEUR".equals(userRole)) {
                if ("profSubmitAbsences".equals(action)) {
                    processProfSubmitAbsences(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/absences?action=profDashboard");
                }
            }
        } catch (Exception e) {
            System.err.println("[AbsenceServlet] ERROR in doPost registering/processing action: " + action);
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    /**
     * Action: Display the absence entry form.
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Etudiant> etudiants = etudiantDAO.findAll();
        List<Seance> seances = seanceDAO.findAll();

        request.setAttribute("etudiants", etudiants);
        request.setAttribute("seances", seances);

        // Forward to the JSP view inside WEB-INF (protected from direct browser access)
        request.getRequestDispatcher("/WEB-INF/views/absence-form.jsp").forward(request, response);
    }

    /**
     * Action: Display the list of registered absences.
     */
    private void listAbsences(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Absence> absences = absenceDAO.findAll();
        request.setAttribute("absences", absences);

        // Calculate statistics for dashboard cards
        long totalAbsences = absenceDAO.countTotalAbsences();
        long justifiedAbsences = absenceDAO.countJustifiedAbsences();
        long unjustifiedAbsences = totalAbsences - justifiedAbsences;
        double tauxJustification = totalAbsences > 0 ? ((double) justifiedAbsences / totalAbsences) * 100 : 0.0;
        String mostAbsentStudent = absenceDAO.getMostAbsentStudentName();

        request.setAttribute("totalAbsences", totalAbsences);
        request.setAttribute("justifiedAbsences", justifiedAbsences);
        request.setAttribute("unjustifiedAbsences", unjustifiedAbsences);
        request.setAttribute("tauxJustification", String.format(java.util.Locale.US, "%.1f", tauxJustification));
        request.setAttribute("mostAbsentStudent", mostAbsentStudent);

        request.getRequestDispatcher("/WEB-INF/views/absence-list.jsp").forward(request, response);
    }

    /**
     * Action: Export all registered absences to a CSV file.
     */
    private void exportToCSV(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"absences_export.csv\"");

        // Write UTF-8 BOM to ensure Excel opens it correctly with accents
        response.getOutputStream().write(new byte[] { (byte)0xEF, (byte)0xBB, (byte)0xBF });

        java.io.PrintWriter writer = new java.io.PrintWriter(new java.io.OutputStreamWriter(response.getOutputStream(), "UTF-8"));

        // Write header row
        writer.println("CNE;Etudiant;Email;Cours;Seance;Date de Saisie;Justifiee;Motif");

        List<Absence> absences = absenceDAO.findAll();
        for (Absence abs : absences) {
            writer.println(String.format("%s;%s;%s;%s;%s;%s;%s;%s",
                abs.getEtudiant().getCne(),
                abs.getEtudiant().getNomComplet(),
                abs.getEtudiant().getEmail(),
                abs.getSeance().getCours().getNomCours(),
                abs.getSeance().getLabel(),
                abs.getFormattedDateSaisie(),
                abs.isEstJustifiee() ? "Oui" : "Non",
                abs.getMotifJustification() != null ? abs.getMotifJustification().replace(";", ",").replace("\n", " ").replace("\r", "") : ""
            ));
        }
        writer.flush();
        writer.close();
    }

    /**
     * Action: Persist a new absence record.
     */
    private void insertAbsence(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        String etudiantIdStr = request.getParameter("etudiantId");
        String seanceIdStr = request.getParameter("seanceId");
        String estJustifieeStr = request.getParameter("estJustifiee");
        String motifJustification = request.getParameter("motifJustification");

        // Basic parameter validation
        if (etudiantIdStr == null || etudiantIdStr.trim().isEmpty() ||
            seanceIdStr == null || seanceIdStr.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Veuillez sélectionner un étudiant et une séance.");
            showNewForm(request, response);
            return;
        }

        try {
            Long etudiantId = Long.parseLong(etudiantIdStr);
            Long seanceId = Long.parseLong(seanceIdStr);
            boolean estJustifiee = "true".equalsIgnoreCase(estJustifieeStr) || "on".equalsIgnoreCase(estJustifieeStr);

            Etudiant etudiant = etudiantDAO.findById(etudiantId);
            Seance seance = seanceDAO.findById(seanceId);

            if (etudiant == null || seance == null) {
                request.setAttribute("errorMessage", "Étudiant ou Séance invalide.");
                showNewForm(request, response);
                return;
            }

            // Create and persist the absence record
            Absence absence = new Absence();
            absence.setEtudiant(etudiant);
            absence.setSeance(seance);
            absence.setDateSaisie(LocalDateTime.now());
            absence.setEstJustifiee(estJustifiee);
            
            if (estJustifiee) {
                absence.setMotifJustification(motifJustification);
                // Handle file upload
                Part filePart = request.getPart("pieceJustificative");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    if (fileName != null && !fileName.trim().isEmpty()) {
                        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                        
                        // Determine upload directory in the deployed application directory
                        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }
                        
                        // Write file
                        filePart.write(uploadPath + File.separator + uniqueFileName);
                        absence.setPieceJustificativePath("uploads/" + uniqueFileName);
                    }
                }
            } else {
                absence.setMotifJustification("");
                absence.setPieceJustificativePath(null);
            }

            absenceDAO.save(absence);

            // Redirect to list with success parameter to avoid double form submission
            response.sendRedirect(request.getContextPath() + "/absences?msg=success");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Format d'identifiants incorrect.");
            showNewForm(request, response);
        } catch (Exception e) {
            // Check for duplicate key violation (handled by UniqueConstraint in Database)
            if (e.getMessage() != null && (e.getMessage().contains("constraint") || e.getMessage().contains("ConstraintViolation"))) {
                request.setAttribute("errorMessage", "Cet étudiant est déjà marqué absent pour cette séance.");
            } else {
                request.setAttribute("errorMessage", "Erreur lors de l'enregistrement: " + e.getMessage());
            }
            showNewForm(request, response);
        }
    }

    /**
     * Action: Remove an absence record.
     */
    private void deleteAbsence(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                Long id = Long.parseLong(idStr);
                absenceDAO.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/absences?msg=deleted");
    }

    /**
     * Database seeder method. Inserts default data if tables are empty.
     */
    private void seedDemoData() {
        List<Etudiant> etudiants = etudiantDAO.findAll();
        if (etudiants.isEmpty()) {
            System.out.println("[AbsenceServlet] Database empty. Seeding initial demo data...");

            // 1. Create Professors
            Professeur p1 = new Professeur("Bazza", "Houssam", "prof.bazza@univ.fr", "prof");
            Professeur p2 = new Professeur("Alami", "Ahmed", "prof.alami@univ.fr", "prof");
            Professeur p3 = new Professeur("Idrissi", "Sanae", "prof.idrissi@univ.fr", "prof");
            Professeur p4 = new Professeur("Tazi", "Karim", "prof.tazi@univ.fr", "prof");
            
            professeurDAO.save(p1);
            professeurDAO.save(p2);
            professeurDAO.save(p3);
            professeurDAO.save(p4);

            // 2. Create Courses
            Cours c1 = new Cours("Architecture Java EE", "Design Patterns, Servlets, JSP et JPA (Hibernate)");
            c1.setProfesseur(p1);
            Cours c2 = new Cours("Base de Données PostgreSQL", "Optimisation, requêtes complexes et indexation");
            c2.setProfesseur(p2);
            Cours c3 = new Cours("Développement Mobile", "Initiation à Android et architectures cross-platform");
            c3.setProfesseur(p3);
            Cours c4 = new Cours("Théorie de Compilation", "Analyse lexicale, syntaxique et sémantique");
            c4.setProfesseur(p4);
            
            coursDAO.save(c1);
            coursDAO.save(c2);
            coursDAO.save(c3);
            coursDAO.save(c4);

            // 3. Create 35 Students
            String[][] studentData = {
                {"CNE001", "Belkhadir", "Nizar", "nizar.belkhadir@univ.fr"},
                {"CNE002", "Bibilou", "Adam", "adam.bibilou@univ.fr"},
                {"CNE003", "Asaas", "Adam", "adam.asaas@univ.fr"},
                {"CNE004", "Mwiyeh", "Chafiq", "chafiq.mwiyeh@univ.fr"},
                {"CNE005", "Alaoui", "Sofia", "sofia.alaoui@univ.fr"},
                {"CNE006", "Bennani", "Amine", "amine.bennani@univ.fr"},
                {"CNE007", "El Fassi", "Yassine", "yassine.elfassi@univ.fr"},
                {"CNE008", "Sabri", "Fatima", "fatima.sabri@univ.fr"},
                {"CNE009", "Tahiri", "Kamal", "kamal.tahiri@univ.fr"},
                {"CNE010", "Mansouri", "Hind", "hind.mansouri@univ.fr"},
                {"CNE011", "Jebbar", "Othmane", "othmane.jebbar@univ.fr"},
                {"CNE012", "Raji", "Sanaa", "sanaa.raji@univ.fr"},
                {"CNE013", "Haddad", "Adnane", "adnane.haddad@univ.fr"},
                {"CNE014", "Naji", "Nisrine", "nisrine.naji@univ.fr"},
                {"CNE015", "Kabbaj", "Omar", "omar.kabbaj@univ.fr"},
                {"CNE016", "Zaki", "Meriem", "meriem.zaki@univ.fr"},
                {"CNE017", "Fadli", "Reda", "reda.fadli@univ.fr"},
                {"CNE018", "Boutaleb", "Imane", "imane.boutaleb@univ.fr"},
                {"CNE019", "Filali", "Anass", "anass.filali@univ.fr"},
                {"CNE020", "Morad", "Laila", "laila.morad@univ.fr"},
                {"CNE021", "Kadiri", "Tarik", "tarik.kadiri@univ.fr"},
                {"CNE022", "Chraibi", "Salma", "salma.chraibi@univ.fr"},
                {"CNE023", "Slaoui", "Khalid", "khalid.slaoui@univ.fr"},
                {"CNE024", "Benkirane", "Ghita", "ghita.benkirane@univ.fr"},
                {"CNE025", "Daoudi", "Mehdi", "mehdi.daoudi@univ.fr"},
                {"CNE026", "Tazi", "Zineb", "zineb.tazi@univ.fr"},
                {"CNE027", "El Amri", "Youssef", "youssef.elamri@univ.fr"},
                {"CNE028", "Serraj", "Nadia", "nadia.serraj@univ.fr"},
                {"CNE029", "Cherkaoui", "Hamza", "hamza.cherkaoui@univ.fr"},
                {"CNE030", "Gharbi", "Sara", "sara.gharbi@univ.fr"},
                {"CNE031", "Toumi", "Rania", "rania.toumi@univ.fr"},
                {"CNE032", "Lahlou", "Adil", "adil.lahlou@univ.fr"},
                {"CNE033", "Berrada", "Nassima", "nassima.berrada@univ.fr"},
                {"CNE034", "Benjelloun", "Ali", "ali.benjelloun@univ.fr"},
                {"CNE035", "Mernissi", "Fouad", "fouad.mernissi@univ.fr"}
            };

            Etudiant[] createdStudents = new Etudiant[studentData.length];
            for (int i = 0; i < studentData.length; i++) {
                createdStudents[i] = new Etudiant(studentData[i][0], studentData[i][1], studentData[i][2], studentData[i][3]);
                etudiantDAO.save(createdStudents[i]);
            }

            // 4. Create Sessions (Seances)
            LocalDate today = LocalDate.now();
            Seance s1 = new Seance(today, LocalTime.of(8, 30), LocalTime.of(10, 30), c1);
            Seance s2 = new Seance(today, LocalTime.of(10, 45), LocalTime.of(12, 45), c1);
            Seance s3 = new Seance(today.minusDays(1), LocalTime.of(14, 0), LocalTime.of(16, 0), c2);
            Seance s4 = new Seance(today.minusDays(2), LocalTime.of(9, 0), LocalTime.of(11, 0), c3);
            
            seanceDAO.save(s1);
            seanceDAO.save(s2);
            seanceDAO.save(s3);
            seanceDAO.save(s4);

            // 5. Create Pre-existing Absences
            Absence a1 = new Absence(createdStudents[4], s3, LocalDateTime.now().minusDays(1), true, "Certificat medical fourni");
            Absence a2 = new Absence(createdStudents[5], s1, LocalDateTime.now(), false, "");
            
            // Add some pending justifications and reclamations
            Absence a3 = new Absence(createdStudents[0], s2, LocalDateTime.now().minusHours(2), false, "");
            a3.setStatusJustification("PENDING");
            a3.setMotifDemandeJustif("J'etais malade (certificat medical)");
            
            Absence a4 = new Absence(createdStudents[1], s3, LocalDateTime.now().minusDays(1), false, "");
            a4.setStatusReclamation("PENDING");
            a4.setMotifReclamation("J'etais present, j'ai signe la feuille de presence.");

            absenceDAO.save(a1);
            absenceDAO.save(a2);
            absenceDAO.save(a3);
            absenceDAO.save(a4);

            System.out.println("[AbsenceServlet] Database seeding completed successfully!");
        }
    }

    /**
     * Servlet Lifecycle: Destruction.
     */
    @Override
    public void destroy() {
        System.out.println("[AbsenceServlet] Servlet destroyed. Cleaning up resources...");
        super.destroy();
    }

    /**
     * Action: Show login page and pre-fill email if remembered via Cookie.
     */
    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String rememberedAdmin = "";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedAdmin".equals(cookie.getName())) {
                    rememberedAdmin = cookie.getValue();
                    break;
                }
            }
        }
        request.setAttribute("rememberedAdmin", rememberedAdmin);
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    /**
     * Action: Process login form submission. Verify credentials and manage Sessions/Cookies.
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // 1. Admin login
        if ("admin@univ.fr".equalsIgnoreCase(email) && "admin".equals(password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("userRole", "ADMIN");
            session.setAttribute("adminUser", email);
            handleRememberCookie(request, response, email, remember);
            response.sendRedirect(request.getContextPath() + "/absences?action=list");
            return;
        }

        // 2. Prof login
        Professeur prof = professeurDAO.findByEmail(email);
        if (prof != null && "prof".equals(password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("userRole", "PROFESSEUR");
            session.setAttribute("profUser", prof);
            handleRememberCookie(request, response, email, remember);
            response.sendRedirect(request.getContextPath() + "/absences?action=profDashboard");
            return;
        }

        // 3. Student login
        Etudiant etudiant = etudiantDAO.findByEmail(email);
        if (etudiant != null && "etudiant".equals(password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("userRole", "ETUDIANT");
            session.setAttribute("studentUser", etudiant);
            handleRememberCookie(request, response, email, remember);
            response.sendRedirect(request.getContextPath() + "/absences?action=studentDashboard");
            return;
        }

        // Invalid credentials
        request.setAttribute("errorMessage", "Identifiant ou mot de passe incorrect.");
        request.setAttribute("rememberedAdmin", email);
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    private void handleRememberCookie(HttpServletRequest request, HttpServletResponse response, String email, String remember) {
        if ("true".equalsIgnoreCase(remember) || "on".equalsIgnoreCase(remember)) {
            Cookie adminCookie = new Cookie("rememberedAdmin", email);
            adminCookie.setMaxAge(60 * 60 * 24 * 7); // Valid for 7 days
            adminCookie.setPath(request.getContextPath());
            response.addCookie(adminCookie);
        } else {
            Cookie adminCookie = new Cookie("rememberedAdmin", "");
            adminCookie.setMaxAge(0);
            adminCookie.setPath(request.getContextPath());
            response.addCookie(adminCookie);
        }
    }

    /**
     * Action: Destroy Session and redirect to login page.
     */
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Destroy session
        }
        response.sendRedirect(request.getContextPath() + "/absences?action=login");
    }

    /**
     * Action: Show administrative pending requests page.
     */
    private void showAdminRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Absence> pendingAbsences = absenceDAO.findPendingRequests();
        request.setAttribute("pendingAbsences", pendingAbsences);
        request.getRequestDispatcher("/WEB-INF/views/admin-requests.jsp").forward(request, response);
    }

    /**
     * Action: Accept or refuse student justification.
     */
    private void resolveJustification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String decision = request.getParameter("decision");
        if (idStr != null && decision != null) {
            try {
                Long id = Long.parseLong(idStr);
                Absence abs = absenceDAO.findById(id);
                if (abs != null) {
                    if ("accept".equals(decision)) {
                        abs.setEstJustifiee(true);
                        abs.setStatusJustification("ACCEPTED");
                        abs.setMotifJustification(abs.getMotifDemandeJustif());
                        abs.setPieceJustificativePath(abs.getDemandeJustifFilePath());
                    } else if ("refuse".equals(decision)) {
                        abs.setStatusJustification("REJECTED");
                    }
                    absenceDAO.save(abs);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/absences?action=adminRequests&msg=resolved");
    }

    /**
     * Action: Accept or refuse student reclamation.
     */
    private void resolveReclamation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String decision = request.getParameter("decision");
        if (idStr != null && decision != null) {
            try {
                Long id = Long.parseLong(idStr);
                Absence abs = absenceDAO.findById(id);
                if (abs != null) {
                    if ("accept".equals(decision)) {
                        absenceDAO.delete(abs.getId()); // Absence is deleted since student was present
                    } else if ("refuse".equals(decision)) {
                        abs.setStatusReclamation("REJECTED");
                        absenceDAO.save(abs);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/absences?action=adminRequests&msg=resolved");
    }

    /**
     * Action: Show Student Space Dashboard.
     */
    private void showStudentDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Etudiant student = (Etudiant) session.getAttribute("studentUser");
        
        List<Absence> absences = absenceDAO.findByEtudiantId(student.getId());
        
        long totalAbsences = absences.size();
        long justifiedAbsences = 0;
        long pendingRequests = 0;
        
        for (Absence a : absences) {
            if (a.isEstJustifiee()) {
                justifiedAbsences++;
            }
            if ("PENDING".equals(a.getStatusJustification()) || "PENDING".equals(a.getStatusReclamation())) {
                pendingRequests++;
            }
        }
        
        long unjustifiedAbsences = totalAbsences - justifiedAbsences;

        request.setAttribute("absences", absences);
        request.setAttribute("totalAbsences", totalAbsences);
        request.setAttribute("justifiedAbsences", justifiedAbsences);
        request.setAttribute("unjustifiedAbsences", unjustifiedAbsences);
        request.setAttribute("pendingRequests", pendingRequests);
        
        request.getRequestDispatcher("/WEB-INF/views/student-dashboard.jsp").forward(request, response);
    }

    /**
     * Action: Submit student justification form.
     */
    private void processStudentJustification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("absenceId");
        String motif = request.getParameter("motif");
        
        if (idStr != null) {
            try {
                Long id = Long.parseLong(idStr);
                Absence abs = absenceDAO.findById(id);
                
                // Security Check: verify this absence belongs to the logged student
                HttpSession session = request.getSession(false);
                Etudiant student = (Etudiant) session.getAttribute("studentUser");
                
                if (abs != null && abs.getEtudiant().getId().equals(student.getId())) {
                    abs.setStatusJustification("PENDING");
                    abs.setMotifDemandeJustif(motif);
                    
                    // Handle file upload
                    Part filePart = request.getPart("pieceJustificative");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = filePart.getSubmittedFileName();
                        if (fileName != null && !fileName.trim().isEmpty()) {
                            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdir();
                            }
                            filePart.write(uploadPath + File.separator + uniqueFileName);
                            abs.setDemandeJustifFilePath("uploads/" + uniqueFileName);
                        }
                    }
                    absenceDAO.save(abs);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/absences?action=studentDashboard&msg=justifSubmitted");
    }

    /**
     * Action: Submit student reclamation form.
     */
    private void processStudentReclamation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("absenceId");
        String motif = request.getParameter("motif");
        
        if (idStr != null) {
            try {
                Long id = Long.parseLong(idStr);
                Absence abs = absenceDAO.findById(id);
                
                // Security Check: verify this absence belongs to the logged student
                HttpSession session = request.getSession(false);
                Etudiant student = (Etudiant) session.getAttribute("studentUser");
                
                if (abs != null && abs.getEtudiant().getId().equals(student.getId())) {
                    abs.setStatusReclamation("PENDING");
                    abs.setMotifReclamation(motif);
                    absenceDAO.save(abs);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/absences?action=studentDashboard&msg=reclamSubmitted");
    }

    /**
     * Action: Show Professor Space Dashboard (make attendance).
     */
    private void showProfDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Seance> seances = seanceDAO.findAll();
        List<Etudiant> etudiants = etudiantDAO.findAll();
        
        request.setAttribute("seances", seances);
        request.setAttribute("etudiants", etudiants);
        
        request.getRequestDispatcher("/WEB-INF/views/prof-dashboard.jsp").forward(request, response);
    }

    /**
     * Action: Record student absences submitted by professor.
     */
    private void processProfSubmitAbsences(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String seanceIdStr = request.getParameter("seanceId");
        String[] absentStudentIds = request.getParameterValues("absentStudents");
        
        if (seanceIdStr != null) {
            try {
                Long seanceId = Long.parseLong(seanceIdStr);
                Seance seance = seanceDAO.findById(seanceId);
                
                if (seance != null) {
                    List<Etudiant> allStudents = etudiantDAO.findAll();
                    for (Etudiant student : allStudents) {
                        boolean isAbsent = false;
                        if (absentStudentIds != null) {
                            for (String idStr : absentStudentIds) {
                                if (idStr.equals(student.getId().toString())) {
                                    isAbsent = true;
                                    break;
                                }
                            }
                        }
                        
                        Absence existing = absenceDAO.findByEtudiantAndSeance(student.getId(), seance.getId());
                        
                        if (isAbsent) {
                            if (existing == null) {
                                Absence abs = new Absence();
                                abs.setEtudiant(student);
                                abs.setSeance(seance);
                                abs.setDateSaisie(LocalDateTime.now());
                                abs.setEstJustifiee(false);
                                absenceDAO.save(abs);
                            }
                        } else {
                            if (existing != null) {
                                absenceDAO.delete(existing.getId());
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/absences?action=profDashboard&msg=callCompleted");
    }
}
