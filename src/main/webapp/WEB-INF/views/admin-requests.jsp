<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demandes Étudiants - Portail Administration</title>
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
        .badge-justif {
            background: rgba(59, 130, 246, 0.15);
            color: #3b82f6;
            border: 1px solid rgba(59, 130, 246, 0.25);
        }
        .badge-reclam {
            background: rgba(139, 92, 246, 0.15);
            color: var(--accent-purple);
            border: 1px solid rgba(139, 92, 246, 0.25);
        }
        .request-card {
            background: rgba(30, 41, 59, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            transition: all 0.2s ease;
        }
        .request-card:hover {
            border-color: rgba(255, 255, 255, 0.15);
            background: rgba(30, 41, 59, 0.55);
        }
        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            padding-bottom: 0.75rem;
        }
        .request-student {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
        }
        .request-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            font-size: 0.9rem;
        }
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        .detail-label {
            color: var(--text-muted);
            font-size: 0.8rem;
            text-transform: uppercase;
        }
        .detail-value {
            color: var(--text-secondary);
            font-weight: 500;
        }
        .request-message {
            background: rgba(15, 23, 42, 0.3);
            border-radius: 8px;
            padding: 1rem;
            font-size: 0.95rem;
            color: var(--text-secondary);
            border-left: 3px solid var(--accent-purple);
        }
        .action-bar {
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Header -->
    <header>
        <div class="logo-section">
            <h1>Demandes & Justifications</h1>
            <p>Espace de modération et régularisation des absences étudiantes</p>
        </div>
        <div style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/absences?action=list" class="btn btn-secondary" style="padding: 0.6rem 1.2rem; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 0.35rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Retour aux Absences
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

    <!-- Success banner -->
    <c:if test="${param.msg == 'resolved'}">
        <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            La demande a été traitée et le statut d'absence a été mis à jour avec succès.
        </div>
    </c:if>

    <!-- Content -->
    <div class="card">
        <h2 style="font-size: 1.4rem; font-weight: 600; margin-bottom: 1.5rem;">Demandes de régularisation en attente (${pendingAbsences.size()})</h2>

        <c:choose>
            <c:when test="${empty pendingAbsences}">
                <div style="text-align: center; padding: 4rem 0; color: var(--text-secondary);">
                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 1.5rem; opacity: 0.5; color: #10b981">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    <p style="font-size: 1.2rem; font-weight: 500; color: var(--text-primary);">Toutes les demandes ont été traitées !</p>
                    <p style="font-size: 0.95rem; color: var(--text-muted); margin-top: 0.25rem;">Aucune demande de justificatif ou réclamation n'est en attente.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="abs" items="${pendingAbsences}">
                    <!-- Determine if it is a justification or reclamation -->
                    <c:set var="isJustif" value="${abs.statusJustification == 'PENDING'}" />
                    
                    <div class="request-card">
                        <div class="request-header">
                            <div>
                                <span class="request-student">${abs.etudiant.nom} ${abs.etudiant.prenom}</span>
                                <span style="color: var(--text-muted); font-size: 0.9rem; margin-left: 0.5rem;">(CNE: ${abs.etudiant.cne})</span>
                            </div>
                            <c:choose>
                                <c:when test="${isJustif}">
                                    <span class="badge badge-justif">Demande Justificatif</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-reclam">Réclamation</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="request-details">
                            <div class="detail-item">
                                <span class="detail-label">Cours</span>
                                <span class="detail-value">${abs.seance.cours.nomCours}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Séance</span>
                                <span class="detail-value">${abs.seance.label}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Date Séance</span>
                                <span class="detail-value">${abs.seance.formattedDate}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Date Absence</span>
                                <span class="detail-value">${abs.formattedDateSaisie}</span>
                            </div>
                        </div>

                        <div class="request-message">
                            <strong>Message de l'étudiant :</strong><br>
                            <c:choose>
                                <c:when test="${isJustif}">
                                    ${abs.motifDemandeJustif}
                                </c:when>
                                <c:otherwise>
                                    ${abs.motifReclamation}
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${isJustif && not empty abs.demandeJustifFilePath}">
                            <div style="font-size: 0.9rem;">
                                <span style="color: var(--text-muted);">Pièce jointe : </span>
                                <a href="${pageContext.request.contextPath}/${abs.demandeJustifFilePath}" target="_blank" style="color: var(--accent-purple); font-weight: 500; text-decoration: underline; display: inline-flex; align-items: center; gap: 0.25rem;">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"></path>
                                    </svg>
                                    Visualiser le document justificatif
                                </a>
                            </div>
                        </c:if>

                        <div class="action-bar">
                            <c:choose>
                                <c:when test="${isJustif}">
                                    <a href="${pageContext.request.contextPath}/absences?action=resolveJustification&id=${abs.id}&decision=refuse" class="btn btn-secondary" style="padding: 0.5rem 1.2rem; font-size: 0.85rem; border-color: rgba(239, 68, 68, 0.25); color: #ef4444; background: rgba(239, 68, 68, 0.05);">
                                        Refuser le motif
                                    </a>
                                    <a href="${pageContext.request.contextPath}/absences?action=resolveJustification&id=${abs.id}&decision=accept" class="btn btn-primary" style="padding: 0.5rem 1.5rem; font-size: 0.85rem; background: #10b981; border-color: #10b981;">
                                        Accepter & Justifier
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/absences?action=resolveReclamation&id=${abs.id}&decision=refuse" class="btn btn-secondary" style="padding: 0.5rem 1.2rem; font-size: 0.85rem; border-color: rgba(239, 68, 68, 0.25); color: #ef4444; background: rgba(239, 68, 68, 0.05);">
                                        Rejeter l'erreur
                                    </a>
                                    <a href="${pageContext.request.contextPath}/absences?action=resolveReclamation&id=${abs.id}&decision=accept" class="btn btn-primary" style="padding: 0.5rem 1.5rem; font-size: 0.85rem; background: var(--accent-purple); border-color: var(--accent-purple);">
                                        Valider (Supprimer l'absence)
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
