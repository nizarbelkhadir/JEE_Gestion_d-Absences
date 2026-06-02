<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Enseignant - Appel de Présences</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1.2">
    <style>
        .grid-students {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
            margin-bottom: 2rem;
        }
        .student-item {
            background: rgba(15, 23, 42, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s ease;
        }
        .student-item:hover {
            border-color: rgba(239, 68, 68, 0.3);
            background: rgba(239, 68, 68, 0.02);
        }
        .student-item.checked {
            border-color: rgba(239, 68, 68, 0.5);
            background: rgba(239, 68, 68, 0.08);
        }
        .student-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        .student-name {
            font-weight: 600;
            color: var(--text-primary);
        }
        .student-cne {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        /* Switch toggle style */
        .switch {
            position: relative;
            display: inline-block;
            width: 48px;
            height: 24px;
        }
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.15);
            transition: .3s;
            border-radius: 24px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .3s;
            border-radius: 50%;
        }
        input:checked + .slider {
            background-color: #ef4444;
        }
        input:checked + .slider:before {
            transform: translateX(24px);
        }
        
        .section-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            padding-bottom: 0.75rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Header -->
    <header>
        <div class="logo-section">
            <h1>Espace Professeur</h1>
            <p>Bienvenue, <strong>${sessionScope.profUser.prenom} ${sessionScope.profUser.nom}</strong></p>
        </div>
        <div style="display: flex; gap: 0.75rem; align-items: center;">
            <span style="color: var(--text-secondary); font-size: 0.9rem; margin-right: 0.5rem; display: inline-flex; align-items: center; gap: 0.35rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                Enseignant
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

    <!-- Success banner -->
    <c:if test="${param.msg == 'callCompleted'}">
        <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            L'appel de présence a été enregistré avec succès. Les absences correspondantes ont été mises à jour.
        </div>
    </c:if>

    <!-- Main Card -->
    <div class="card">
        <div class="section-header">
            <h2 style="font-size: 1.4rem; font-weight: 600;">Saisie d'Appel (Faire l'appel)</h2>
            <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 0.25rem;">Sélectionnez une séance et cochez uniquement les étudiants <strong>absents</strong>.</p>
        </div>

        <form action="${pageContext.request.contextPath}/absences?action=profSubmitAbsences" method="POST">
            <!-- Seance Choice -->
            <div class="form-group" style="max-width: 500px; margin-bottom: 2rem;">
                <label for="seanceId">Séance d'Enseignement</label>
                <select name="seanceId" id="seanceId" class="form-control" required style="font-weight: 500;">
                    <option value="" disabled selected>-- Choisir une séance --</option>
                    <c:forEach var="s" items="${seances}">
                        <option value="${s.id}">
                            ${s.formattedDate} | ${s.label}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Student List Selection -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; flex-wrap: wrap; gap: 1rem;">
                <h3 style="font-size: 1.15rem; font-weight: 600; color: var(--text-primary);">Liste des étudiants de la classe</h3>
                <input type="text" id="studentSearch" onkeyup="filterStudents()" placeholder="Rechercher un étudiant par nom/CNE..." class="form-control" style="width: 300px; padding: 0.5rem 1rem;">
            </div>

            <div class="grid-students" id="studentsGrid">
                <c:forEach var="st" items="${etudiants}">
                    <div class="student-item" id="student-card-${st.id}">
                        <div class="student-info">
                            <span class="student-name">${st.nom} ${st.prenom}</span>
                            <span class="student-cne">CNE: ${st.cne} | ${st.email}</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <span style="font-size: 0.8rem; font-weight: 600; color: var(--text-muted);" id="status-label-${st.id}">PRÉSENT</span>
                            <label class="switch">
                                <input type="checkbox" name="absentStudents" value="${st.id}" onchange="toggleStudentCard(${st.id}, this)">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Form Actions -->
            <div style="display: flex; justify-content: flex-end; gap: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.08); padding-top: 1.5rem;">
                <button type="reset" onclick="resetForm()" class="btn btn-secondary" style="padding: 0.75rem 1.5rem;">Réinitialiser</button>
                <button type="submit" class="btn btn-primary" style="padding: 0.75rem 2rem; background: #ef4444; border-color: rgba(239, 68, 68, 0.2);">Enregistrer l'Appel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleStudentCard(studentId, checkbox) {
        const card = document.getElementById('student-card-' + studentId);
        const label = document.getElementById('status-label-' + studentId);
        
        if (checkbox.checked) {
            card.classList.add('checked');
            label.innerText = 'ABSENT';
            label.style.color = '#ef4444';
        } else {
            card.classList.remove('checked');
            label.innerText = 'PRÉSENT';
            label.style.color = 'var(--text-muted)';
        }
    }

    function filterStudents() {
        const query = document.getElementById('studentSearch').value.toLowerCase();
        const cards = document.querySelectorAll('#studentsGrid .student-item');

        cards.forEach(card => {
            const name = card.querySelector('.student-name').textContent.toLowerCase();
            const cne = card.querySelector('.student-cne').textContent.toLowerCase();
            
            if (name.includes(query) || cne.includes(query)) {
                card.style.display = 'flex';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function resetForm() {
        const cards = document.querySelectorAll('#studentsGrid .student-item');
        cards.forEach(card => {
            card.classList.remove('checked');
            const label = card.querySelector('[id^="status-label-"]');
            if (label) {
                label.innerText = 'PRÉSENT';
                label.style.color = 'var(--text-muted)';
            }
        });
    }
</script>

</body>
</html>
