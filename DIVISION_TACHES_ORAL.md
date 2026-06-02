# 📋 Guide de Répartition des Rôles & Soutenance Orale V4
### EMSI — École Marocaine des Sciences de l'Ingénieur
**Module :** JEE & Génie Logiciel  
**Encadrant :** Pr. Houssam BAZZA  

Ce document fournit la structure finale pour votre présentation de projet. La première partie détaille les configurations globales de la plateforme (infrastructure commune). La seconde partie découpe les fonctionnalités du système en 4 verticalités métiers équilibrées, affectées individuellement à chaque membre du groupe avec son script de soutenance.

---

# 🌐 Partie 1 : Configurations Globales & Infrastructure Commune
*Ces composants transversaux représentent le socle technique du projet et ne sont affectés à aucun membre en particulier.*

### A. Conteneurisation & Base de Données (PostgreSQL & Docker Compose)
* **Fichier :** `docker-compose.yml`
* **Rôle :** Isolation et portabilité du SGBD PostgreSQL 15 sur le port physique `5436`.
* **Concept clé :** Respect des principes du génie logiciel en éliminant les contraintes d'installation locale sur la machine du jury.

### B. Configuration JPA (`persistence.xml`)
* **Fichier :** `src/main/resources/META-INF/persistence.xml`
* **Rôle :** Déclaration de l'unité de persistance (`AbsencePU`), chargement du driver PostgreSQL JDBC, et configuration de la génération de schéma automatique (`hibernate.hbm2ddl.auto = update`).

### C. Gestion du Cycle de Vie JPA (`ServletContextListener`)
* **Fichier :** `JPAInitializer.java`
* **Rôle :** Instanciation unique de l'interface lourde `EntityManagerFactory` au démarrage du serveur Tomcat et fermeture propre lors de l'arrêt de l'application.

### D. Isolation des Threads & ThreadLocal (`JPAUtil.java`)
* **Fichier :** `JPAUtil.java`
* **Rôle :** L'objet `EntityManager` n'étant pas thread-safe, la classe utilitaire l'associe à chaque thread de requête HTTP via une structure `ThreadLocal` pour interdire tout accès concurrent.

---

# 👤 Partie 2 : Répartition des Rôles Fonctionnels par Membre

## 🛡️ Membre 1 : Espace Administrateur, Gestion Manuelle des Absences & Moteur d'Exportation CSV

### 1. Fonctionnalités prises en charge
* **Session Login Admin :** Gestion de la session d'authentification pour le profil administrateur unique.
* **Registre Global des Absences :** Visualisation globale et centralisée de toutes les absences des étudiants.
* **Création et Suppression Manuelle :** Ajout direct d'une absence pour un étudiant/séance ou suppression d'un enregistrement d'absence erroné.
* **Exportation des Absences en CSV :** Écriture du flux de données CSV directement dans le canal HTTP, avec injection du code BOM UTF-8.

### 2. Code clé à maîtriser
```java
// processLogin - Extrait de AbsenceServlet.java
if ("admin@univ.fr".equals(email) && "admin".equals(password)) {
    HttpSession session = request.getSession(true);
    session.setAttribute("userRole", "ADMIN");
    response.sendRedirect(request.getContextPath() + "/absences?action=list");
    return;
}

// Exportation CSV avec Injection BOM UTF-8
response.setContentType("text/csv; charset=UTF-8");
response.setHeader("Content-Disposition", "attachment; filename=\"absences.csv\"");
PrintWriter writer = response.getWriter();
writer.write('\ufeff'); // BOM UTF-8 pour forcer Excel a lire correctement les accents
writer.println("CNE,Nom Complet,Cours,Date,Statut");
for (Absence a : absences) {
    writer.println(a.getEtudiant().getCne() + "," + a.getEtudiant().getNomComplet() + "," +
                   a.getSeance().getCours().getNomCours() + "," + a.getFormattedDateSaisie() + "," +
                   a.getStatusJustification());
}
```

### 3. Fiche Soutenance (Questions/Réponses & Discours)
* **Q : Pourquoi le format CSV brut s'ouvre-t-il mal dans Excel sans le caractère BOM `\ufeff` ?**
  * **R :** *« Par défaut, Excel tente de lire les fichiers textuels CSV locaux en codage ANSI/Windows-1252. Cela déforme les accents français comme les 'é' ou 'à'. En transmettant le caractère d'ordre des octets (BOM UTF-8) en préambule du fichier, nous forçons Excel à interpréter la suite en UTF-8, garantissant la lisibilité immédiate des noms. »*
* **Discours à tenir :**
  > *« Monsieur Bazza, je me suis occupé de l'espace Administrateur. J'ai configuré la session de connexion réservée à l'administration et développé les fonctionnalités de création et de suppression manuelle des fiches d'absences. Enfin, j'ai mis au point le moteur d'exportation de données au format CSV en écrivant directement dans le flux d'octets de sortie HTTP de la servlet, en résolvant le problème de déformation des caractères accentués sous Microsoft Excel par injection de la signature d'octets BOM UTF-8. »*

---

## 📂 Membre 2 : Espace Étudiant, Téléversement de Justificatifs & Approbation Admin

### 1. Fonctionnalités prises en charge
* **Espace Tableau de bord Étudiant :** Affichage des compteurs statistiques d'absences (justifiées vs non justifiées) et tableau récapitulatif.
* **Soumission de Justificatif :** Téléversement binaire via requête HTTP `MultipartConfig` de certificats médicaux, avec algorithme d'unicité temporelle.
* **Persistance "Se Souvenir de Moi" (Cookies) :** Sauvegarde persistante des identifiants côté client grâce aux cookies HTTP.
* **Validation de Justification :** Portail d'approbation ou de rejet des pièces justificatives côté Administrateur.

### 2. Code clé à maîtriser
```java
// Téléversement sécurisé binaire - AbsenceServlet.java
Part filePart = request.getPart("pieceJustificative");
if (filePart != null && filePart.getSize() > 0) {
    String fileName = filePart.getSubmittedFileName();
    String uniqueName = System.currentTimeMillis() + "_" + fileName; // Eviter les collisions
    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
    
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) uploadDir.mkdir();
    
    filePart.write(uploadPath + File.separator + uniqueName);
    abs.setDemandeJustifFilePath("uploads/" + uniqueName);
    abs.setStatusJustification("PENDING");
}

// rememberMe - Ecriture du cookie persistant
Cookie c = new Cookie("rememberedAdmin", email);
c.setMaxAge(60 * 60 * 24 * 7); // Expire dans 7 jours
c.setPath(request.getContextPath());
response.addCookie(c);
```

### 3. Fiche Soutenance (Questions/Réponses & Discours)
* **Q : Comment garantissez-vous que le fichier importé par l'étudiant n'écrase pas une autre pièce jointe ?**
  * **R :** *« Nous utilisons un algorithme de renommage dynamique basé sur l'horodatage système `System.currentTimeMillis()`. Même si deux étudiants téléversent un fichier nommé de la même façon (par exemple 'justif.pdf'), le timestamp système en millisecondes préfixé au nom garantit l'unicité du nom de fichier sur le disque dur du serveur. »*
* **Discours à tenir :**
  > *« Monsieur Bazza, j'ai implémenté le module de téléversement de justificatifs médicaux pour l'espace Étudiant. En m'appuyant sur l'annotation standard `@MultipartConfig` de la Servlet, j'ai codé la réception binaire des pièces justificatives, leur sauvegarde sécurisée sur le disque dur du serveur Tomcat sous des noms uniques temporels, et l'intégration du workflow d'approbation/rejet côté Administrateur. J'ai aussi implémenté le confort de connexion via la création et le rappel automatique de Cookies persistants stockés sur le navigateur client. »*

---

## 📝 Membre 3 : Espace Enseignant & Feuille d'Appel Dynamique Interactive

### 1. Fonctionnalités prises en charge
* **Session Login Professeur :** Identification et contrôle d'accès pour les enseignants.
* **Sélection Dynamique de Séance :** Récupération dynamique en base de données de la liste des cours et des séances associés au professeur connecté.
* **Feuille d'Appel en Grille :** Génération interactive de la liste des étudiants sous forme de grille contenant des cases à cocher.
* **Enregistrement en Masse (Bulk Persist) :** Traitement unifié en base de données des étudiants marqués absents pour la séance sélectionnée.

### 2. Code clé à maîtriser
```jsp
<!-- prof-dashboard.jsp - Generation dynamique de l'appel -->
<form action="${pageContext.request.contextPath}/absences?action=profSubmitAbsences" method="POST">
    <select name="seanceId" required>
        <c:forEach var="s" items="${seances}">
            <option value="${s.id}">${s.label} (${s.cours.nomCours})</option>
        </c:forEach>
    </select>
    <c:forEach var="st" items="${etudiants}">
        <div class="student-item">
            <span>${st.nomComplet}</span>
            <input type="checkbox" name="absentStudents" value="${st.id}">
        </div>
    </c:forEach>
</form>
```
```java
// AbsenceServlet.java - Traitement Bulk Persist
String[] absentIds = request.getParameterValues("absentStudents");
Long seanceId = Long.parseLong(request.getParameter("seanceId"));
Seance seance = seanceDAO.findById(seanceId);

if (absentIds != null) {
    for (String idStr : absentIds) {
        Long etudiantId = Long.parseLong(idStr);
        Etudiant etudiant = etudiantDAO.findById(etudiantId);
        Absence abs = new Absence(etudiant, seance, LocalDateTime.now());
        absenceDAO.save(abs); // Insertion en base
    }
}
```

### 3. Fiche Soutenance (Questions/Réponses & Discours)
* **Q : Comment récupérez-vous l'ensemble des checkbox cochées par le professeur dans votre servlet ?**
  * **R :** *« En HTML, lorsque plusieurs checkbox partagent le même attribut `name` (ici 'absentStudents'), le serveur reçoit un tableau d'identifiants. Nous le récupérons dans la servlet via la méthode `request.getParameterValues("absentStudents")`. Nous bouclons ensuite sur ces identifiants pour enregistrer les absences en base de données de manière groupée. »*
* **Discours à tenir :**
  > *« Monsieur Bazza, j'ai développé l'espace Enseignant de l'application. Je me suis concentré sur la feuille d'appel interactive qui permet au professeur de sélectionner une séance puis de marquer les absents. Grâce aux balises JSTL, la liste des étudiants inscrits est générée de façon dynamique. J'ai codé la réception du tableau d'identifiants côté contrôleur pour exécuter une persistance groupée (Bulk Persist) au moyen de transactions JPA sécurisées. »*

---

## 💬 Membre 4 : Réclamations Étudiants, Arbitrage Admin & Recherche Temps Réel (Client JS)

### 1. Fonctionnalités prises en charge
* **Dépôt de Réclamation :** Formulaire permettant à l'étudiant de contester une absence marquée par erreur en motivant sa requête.
* **Portail d'Arbitrage Administrateur :** Espace permettant à l'administrateur de traiter les réclamations des étudiants.
* **Suppression Transactionnelle :** En cas d'arbitrage positif, suppression automatique de l'absence contestée via l'EntityTransaction JPA.
* **Moteur de Recherche Client (Vanilla JS) :** Algorithme de filtrage dynamique instantané sans rechargement de page.

### 2. Code clé à maîtriser
```javascript
// Filtrage dynamique instantane côté client (Vanilla JS)
function filterAbsences() {
    var query = document.getElementById("searchInput").value.toLowerCase();
    var filter = document.getElementById("statusFilter").value;
    var rows = document.querySelectorAll("table tbody tr");

    rows.forEach(function(row) {
        var nom = row.cells[1].textContent.toLowerCase();
        var cours = row.cells[2].textContent.toLowerCase();
        var status = row.cells[4].textContent.toLowerCase();

        var matchesQuery = nom.indexOf(query) > -1 || cours.indexOf(query) > -1;
        var matchesStatus = filter === "ALL" || 
            (filter === "JUSTIF" && status.indexOf("justifi") > -1) ||
            (filter === "NONJUSTIF" && status.indexOf("non justifi") > -1);

        row.style.display = (matchesQuery && matchesStatus) ? "" : "none";
    });
}
```
```java
// resolveReclamation - AbsenceServlet.java
String decision = request.getParameter("decision");
Absence abs = absenceDAO.findById(id);
if (abs != null) {
    if ("accept".equals(decision)) {
        absenceDAO.delete(abs.getId()); // C'est une suppression physique
    } else {
        abs.setStatusReclamation("REJECTED");
        absenceDAO.save(abs);
    }
}
```

### 3. Fiche Soutenance (Questions/Réponses & Discours)
* **Q : Pourquoi supprimer physiquement l'absence en base de données lorsque la réclamation est acceptée ?**
  * **R :** *« Le marquage d'une absence par l'enseignant est parfois une erreur. Si l'étudiant prouve sa présence et que l'administrateur valide la réclamation, l'absence est considérée comme nulle. Supprimer physiquement la ligne de la table `absences` via `em.remove()` permet de corriger le registre et de remettre instantanément à zéro le compteur de l'étudiant. »*
* **Discours à tenir :**
  > *« Monsieur Bazza, j'ai développé le module de réclamation des étudiants et d'arbitrage de l'administration. J'ai implémenté le formulaire de contestation et la logique transactionnelle JPA qui supprime physiquement l'absence de la base de données PostgreSQL lorsque la réclamation de l'étudiant est approuvée par l'administrateur. Enfin, pour fluidifier l'expérience utilisateur, j'ai écrit un moteur de recherche et de filtrage instantané en pur JavaScript côté client, ce qui évite de recharger la page et d'épuiser inutilement les connexions au serveur. »*
