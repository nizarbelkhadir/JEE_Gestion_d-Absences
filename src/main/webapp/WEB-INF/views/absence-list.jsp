<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Absences - Tableau de bord</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1.1">
</head>
<body>

<div class="container">
    <!-- Header -->
    <header>
        <div class="logo-section">
            <h1>Portail Absences</h1>
            <p>Système académique de suivi des présences et justifications</p>
        </div>
        <div style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
            <span style="color: var(--text-secondary); font-size: 0.9rem; margin-right: 0.5rem; display: inline-flex; align-items: center; gap: 0.35rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                ${sessionScope.adminUser}
            </span>
            <a href="${pageContext.request.contextPath}/absences?action=adminRequests" class="btn btn-secondary" style="padding: 0.6rem 1.2rem; font-size: 0.9rem; background: rgba(139, 92, 246, 0.12); border-color: rgba(139, 92, 246, 0.25); color: #a78bfa; text-decoration: none; display: inline-flex; align-items: center; gap: 0.35rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                </svg>
                Demandes d'étudiants
            </a>
            <a href="${pageContext.request.contextPath}/absences?action=new" class="btn btn-primary" style="padding: 0.6rem 1.2rem; font-size: 0.9rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Déclarer une absence
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

    <!-- Success and Info Banners -->
    <c:if test="${param.msg == 'success'}">
        <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            L'absence a été enregistrée avec succès dans le système.
        </div>
    </c:if>
    <c:if test="${param.msg == 'deleted'}">
        <div class="alert alert-success" style="border-color: var(--accent-purple-glow); color: var(--text-primary); background: rgba(139, 92, 246, 0.15)">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            </svg>
            L'enregistrement d'absence a été retiré avec succès.
        </div>
    </c:if>

    <!-- Statistics Grid -->
    <div class="stats-grid">
        <!-- Total Absences -->
        <div class="stat-card total">
            <span class="stat-label">Total Absences</span>
            <span class="stat-value">${totalAbsences}</span>
            <span class="stat-desc">Enregistrements d'absence</span>
        </div>
        <!-- Unjustified Absences -->
        <div class="stat-card unjustified">
            <span class="stat-label">Non Justifiées</span>
            <span class="stat-value">${unjustifiedAbsences}</span>
            <span class="stat-desc">Nécessitant un justificatif</span>
        </div>
        <!-- Justification Rate -->
        <div class="stat-card justification-rate">
            <span class="stat-label">Taux de Justification</span>
            <span class="stat-value">${tauxJustification}%</span>
            <span class="stat-desc">De dossiers régularisés</span>
        </div>
        <!-- Record Absence Student -->
        <div class="stat-card most-absent">
            <span class="stat-label">Élève le plus absent</span>
            <span class="stat-value" style="font-size: 1.05rem; line-height: 1.6rem; margin-top: 0.6rem; font-weight: 600;">${mostAbsentStudent}</span>
            <span class="stat-desc">Dossier à suivre</span>
        </div>
    </div>

    <!-- Absences List Card -->
    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <h2 style="font-size: 1.4rem; font-weight: 600;">Historique des Absences</h2>
            <div style="display: flex; gap: 0.75rem; align-items: center;">
                <a href="${pageContext.request.contextPath}/absences?action=export" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.9rem;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                    Exporter en CSV
                </a>
                <span style="color: var(--text-muted); font-size: 0.9rem;">
                    Total: <strong style="color: var(--accent-purple);">${absences.size()}</strong> enregistrement(s)
                </span>
            </div>
        </div>

        <!-- Filtering Toolbar -->
        <div style="display: flex; gap: 1rem; margin-bottom: 1.5rem; flex-wrap: wrap;">
            <input type="text" id="searchInput" onkeyup="filterAbsences()" placeholder="Rechercher par étudiant, cours ou motif..." class="form-control" style="flex: 1; min-width: 280px;">
            <select id="statusFilter" onchange="filterAbsences()" class="form-control" style="width: 200px;">
                <option value="ALL">Tous les statuts</option>
                <option value="JUSTIF">Justifiées</option>
                <option value="NONJUSTIF">Non justifiées</option>
            </select>
        </div>

        <c:choose>
            <c:when test="${empty absences}">
                <div style="text-align: center; padding: 3rem 0; color: var(--text-secondary);">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 1rem; opacity: 0.5; color: var(--text-muted)">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <p style="font-size: 1.1rem; font-weight: 500;">Aucune absence enregistrée pour le moment</p>
                    <p style="font-size: 0.9rem; color: var(--text-muted); margin-top: 0.25rem;">Les étudiants se portent bien ! Cliquez sur le bouton ci-dessus pour déclarer un cas.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>CNE</th>
                                <th>Étudiant</th>
                                <th>Séance de Cours</th>
                                <th>Date de Saisie</th>
                                <th style="text-align: center;">Statut</th>
                                <th>Motif / Justification</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="abs" items="${absences}">
                                <tr>
                                    <td style="font-family: monospace; font-weight: 600; color: var(--accent-blue);">${abs.etudiant.cne}</td>
                                    <td>
                                        <div style="font-weight: 500;">${abs.etudiant.nomComplet}</div>
                                        <div style="font-size: 0.8rem; color: var(--text-muted);">${abs.etudiant.email}</div>
                                    </td>
                                    <td>
                                        <div style="font-weight: 500;">${abs.seance.cours.nomCours}</div>
                                        <div style="font-size: 0.8rem; color: var(--text-secondary);">${abs.seance.label}</div>
                                    </td>
                                    <td style="color: var(--text-secondary); font-size: 0.9rem;">
                                        ${abs.formattedDateSaisie}
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${abs.estJustifiee}">
                                                <span class="badge badge-justified">Justifiée</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-unjustified">Non justifiée</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${abs.estJustifiee && not empty abs.motifJustification}">
                                                <div style="color: var(--text-primary); font-size: 0.9rem; font-weight: 500;">${abs.motifJustification}</div>
                                                <c:if test="${not empty abs.pieceJustificativePath}">
                                                    <div style="margin-top: 0.5rem;">
                                                        <a href="${pageContext.request.contextPath}/${abs.pieceJustificativePath}" target="_blank" class="btn btn-secondary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem; display: inline-flex; align-items: center; gap: 0.25rem;">
                                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                                                <polyline points="14 2 14 8 20 8"></polyline>
                                                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                                                <line x1="16" y1="17" x2="8" y2="17"></line>
                                                                <polyline points="10 9 9 9 8 9"></polyline>
                                                            </svg>
                                                            Voir le justificatif
                                                        </a>
                                                    </div>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted); font-style: italic;">Aucun motif fourni</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <a href="${pageContext.request.contextPath}/absences?action=delete&id=${abs.id}" 
                                           class="btn btn-danger" 
                                           style="padding: 0.4rem 0.8rem; font-size: 0.85rem;"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet enregistrement d\'absence ?');">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <polyline points="3 6 5 6 21 6"></polyline>
                                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                            </svg>
                                            Retirer
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2026 - Application de Gestion des Absences &bull; Technologie Java EE 8 pur &bull; JSP &amp; JPA (Hibernate)</p>
        <p style="margin-top: 0.5rem; font-size: 0.8rem; color: var(--text-muted);">
            Développé pour la soutenance de fin de module.
        </p>
    </footer>
</div>

<script>
    function filterAbsences() {
        var input = document.getElementById("searchInput");
        var filter = input.value.toUpperCase();
        var select = document.getElementById("statusFilter");
        var statusFilter = select.value;
        
        var table = document.querySelector("table");
        if (!table) return;
        var tr = table.getElementsByTagName("tr");
        
        for (var i = 1; i < tr.length; i++) {
            var tdStudent = tr[i].getElementsByTagName("td")[1]; // Student Name
            var tdCourse = tr[i].getElementsByTagName("td")[2];  // Course Name
            var tdStatus = tr[i].getElementsByTagName("td")[4];  // Status (badge text)
            var tdMotif = tr[i].getElementsByTagName("td")[5];   // Motif
            
            if (tdStudent && tdCourse && tdStatus) {
                var studentText = tdStudent.textContent || tdStudent.innerText;
                var courseText = tdCourse.textContent || tdCourse.innerText;
                var statusText = tdStatus.textContent || tdStatus.innerText;
                var motifText = tdMotif ? (tdMotif.textContent || tdMotif.innerText) : "";
                
                var matchesSearch = (studentText.toUpperCase().indexOf(filter) > -1) || 
                                    (courseText.toUpperCase().indexOf(filter) > -1) ||
                                    (motifText.toUpperCase().indexOf(filter) > -1);
                                    
                var matchesStatus = true;
                if (statusFilter === "JUSTIF") {
                    matchesStatus = statusText.trim().toUpperCase().indexOf("JUSTIFIÉE") > -1;
                } else if (statusFilter === "NONJUSTIF") {
                    matchesStatus = statusText.trim().toUpperCase().indexOf("NON JUSTIFIÉE") > -1;
                }
                
                if (matchesSearch && matchesStatus) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }
</script>

</body>
</html>
