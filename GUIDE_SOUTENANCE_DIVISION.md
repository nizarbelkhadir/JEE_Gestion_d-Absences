# 🎤 Guide de Soutenance & Répartition de Parole (Mis à Jour)
**Projet :** Plateforme de Gestion des Absences Multi-Rôles (JEE 8 / JPA)  
**Encadrant :** Pr. Houssam BAZZA — EMSI 4IIR  

Ce guide organise la parole diapositive par diapositive en associant chaque membre à ses responsabilités réelles pour une présentation fluide devant le jury.

---

## ⏱️ Synthèse de la Répartition des Membres

* **Membre 1 : Chafiq** — Espace Administrateur, Exportations CSV, Diagramme de Cas d'Utilisation, Pattern MVC.
* **Membre 2 : Adam Asaas** — Espace Étudiant, Justificatifs, Cookies, Diagramme de Classes, DAO & Singleton.
* **Membre 3 : Nizar** — Espace Enseignant (Appel), Tests JUnit, Diagramme de Séquence, Front Controller.
* **Membre 4 : Adam Bibilou** — Réclamations, Modération Admin, Filtre JS, ThreadLocal & Rapport LaTeX.

| Diapositive | Titre | Intervenant(s) | Focus Oral |
| :--- | :--- | :--- | :--- |
| **Slide 1** | Page de Garde | **Chafiq** (Membre 1) | Introduction & Présentation de l'équipe |
| **Slide 2** | Introduction & Contexte | **Adam Bibilou** (Membre 4) | Problématique & Choix techniques (Java EE/Docker) |
| **Slide 3** | Gestion de Projet (Scrum) | **Nizar** (Membre 3) | Scrum Master : Sprints & Rituels agiles |
| **Slide 4** | Conception & Modélisation UML | **Chafiq, Adam Asaas, Nizar** | Présentation croisée des diagrammes individuels |
| **Slide 5** | Architecture & Patterns (1/2) | **Chafiq & Nizar** | MVC, Front Controller & DAO |
| **Slide 6** | Architecture & Patterns (2/2) | **Adam Asaas & Adam Bibilou** | Singleton, ThreadLocal & Sessions/Cookies |
| **Slide 7** | Robustesse & Tests (JUnit) | **Nizar** (Membre 3) | Suite de tests unitaires automatisés |
| **Slide 8** | Démonstration (Vidéo) | **Tous (Chafiq, Nizar, Adam Asaas, Adam Bibilou)** | Commentaire en direct de sa partie sur la vidéo |
| **Slide 9** | Conclusion & Perspectives | **Adam Bibilou** (Membre 4) | Bilan, évolutions futures & remerciements |

---

## 💬 Discours Diapositive par Diapositive

### 🚪 Slide 1 : Page de Garde
* **Intervenant :** **Chafiq** (Membre 1)
* **Ce qu'il faut dire à l'oral :**
  > *« Bonjour Monsieur Bazza, bonjour à tous. Nous sommes ravis de vous présenter notre projet de fin d'année portant sur le développement d'une Plateforme de Gestion des Absences Multi-Rôles. Ce projet a été réalisé par notre équipe : Chafiq Mwiyeh, Adam Asaas, Nizar Belkhadir et Adam Bibilou, sous votre encadrement. »*
  > *(Transition)* : *« Je laisse la parole à Adam Bibilou pour introduire la problématique et nos choix technologiques. »*

---

### 💡 Slide 2 : Introduction & Problématique
* **Intervenant :** **Adam Bibilou** (Membre 4)
* **Ce qu'il faut dire à l'oral :**
  > *« Le suivi de l'assiduité universitaire manuel est complexe et source d'erreurs. Il y a un risque de perte de justificatifs papier et un manque de réactivité. Notre plateforme résout cela en connectant l'administration, les enseignants et les étudiants. Pour ce faire, nous avons choisi d'utiliser du Java EE 8 pur, JPA/Hibernate et PostgreSQL sous Docker pour maîtriser les bases du génie logiciel. »*
  > *(Transition)* : *« Notre Scrum Master, Nizar, va vous présenter comment nous avons organisé notre travail. »*

---

### ⏱️ Slide 3 : Organisation Agile (Scrum)
* **Intervenant :** **Nizar** (Membre 3 — Scrum Master)
* **Ce qu'il faut dire à l'oral :**
  > *« En tant que Scrum Master, j'ai veillé au respect des rituels et à la répartition. Le projet s'est déroulé sur 3 sprints d'une semaine. Le Sprint 1 a posé les bases (UML, Docker, JPA). Le Sprint 2 a implémenté le Front Controller et la feuille d'appel prof. Le Sprint 3 a finalisé les dashboards, les justificatifs et les tests unitaires JUnit. Nos Daily Stand-ups ont garanti une intégration Git sans blocage. »*
  > *(Transition)* : *« Nous allons maintenant passer à la conception UML de nos modules. »*

---

### 📐 Slide 4 : Conception & Modélisation UML
* **Intervenants :** **Chafiq, Adam Asaas & Nizar** (Chacun présente son diagramme)
* **Ce qu'il faut dire à l'oral :**
  * **Chafiq (Membre 1) :**
    > *« J'ai conçu le Diagramme de Cas d'Utilisation. Il organise l'application en 3 espaces distincts : l'administrateur gère le registre et arbitre, l'enseignant remplit sa feuille d'appel, et l'étudiant suit son assiduité et justifie ses absences. »*
  * **Adam Asaas (Membre 2) :**
    > *« J'ai réalisé le Diagramme de Classes JPA. Il structure le modèle relationnel de persistance : l'Etudiant a des Absences, rattachées à des Seances de Cours gérées par un Professeur. C'est la base de notre mapping Hibernate. »*
  * **Nizar (Membre 3) :**
    > *« J'ai modélisé le Diagramme de Séquence. Il trace le flux d'une requête HTTP lors de la soumission d'un justificatif, de l'envoi multipart depuis la page JSP vers le contrôleur, puis l'écriture en base via le DAO. »*
  * *(Transition)* : *« Voyons maintenant la mise en œuvre de notre architecture logicielle. »*

---

### 🏛️ Slide 5 : Architecture & Design Patterns (1/2)
* **Intervenants :** **Chafiq & Nizar**
* **Ce qu'il faut dire à l'oral :**
  * **Chafiq (Membre 1) :**
    > *« Notre projet applique le pattern MVC. Le Modèle est constitué des entités JPA persistantes, la Vue par nos pages JSP isolées sous WEB-INF, et le Contrôleur par la servlet unique. »*
  * **Nizar (Membre 3) :**
    > *« Pour le routage, j'ai implémenté le Front Controller dans AbsenceServlet pour centraliser la sécurité des sessions en un seul point. Nous utilisons aussi le pattern DAO pour encapsuler nos requêtes JPA complexes et isoler l'accès aux données. »*
  * *(Transition)* : *« Adam Asaas et Adam Bibilou vont détailler la persistance et l'isolation des requêtes. »*

---

### 🔒 Slide 6 : Persistance & Gestion des Threads (2/2)
* **Intervenants :** **Adam Asaas & Adam Bibilou**
* **Ce qu'il faut dire à l'oral :**
  * **Adam Asaas (Membre 2) :**
    > *« Nous utilisons le pattern Singleton dans JPAUtil pour garantir une instance unique de l'EntityManagerFactory. La HttpSession gère l'état de connexion de l'utilisateur, complétée par des Cookies 'Remember Me' sécurisés pour le login. »*
  * **Adam Bibilou (Membre 4) :**
    > *« Comme l'EntityManager de JPA n'est pas thread-safe, j'ai mis en place le pattern ThreadLocal dans JPAUtil. Chaque thread Tomcat a son propre EntityManager, évitant ainsi les corruptions de données en cas d'accès concurrents. »*
  * *(Transition)* : *« Nizar va vous présenter comment nous avons validé la robustesse du code. »*

---

### 🧪 Slide 7 : Robustesse & Tests Unitaires (JUnit)
* **Intervenant :** **Nizar** (Membre 3)
* **Ce qu'il faut dire à l'oral :**
  > *« Afin d'assurer la robustesse du projet, j'ai écrit une suite de tests unitaires automatisés sous JUnit 4. Nous validons ainsi de manière isolée le formatage des dates des séances, la capitalisation automatique des noms des étudiants, et le comportement d'erreur de la persistance dans JPAUtil. Cela sécurise nos builds. »*
  > *(Transition)* : *« Passons à présent à la démonstration vidéo de notre application. »*

---

### 🎥 Slide 8 : Démonstration de l'Application (Vidéo)
* **Intervenants :** **Tous les membres** (Chacun commente son espace à l'écran)
* **Ce qu'il faut dire à l'oral :**
  * **Chafiq (Membre 1) :**
    > *« À l'écran, après connexion en tant qu'Administrateur, j'accède au registre global des absences. Je réalise ensuite un export CSV, lisible sous Microsoft Excel grâce à la signature BOM UTF-8 que j'ai injectée. »*
  * **Nizar (Membre 3) :**
    > *« Nous voyons maintenant l'espace Enseignant. Le professeur choisit sa séance et remplit l'appel sur une grille interactive réactive. La validation enregistre les absences en masse dans la base de données. »*
  * **Adam Asaas (Membre 2) :**
    > *« Voici le tableau de bord de l'Étudiant, affichant son taux d'assiduité et ses absences. L'étudiant peut y téléverser un justificatif médical PDF de façon sécurisée, ce qui passe l'absence au statut 'En attente'. »*
  * **Adam Bibilou (Membre 4) :**
    > *« Enfin, l'étudiant peut émettre une réclamation en cas d'erreur d'appel. Côté admin, on voit le portail de modération : l'administrateur valide le justificatif ou accepte la réclamation, ce qui met à jour ou supprime l'absence en base. »*
  * *(Transition)* : *« Pour conclure cette présentation, je laisse la parole à Adam Bibilou. »*

---

### 🤝 Slide 9 : Conclusion & Remerciements
* **Intervenant :** **Adam Bibilou** (Membre 4)
* **Ce qu'il faut dire à l'oral :**
  > *« Pour conclure, notre plateforme répond à l'ensemble des besoins de gestion d'assiduité tout en respectant les bonnes pratiques logicielles. Pour aller plus loin, nous envisageons d'évoluer vers une architecture microservices et d'intégrer des alertes en temps réel par SMS et e-mail. Nous vous remercions pour votre attention et sommes prêts à répondre à vos questions. »*
