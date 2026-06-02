<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Portail Absences</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1.1">
</head>
<body style="display: flex; align-items: center; justify-content: center; min-height: 100vh;">

<div class="container" style="max-width: 450px; padding: 1.5rem;">
    <!-- Brand Title -->
    <div style="text-align: center; margin-bottom: 2rem;">
        <h1 style="font-size: 2.25rem; font-weight: 700; letter-spacing: -0.025em; background: linear-gradient(135deg, #fff 30%, var(--accent-purple) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Portail Absences</h1>
        <p style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 0.25rem;">Espace d'administration académique</p>
    </div>

    <!-- Error Alert -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" style="margin-bottom: 1.5rem;">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polygon points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2"></polygon>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            ${errorMessage}
        </div>
    </c:if>

    <!-- Login Card -->
    <div class="card">
        <form action="${pageContext.request.contextPath}/absences?action=loginSubmit" method="POST">
            
            <div class="form-group">
                <label for="email">Identifiant / E-mail</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="admin@univ.fr" value="${rememberedAdmin}" required autocomplete="username">
            </div>

            <div class="form-group" style="margin-bottom: 1rem;">
                <label for="password">Mot de passe</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required autocomplete="current-password">
            </div>

            <!-- Remember Me Cookie Toggle -->
            <label class="toggle-container" style="margin: 1.25rem 0;">
                <input type="checkbox" id="remember" name="remember" value="true" ${not empty rememberedAdmin ? 'checked' : ''}>
                <span class="toggle-switch"></span>
                <span style="font-size: 0.9rem; user-select: none; color: var(--text-secondary);">Se souvenir de moi (Cookie)</span>
            </label>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.85rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                    <polyline points="10 17 15 12 10 7"></polyline>
                    <line x1="15" y1="12" x2="3" y2="12"></line>
                </svg>
                Se connecter
            </button>
            
            <!-- Academic Notice -->
            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.8rem; color: var(--text-muted); line-height: 1.45;">
                <strong>Comptes de Démo :</strong><br>
                <span style="color: var(--text-secondary);">Administration :</span> admin@univ.fr / admin<br>
                <span style="color: var(--text-secondary);">Professeur :</span> prof.bazza@univ.fr / prof<br>
                <span style="color: var(--text-secondary);">Étudiant :</span> nizar.belkhadir@univ.fr / etudiant
            </div>

        </form>
    </div>

    <!-- Footer -->
    <footer style="margin-top: 2.5rem;">
        <p>&copy; 2026 - Administration Java EE 8</p>
    </footer>
</div>

</body>
</html>
