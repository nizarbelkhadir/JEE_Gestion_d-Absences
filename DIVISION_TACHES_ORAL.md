# 📋 Guide de Répartition des Rôles & Soutenance Orale V8
### EMSI — École Marocaine des Sciences de l'Ingénieur
**Module :** JEE & Génie Logiciel  
**Encadrant :** Pr. Houssam BAZZA  

Ce guide récapitule les responsabilités de chaque membre du groupe, son diagramme UML associé, et le code du design pattern ou des tests qu'il doit présenter et maîtriser pour répondre aux questions du professeur Bazza.

---

# 🌐 Partie 1 : Configurations Globales (Socle Commun)
*Ces éléments constituent l'infrastructure globale de l'application et sont considérés comme communs au groupe.*
* **Docker Compose (`docker-compose.yml`) :** PostgreSQL 15 sur le port `5436`.
* **Configuration JPA (`persistence.xml`) :** Dialecte Hibernate, connexion JDBC et auto-update.
* **JPA Lifecycle (`JPAInitializer.java`) :** Initialisation globale de l'EntityManagerFactory au démarrage de Tomcat.

### ⏱️ Organisation Agile globale (Scrum)
* **Ce qu'on a fait :** Planification en 3 Sprints hebdomadaires, tenue de rituels agiles quotidiens (Daily Stand-up) et hebdo (Planning, Review, Retrospective), gestion du Backlog de User Stories.
* **Discours Global face au Professeur Bazza :**
  > *« Pour piloter ce projet JEE dans un délai de 3 semaines, nous avons adopté la méthodologie agile Scrum. Nous avons découpé le développement en 3 sprints d'une semaine. Le Product Owner a défini notre Backlog de User Stories. Nous avons mené nos Daily Stand-ups quotidiens pour synchroniser nos avancées et résoudre les blocages techniques, ainsi que des revues à chaque fin de sprint pour valider les incréments logiciels livrés. »*
* **Questions / Réponses agiles potentielles :**
  * **Q : Quel était le rôle du Scrum Master dans votre équipe ?**
    * *R : « Le Scrum Master (Nizar) s'est assuré du respect des rituels agiles, de la répartition fonctionnelle équitable des tâches et de la fluidité des fusions sur le dépôt Git. »*
  * **Q : Pourquoi avoir planifié des sprints d'une semaine ?**
    * *R : « Compte tenu du délai court de 3 semaines pour rendre le projet, un rythme de sprints hebdomadaires était indispensable pour livrer rapidement des modules testables et s'ajuster rapidement. »*

---

# 👤 Partie 2 : Fiches de Répartition Individuelles (UML, Code & Patterns)

## 🛡️ Membre 1 : Espace Administrateur, Exportations, Diagramme des Cas d'Utilisation & Pattern MVC

### 1. Responsabilités (Fonctionnalités)
* Session Login Admin, gestion manuelle des absences (CRUD), et moteur d'exportation CSV.
* **Diagramme UML associé :** Diagramme de Cas d'Utilisation.

### 2. Design Pattern & Code à présenter : Modèle-Vue-Contrôleur (MVC)
*Le membre montre comment le projet sépare le modèle JPA (Entities), la vue JSP et le contrôleur Servlet.*
```java
// A. Le Modèle (Model) : Entité persistante (Absence.java)
@Entity
@Table(name = "absences")
public class Absence {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    private Etudiant etudiant;
}

// B. Le Contrôleur (Controller) : Reçoit la requête et charge les données (AbsenceServlet.java)
public class AbsenceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        List<Absence> absences = absenceDAO.findAll();
        request.setAttribute("absences", absences);
        request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
    }
}
```
```jsp
<!-- C. La Vue (View) : Affiche les données de manière isolée (admin-dashboard.jsp) -->
<c:forEach var="abs" items="${absences}">
    <tr><td>${abs.etudiant.nomComplet}</td></tr>
</c:forEach>
```

### 3. Questions / Réponses Typiques du Jury
* **Q : Comment est articulée la séparation MVC dans ce projet ?**
  * **R :** *« Les entités JPA représentent le Modèle, les pages JSP sous WEB-INF représentent la Vue (sans logique métier), et AbsenceServlet est le Contrôleur unique qui orchestre l'accès aux données et sélectionne la vue appropriée. »*

### 4. Discours face au Professeur Bazza
> *« Monsieur Bazza, j'ai développé l'espace d'administration et d'export CSV. J'ai modélisé le Diagramme de Cas d'Utilisation UML. Côté architecture logicielle, j'ai implémenté le patron MVC en séparant notre modèle persistant JPA (Entities), de nos pages dynamiques de rendu JSP (Vue) et de notre servlet unique (Contrôleur). »*

---

## 📂 Membre 2 : Espace Étudiant, Justificatifs, Cookies, Diagramme de Classes, DAO & Singleton

### 1. Responsabilités (Fonctionnalités)
* Espace Étudiant, téléversement de justificatifs (Multipart Upload), cookies "Remember Me", et validation admin.
* **Diagramme UML associé :** Diagramme de Classes JPA.

### 2. Design Patterns & Code à présenter : DAO & Singleton
*Le membre montre l'isolation des requêtes JPA (DAO) et l'instance unique de l'EntityManagerFactory (Singleton).*
```java
// A. Le Pattern DAO : Encapsule les requêtes JPQL (AbsenceDAO.java)
public class AbsenceDAO {
    public void save(Absence absence) {
        EntityManager em = JPAUtil.getEntityManager();
        em.getTransaction().begin();
        em.merge(absence);
        em.getTransaction().commit();
    }
    public Absence findById(Long id) {
        return JPAUtil.getEntityManager().find(Absence.class, id);
    }
}

// B. Le Pattern Singleton : Instance unique de l'EntityManagerFactory (JPAUtil.java)
public class JPAUtil {
    private static EntityManagerFactory emf; // Instance unique (Singleton)

    public static synchronized void setEntityManagerFactory(EntityManagerFactory factory) {
        emf = factory;
    }
}
```

### 3. Questions / Réponses Typiques du Jury
* **Q : Quel est l'intérêt du pattern DAO dans notre couche de persistance ?**
  * **R :** *« Le DAO évite de polluer le contrôleur avec des sessions de persistance Hibernate ou des requêtes JPQL. Il isole les accès à la base de données. Si on change de SGBD ou d'ORM, on change uniquement les DAOs, le contrôleur ne bouge pas. »*

### 4. Discours face au Professeur Bazza
> *« Monsieur Bazza, j'ai programmé l'espace étudiant, l'upload de justificatifs médicaux et la gestion des cookies. J'ai conçu le Diagramme de Classes UML. Sur le plan des design patterns, j'ai implémenté le pattern DAO pour encapsuler nos requêtes JPA et le pattern Singleton pour gérer l'instance unique d'EntityManagerFactory via JPAUtil. »*

---

## 📝 Membre 3 : Espace Enseignant, Feuille d'Appel, Tests Unitaires JUnit, Diagramme de Séquence & Front Controller

### 1. Responsabilités (Fonctionnalités)
* Espace Professeur, feuille d'appel dynamique, enregistrement en masse (Bulk Persist).
* **Validation & Robustesse (Tests) :** Écriture et exécution de la suite de tests unitaires automatiques JUnit.
* **Diagramme UML associé :** Diagramme de Séquence.

### 2. Design Pattern & Code à présenter : Front Controller & Tests JUnit
*Le membre montre le routage centralisé de la Servlet et un exemple de classe de test unitaire.*
```java
// A. Front Controller Routing & Security Gate (AbsenceServlet.java)
public class AbsenceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        // Security Gating : Redirection automatique si pas de session active
        HttpSession session = request.getSession(false);
        if (session == null && !"login".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/absences?action=login");
            return;
        }

        // Aiguillage centralisé des requêtes
        switch (action) {
            case "profDashboard":   showProfDashboard(request, response); break;
            case "adminRequests":   showAdminRequests(request, response); break;
            default:                listAbsences(request, response); break;
        }
    }
}

// B. Test Unitaire de Validation (EtudiantTest.java)
public class EtudiantTest {
    @Test
    public void testGetNomComplet() {
        Etudiant etudiant = new Etudiant("CNE999", "belkhadir", "nizar", "nizar@univ.fr");
        // Valide que getNomComplet() met bien le nom en majuscules
        assertEquals("BELKHADIR nizar", etudiant.getNomComplet());
    }
}
```

### 3. Questions / Réponses Typiques du Jury
* **Q : Quel est l'intérêt d'avoir implémenté un Front Controller dans notre servlet ?**
  * **R :** *« Le Front Controller évite d'avoir une servlet par URL de l'application. Une servlet unique intercepte toutes les requêtes sous `/absences`, ce qui nous permet de centraliser la sécurité des sessions en un seul endroit. »*
* **Q : Qu'est-ce que JUnit et à quoi servent les tests unitaires créés ?**
  * **R :** *« JUnit est notre framework de test. Nous avons écrit des tests unitaires automatiques dans le dossier src/test/java pour valider de manière isolée le comportement logique de nos objets (comme le formatage de date de Seance ou la capitalisation de nom de Etudiant) pour prémunir notre code contre toute régression. »*

### 4. Discours face au Professeur Bazza
> *« Monsieur Bazza, j'ai développé le dashboard enseignant et la feuille d'appel interactive en grille. J'ai réalisé le Diagramme de Séquence UML. Côté architecture logicielle, j'ai mis en œuvre le pattern Front Controller en centralisant l'accès à l'application dans AbsenceServlet pour sécuriser et aiguiller nos requêtes. J'ai également configuré et écrit la suite de tests unitaires automatisés sous JUnit pour valider nos modèles et assurer la pérennité du code. »*

---

## 💬 Membre 4 : Réclamations Étudiant, Modération Admin, Filtre Client JS & ThreadLocal

### 1. Responsabilités (Fonctionnalités)
* Gestion des réclamations étudiants, modération avec suppression physique en base, et filtrage dynamique en JavaScript.
* **Fichier associé :** Rapport Technique LaTeX (`RAPPORT_PROJET.tex` / `.pdf`).

### 2. Design Pattern & Code à présenter : ThreadLocal (Isolation des requêtes)
*Le membre explique comment JPAUtil garantit la sécurité des threads (Thread-safety) sur Tomcat en liant un EntityManager à chaque requête.*
```java
// A. ThreadLocal Context (JPAUtil.java)
public class JPAUtil {
    private static EntityManagerFactory emf;
    // Conteneur d'EntityManager isolé par Thread
    private static final ThreadLocal<EntityManager> threadLocalEntityManager = new ThreadLocal<>();

    public static EntityManager getEntityManager() {
        EntityManager em = threadLocalEntityManager.get();
        if (em == null || !em.isOpen()) {
            em = emf.createEntityManager();
            threadLocalEntityManager.set(em); // Associe l'EntityManager au Thread en cours
        }
        return em;
    }

    public static void closeEntityManager() {
        EntityManager em = threadLocalEntityManager.get();
        if (em != null && em.isOpen()) {
            em.close();
        }
        threadLocalEntityManager.remove(); // Nettoie le ThreadLocal
    }
}
```

### 3. Questions / Réponses Typiques du Jury
* **Q : Pourquoi utiliser un ThreadLocal pour l'EntityManager de JPA ?**
  * **R :** *« L'EntityManager de JPA n'est pas thread-safe. Dans un serveur d'application comme Tomcat, chaque client exécute ses requêtes sur un Thread distinct. Pour éviter qu'un utilisateur n'accède ou ne corrompe les données d'un autre dans une transaction concurrente, le ThreadLocal isole l'EntityManager de chaque client dans le Thread en cours de traitement. »*

### 4. Discours face au Professeur Bazza
> *« Monsieur Bazza, j'ai codé la gestion des réclamations étudiants, la suppression transactionnelle physique en base et le filtrage réactif Vanilla JS. J'ai aussi structuré notre rapport technique sous LaTeX. Côté architecture, j'ai programmé le pattern ThreadLocal pour assurer l'isolation de nos transactions et la thread-safety des EntityManagers. »*
