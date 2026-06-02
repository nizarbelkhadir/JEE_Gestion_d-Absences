# Guide de Soutenance & Documentation Technique V2
## Projet : Plateforme Multi-Rôles de Gestion des Absences (Java EE Pur & JPA)

Ce document regroupe toute la structure de votre projet dans sa version V2 (multi-rôles), l'explication détaillée du code, le fonctionnement des cas d'utilisation (Administrateur, Professeur, Étudiant) et un guide complet pour réussir votre soutenance orale.

---

## 📁 1. Structure du Projet V2 (Arborescence Maven)

Voici la structure de fichiers mise à jour pour refléter l'architecture multi-rôles :

```text
projet JEE/
├── pom.xml                                 # Configuration Maven et dépendances (Hibernate, PG, Servlet)
├── docker-compose.yml                      # Configuration Docker pour la base de données PostgreSQL
├── DIVISION_TACHES_ORAL.md                 # Répartition des tâches par membre
├── GUIDE_SOUTENANCE.md                     # Ce document d'aide à la soutenance
├── RAPPORT_PROJET.tex                      # Code source LaTeX du rapport professionnel
├── RAPPORT_PROJET.pdf                      # Version PDF générée du rapport de projet
└── src/
    └── main/
        ├── java/                           # Code source Java
        │   └── com/
        │       └── gestionabsences/
        │           ├── config/
        │           │   ├── JPAInitializer.java  # Listener de démarrage (EntityManagerFactory)
        │           │   └── JPAUtil.java         # Gestionnaire d'EntityManager (ThreadLocal)
        │           ├── dao/
        │           │   ├── AbsenceDAO.java      # Requêtes personnalisées et transactions (merge/JPQL)
        │           │   ├── CoursDAO.java
        │           │   ├── EtudiantDAO.java     # Recherche par email pour authentification
        │           │   ├── ProfesseurDAO.java   # Recherche par email pour authentification
        │           │   └── SeanceDAO.java
        │           ├── model/
        │           │   ├── Absence.java         # Entité avec statuts de Justification et Réclamation
        │           │   ├── Cours.java           # Entité liée à un Enseignant (Professeur)
        │           │   ├── Etudiant.java        # Entité Étudiant
        │           │   ├── Professeur.java      # Entité Enseignant
        │           │   └── Seance.java          # Entité Séance de cours
        │           └── web/
        │               └── AbsenceServlet.java  # Contrôleur Centralisé (Routage et Filtrage)
        ├── resources/
        │   └── META-INF/
        │       └── persistence.xml         # Configuration JPA avec toutes les classes enregistrées
        └── webapp/                         # Ressources Web (JSP, CSS, images)
            ├── index.jsp                   # Redirection vers le contrôleur d'absences
            ├── css/
            │   └── style.css               # Design UI Premium (Glassmorphism & Dark Mode)
            └── WEB-INF/
                ├── web.xml                 # Descripteur de déploiement Servlet et MultipartConfig
                └── views/                  # Vues JSPs (sécurisées sous WEB-INF)
                    ├── login.jsp           # Portail de connexion unifié avec notices démos
                    ├── absence-form.jsp    # Déclaration d'absence (Admin)
                    ├── absence-list.jsp    # Tableau de bord général (Admin)
                    ├── admin-requests.jsp  # Modération des demandes de justificatifs/réclamations (Admin)
                    ├── prof-dashboard.jsp  # Saisie de feuille d'appel interactive (Professeur)
                    └── student-dashboard.jsp # Tableau de bord personnel et dépôt de demandes (Étudiant)
```

---

## 💻 2. Explication de l'Architecture Multi-Rôles

### A. Sécurité et Routage Centralisé (`AbsenceServlet.java`)
L'accès aux fonctionnalités est protégé par une barrière de sécurité basée sur la session utilisateur (`userRole`). Un utilisateur non connecté est automatiquement redirigé vers l'action de connexion (`login`).

```java
// Exemple de filtre de sécurité implémenté dans doGet/doPost
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("userRole") == null) {
    if (!"login".equals(action) && !"loginSubmit".equals(action)) {
        response.sendRedirect(request.getContextPath() + "/absences?action=login");
        return;
    }
}
```

### B. Les Trois Espaces Applicatifs
1. **Espace Admin (`ADMIN`)** :
   - Gère le registre global des absences.
   - Accède au formulaire de création manuelle d'absences.
   - Modère les demandes dans `admin-requests.jsp` (Accepter/Refuser les justifications et réclamations).
2. **Espace Professeur (`PROFESSEUR`)** :
   - Réalise l'appel dans `prof-dashboard.jsp`.
   - Coche les étudiants absents pour une séance d'enseignement spécifique.
   - Met à jour automatiquement la base de données (ajout d'absence si coché, suppression si décoché).
3. **Espace Étudiant (`ETUDIANT`)** :
   - Consulte ses statistiques d'absences (justifiées vs non-justifiées).
   - Dépose une justification avec motif et document justificatif facultatif.
   - Soumet une réclamation pour contester une absence indue.

---

## ⚙️ 3. Lignes de Code Clés & Mécanismes JPA

### A. Statuts des Demandes d'Absences (`Absence.java`)
Pour modérer sans supprimer d'informations, l'entité `Absence` stocke séparément les états de justification et de réclamation :
```java
@Column(name = "status_justification", length = 20)
private String statusJustification = "NONE"; // NONE, PENDING, ACCEPTED, REJECTED

@Column(name = "status_reclamation", length = 20)
private String statusReclamation = "NONE"; // NONE, PENDING, REJECTED
```

### B. Requêtes Custom JPQL (`AbsenceDAO.java`)
Pour alimenter les dashboards, les DAOs utilisent des requêtes JPQL avancées :
```java
// Récupérer les demandes en attente (Justifications ou Réclamations) pour l'Admin
public List<Absence> findPendingRequests() {
    EntityManager em = JPAUtil.getEntityManager();
    try {
        return em.createQuery(
            "SELECT a FROM Absence a WHERE a.statusJustification = 'PENDING' OR a.statusReclamation = 'PENDING'", 
            Absence.class
        ).getResultList();
    } finally {
        JPAUtil.closeEntityManager();
    }
}
```

### C. Seeder de Démo Automatisé
Lors de la première initialisation, l'application crée automatiquement :
- **4 Professeurs** (ex. `prof.bazza@univ.fr`).
- **4 Cours associés** (Architecture Java EE, Base de Données, etc.).
- **35 Étudiants** (de `CNE001` à `CNE035`).
- **4 Séances de cours** réparties sur plusieurs dates.
- Des cas d'absences pré-remplis avec statuts en attente pour tester directement les workflows.

---

## 🗣️ 4. Guide de Présentation pour la Soutenance (Par Diapositives)

### Slide 1 : Titre et Équipe
- **Contenu** : Portail Académique de Gestion des Absences V2.
- **À dire** : *"Bonjour à tous. Nous vous présentons aujourd'hui notre plateforme de gestion des absences. Pour aller plus loin qu'un simple registre administratif, nous avons implémenté une plateforme multi-rôles complète simulant la vie scolaire avec trois espaces dédiés : Administration, Enseignants et Étudiants."*

### Slide 2 : Démonstration du Cycle de Vie
- **Contenu** : Schéma du parcours d'une absence (Professeur fait l'appel -> Étudiant voit son absence et envoie un justificatif -> Admin valide -> Statut mis à jour).
- **À dire** : *"Notre système interconnecte les acteurs de l'école. Un professeur fait l'appel en ligne. Immédiatement, l'étudiant concerné voit son absence sur son espace personnel. Il soumet une pièce justificative, que l'administrateur valide ou rejette depuis son tableau de bord de modération."*

### Slide 3 : Focus Session & Cookies (Session Gate)
- **Contenu** : Explication de `HttpSession` vs `Cookie` (Se souvenir de moi).
- **À dire** : *"L'authentification utilise la puissance des Sessions et des Cookies. La session gère la sécurité et maintient la connexion de l'utilisateur avec son rôle ('userRole'). Le cookie 'Se souvenir de moi' stocke l'identifiant côté client pour pré-remplir le formulaire lors des visites ultérieures."*

---

## ❓ 5. Questions Probables du Jury & Réponses

**Q1 : Comment gérez-vous l'upload des pièces justificatives sous Tomcat ?**
- *Réponse* : *"Nous utilisons l'API standard Servlet 3.1 avec l'annotation `@MultipartConfig` sur la Servlet. Les fichiers justificatifs sont stockés dans un répertoire sécurisé du serveur, et seul le chemin relatif est enregistré en base de données. Cela évite d'alourdir la base de données avec des fichiers binaires."*

**Q2 : Que se passe-t-il si un étudiant conteste une absence (Réclamation) ?**
- *Réponse* : *"L'étudiant soumet une réclamation avec ses explications. L'absence passe au statut de réclamation 'PENDING'. Si l'administrateur accepte la réclamation (l'étudiant était présent en réalité), l'absence est définitivement supprimée du système. S'il la refuse, elle reste marquée et le statut passe à 'REJECTED'."*

**Q3 : Comment le professeur fait-il l'appel si plusieurs séances ont lieu le même jour ?**
- *Réponse* : *"Le professeur sélectionne la séance exacte grâce à une liste déroulante dynamique affichant la date, l'heure et le cours associé. Il effectue son appel sur la grille des étudiants filtrable en temps réel grâce à notre script JavaScript natif."*
