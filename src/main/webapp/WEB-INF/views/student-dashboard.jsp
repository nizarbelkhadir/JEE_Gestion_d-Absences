<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Étudiant - Gestion des Absences</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1.2">
    <style>
        .badge {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 30px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-success {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }
        .badge-danger {
            background: rgba(239, 68, 68, 0.15);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }
        .badge-warning {
            background: rgba(245, 158, 11, 0.15);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.25);
        }
        .badge-info {
            background: rgba(59, 130, 246, 0.15);
            color: #3b82f6;
            border: 1px solid rgba(59, 130, 246, 0.25);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(8px);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: rgba(30, 41, 59, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 2rem;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
            color: var(--text-primary);
            position: relative;
            animation: modalFadeIn 0.3s ease-out;
        }
        @keyframes modalFadeIn {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            padding-bottom: 0.75rem;
        }
        .modal-header h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--accent-purple);
        }
        .close-btn {
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 1.5rem;
        }
        .close-btn:hover {
            color: var(--text-primary);
        }
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-secondary);
        }
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            background: rgba(15, 23, 42, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus {
            border-color: var(--accent-purple);
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.15);
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Header -->
    <header>
        <div class="logo-section">
            <h1>Espace Étudiant</h1>
            <p>Bienvenue, <strong>${sessionScope.studentUser.prenom} ${sessionScope.studentUser.nom}</strong> (CNE: ${sessionScope.studentUser.cne})</p>
        </div>
        <div style="display: flex; gap: 0.75rem; align-items: center;">
            <span style="color: var(--text-secondary); font-size: 0.9rem; margin-right: 0.5rem; display: inline-flex; align-items: center; gap: 0.35rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                Étudiant
            </span>
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
    <c:if test="${param.msg == 'justifSubmitted'}">
        <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            Votre demande de justification a été soumise avec succès et est en attente de traitement.
        </div>
    </c:if>
    <c:if test="${param.msg == 'reclamSubmitted'}">
        <div class="alert alert-success" style="border-color: var(--accent-purple-glow); color: var(--text-primary); background: rgba(139, 92, 246, 0.15)">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            Votre réclamation a été transmise aux administrateurs.
        </div>
    </c:if>

    <!-- Statistics Grid -->
    <div class="stats-grid">
        <!-- Total Absences -->
        <div class="stat-card total">
            <span class="stat-label">Mes Absences</span>
            <span class="stat-value">${totalAbsences}</span>
            <span class="stat-desc">Sessions marquées absent</span>
        </div>
        <!-- Unjustified Absences -->
        <div class="stat-card unjustified">
            <span class="stat-label">Non Justifiées</span>
            <span class="stat-value">${unjustifiedAbsences}</span>
            <span class="stat-desc">À régulariser au plus vite</span>
        </div>
        <!-- Justified Absences -->
        <div class="stat-card justification-rate" style="border-color: rgba(16, 185, 129, 0.2); background: linear-gradient(135deg, rgba(16, 185, 129, 0.08) 0%, rgba(16, 185, 129, 0.02) 100%); box-shadow: 0 8px 32px 0 rgba(16, 185, 129, 0.05);">
            <span class="stat-label" style="color: #10b981;">Absences Justifiées</span>
            <span class="stat-value" style="color: #10b981;">${justifiedAbsences}</span>
            <span class="stat-desc">Dossiers acceptés</span>
        </div>
        <!-- Pending Requests -->
        <div class="stat-card most-absent" style="border-color: rgba(139, 92, 246, 0.2); background: linear-gradient(135deg, rgba(139, 92, 246, 0.08) 0%, rgba(139, 92, 246, 0.02) 100%);">
            <span class="stat-label" style="color: var(--accent-purple);">En Attente</span>
            <span class="stat-value" style="color: var(--accent-purple);">${pendingRequests}</span>
            <span class="stat-desc">Justificatifs/Réclamations</span>
        </div>
    </div>

    <!-- Absences List Card -->
    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <h2 style="font-size: 1.4rem; font-weight: 600;">Mon Historique Individuel d'Absences</h2>
            <div style="display: flex; gap: 1rem; align-items: center;">
                <input type="text" id="searchInput" onkeyup="filterAbsences()" placeholder="Filtrer par cours ou date..." class="form-control" style="width: 250px; padding: 0.5rem 1rem;">
            </div>
        </div>

        <c:choose>
            <c:when test="${empty absences}">
                <div style="text-align: center; padding: 3rem 0; color: var(--text-secondary);">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 1rem; opacity: 0.5; color: #10b981">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    <p style="font-size: 1.1rem; font-weight: 500; color: var(--text-primary);">Félicitations, vous n'avez aucune absence !</p>
                    <p style="font-size: 0.9rem; color: var(--text-muted); margin-top: 0.25rem;">Maintenez votre assiduité à 100%.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table id="absencesTable">
                        <thead>
                            <tr>
                                <th>Date & Heure</th>
                                <th>Séance de Cours</th>
                                <th>Professeur</th>
                                <th style="text-align: center;">Statut Global</th>
                                <th style="text-align: center;">Justification</th>
                                <th style="text-align: center;">Réclamation</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="abs" items="${absences}">
                                <tr>
                                    <td style="font-weight: 500;">${abs.formattedDateSaisie}</td>
                                    <td>
                                        <div style="font-weight: 600; color: var(--text-primary);">${abs.seance.cours.nomCours}</div>
                                        <div style="font-size: 0.8rem; color: var(--text-muted);">${abs.seance.cours.description}</div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty abs.seance.cours.professeur}">
                                                ${abs.seance.cours.professeur.nomComplet}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted);">Non assigné</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${abs.estJustifiee}">
                                                <span class="badge badge-success">Justifiée</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger">Non Justifiée</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${abs.estJustifiee}">
                                                <span class="badge badge-success">Acceptée</span>
                                            </c:when>
                                            <c:when test="${abs.statusJustification == 'PENDING'}">
                                                <span class="badge badge-warning">En attente</span>
                                            </c:when>
                                            <c:when test="${abs.statusJustification == 'REJECTED'}">
                                                <span class="badge badge-danger">Refusée</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted); font-size: 0.85rem;">Aucune</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${abs.statusReclamation == 'PENDING'}">
                                                <span class="badge badge-warning">En attente</span>
                                            </c:when>
                                            <c:when test="${abs.statusReclamation == 'REJECTED'}">
                                                <span class="badge badge-danger">Rejetée</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted); font-size: 0.85rem;">Aucune</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center; white-space: nowrap;">
                                        <c:if test="${not abs.estJustifiee && abs.statusJustification != 'PENDING'}">
                                            <button onclick="openJustifyModal(${abs.id}, '${abs.seance.cours.nomCours}')" class="btn btn-primary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem; border-radius: 6px; margin-right: 0.25rem;">
                                                Justifier
                                            </button>
                                        </c:if>
                                        <c:if test="${abs.statusReclamation == 'NONE'}">
                                            <button onclick="openReclaimModal(${abs.id}, '${abs.seance.cours.nomCours}')" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem; border-radius: 6px; background: rgba(255,255,255,0.05); color: var(--text-secondary); border-color: rgba(255,255,255,0.1);">
                                                Réclamer
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Modal Justification -->
<div id="justifyModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="justifyTitle">Justifier une absence</h3>
            <button onclick="closeModal('justifyModal')" class="close-btn">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/absences?action=submitJustification" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="absenceId" id="justifyAbsenceId">
            <div class="form-group">
                <label for="motifJustif">Motif / Explication</label>
                <textarea name="motif" id="motifJustif" class="form-control" rows="4" required placeholder="Expliquez la raison de votre absence..."></textarea>
            </div>
            <div class="form-group">
                <label for="pieceJustif">Pièce justificative (PDF, Image - Facultatif)</label>
                <input type="file" name="pieceJustificative" id="pieceJustif" class="form-control">
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 0.75rem; margin-top: 1.5rem;">
                <button type="button" onclick="closeModal('justifyModal')" class="btn btn-secondary" style="padding: 0.6rem 1.2rem;">Annuler</button>
                <button type="submit" class="btn btn-primary" style="padding: 0.6rem 1.2rem;">Envoyer la demande</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Réclamation -->
<div id="reclaimModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="reclaimTitle">Déclarer une réclamation</h3>
            <button onclick="closeModal('reclaimModal')" class="close-btn">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/absences?action=submitReclamation" method="POST">
            <input type="hidden" name="absenceId" id="reclaimAbsenceId">
            <div class="form-group">
                <label for="motifReclam">Description de l'erreur</label>
                <textarea name="motif" id="motifReclam" class="form-control" rows="4" required placeholder="Indiquez pourquoi cette absence est une erreur (ex: J'étais présent au cours...)"></textarea>
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 0.75rem; margin-top: 1.5rem;">
                <button type="button" onclick="closeModal('reclaimModal')" class="btn btn-secondary" style="padding: 0.6rem 1.2rem;">Annuler</button>
                <button type="submit" class="btn btn-primary" style="padding: 0.6rem 1.2rem; background: var(--accent-purple);">Soumettre la réclamation</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openJustifyModal(absenceId, coursNom) {
        document.getElementById('justifyAbsenceId').value = absenceId;
        document.getElementById('justifyTitle').innerText = "Justifier absence : " + coursNom;
        document.getElementById('justifyModal').style.display = 'flex';
    }

    function openReclaimModal(absenceId, coursNom) {
        document.getElementById('reclaimAbsenceId').value = absenceId;
        document.getElementById('reclaimTitle').innerText = "Réclamation absence : " + coursNom;
        document.getElementById('reclaimModal').style.display = 'flex';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    }

    function filterAbsences() {
        const query = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('#absencesTable tbody tr');

        rows.forEach(row => {
            const date = row.cells[0].textContent.toLowerCase();
            const cours = row.cells[1].textContent.toLowerCase();
            const prof = row.cells[2].textContent.toLowerCase();

            if (cours.includes(query) || date.includes(query) || prof.includes(query)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>

</body>
</html>
