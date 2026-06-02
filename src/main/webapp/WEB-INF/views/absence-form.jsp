<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saisie d'Absence - Portail Absences</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1.1">
    <script>
        // Smooth toggle of the justification motif textarea depending on checkbox state
        function toggleJustification() {
            var checkbox = document.getElementById("estJustifieeCheckbox");
            var motifSection = document.getElementById("motif-section");
            var motifTextarea = document.getElementById("motifJustification");
            
            if (checkbox.checked) {
                motifSection.style.display = "block";
                motifTextarea.setAttribute("required", "required");
                motifTextarea.focus();
            } else {
                motifSection.style.display = "none";
                motifTextarea.removeAttribute("required");
                motifTextarea.value = "";
            }
        }
    </script>
</head>
<body>

<div class="container" style="max-width: 700px;">
    <!-- Header -->
    <header>
        <div class="logo-section">
            <h1>Saisie d'Absence</h1>
            <p>Enregistrer une nouvelle absence dans le registre</p>
        </div>
        <div style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
            <span style="color: var(--text-secondary); font-size: 0.9rem; margin-right: 0.5rem; display: inline-flex; align-items: center; gap: 0.35rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                ${sessionScope.adminUser}
            </span>
            <a href="${pageContext.request.contextPath}/absences?action=list" class="btn btn-secondary" style="padding: 0.6rem 1rem; font-size: 0.9rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Retour
            </a>
            <a href="${pageContext.request.contextPath}/absences?action=logout" class="btn btn-danger" style="padding: 0.6rem 1.1rem; font-size: 0.9rem; border-color: rgba(239,68,68,0.25); background: rgba(239,68,68,0.08); text-decoration: none; border-radius: 10px; display: inline-flex; align-items: center; gap: 0.5rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
                Déconnexion
            </a>
        </div>
    </header>

    <!-- Error Alerts -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polygon points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2"></polygon>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            ${errorMessage}
        </div>
    </c:if>

    <!-- Form Card -->
    <div class="card">
        <form action="${pageContext.request.contextPath}/absences?action=insert" method="POST" enctype="multipart/form-data">
            
            <!-- Student Selection -->
            <div class="form-group">
                <label for="etudiantId">Sélectionner l'Étudiant <span style="color: var(--accent-purple);">*</span></label>
                <select id="etudiantId" name="etudiantId" class="form-control" required>
                    <option value="" disabled selected>-- Choisir un étudiant --</option>
                    <c:forEach var="etudiant" items="${etudiants}">
                        <option value="${etudiant.id}" ${param.etudiantId == etudiant.id ? 'selected' : ''}>
                            ${etudiant.nomComplet} (CNE: ${etudiant.cne})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Session Selection -->
            <div class="form-group">
                <label for="seanceId">Sélectionner la Séance de Cours <span style="color: var(--accent-purple);">*</span></label>
                <select id="seanceId" name="seanceId" class="form-control" required>
                    <option value="" disabled selected>-- Choisir un cours et une date --</option>
                    <c:forEach var="seance" items="${seances}">
                        <option value="${seance.id}" ${param.seanceId == seance.id ? 'selected' : ''}>
                            ${seance.label}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Justified Toggle Switch -->
            <div class="form-group">
                <label>Justification</label>
                <label class="toggle-container">
                    <input type="checkbox" id="estJustifieeCheckbox" name="estJustifiee" value="true" onchange="toggleJustification()">
                    <span class="toggle-switch"></span>
                    <span style="font-size: 0.95rem; user-select: none;">L'absence est-elle justifiée par l'administration ?</span>
                </label>
            </div>

            <!-- Motif Section (dynamically displayed) -->
            <div id="motif-section" class="form-group">
                <label for="motifJustification">Motif / Pièce justificative <span style="color: var(--accent-purple);">*</span></label>
                <textarea id="motifJustification" name="motifJustification" rows="3" class="form-control" placeholder="Ex: Certificat médical d'inaptitude, convocation officielle..."></textarea>
                
                <label for="pieceJustificative" style="margin-top: 1rem; display: block;">Déposer la pièce justificative (PDF, PNG, JPG)</label>
                <input type="file" id="pieceJustificative" name="pieceJustificative" class="form-control" accept=".pdf,.png,.jpg,.jpeg">
            </div>

            <!-- Submit Buttons -->
            <div style="display: flex; gap: 1rem; margin-top: 2rem; border-top: 1px solid var(--glass-border); padding-top: 1.5rem;">
                <button type="submit" class="btn btn-primary" style="flex: 1;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                        <polyline points="17 21 17 13 7 13 7 21"></polyline>
                        <polyline points="7 3 7 8 15 8"></polyline>
                    </svg>
                    Enregistrer l'absence
                </button>
                <a href="${pageContext.request.contextPath}/absences?action=list" class="btn btn-secondary" style="flex: 1;">
                    Annuler
                </a>
            </div>

        </form>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2026 - Application de Gestion des Absences &bull; Technologie Java EE 8 pur</p>
    </footer>
</div>

</body>
</html>
