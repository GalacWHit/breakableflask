# Étape 1 : build
FROM python:3.12-slim AS builder

# Définition du dossier de travail
WORKDIR /app

# Copier uniquement les fichiers nécessaires
COPY requirements.txt .

# Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Étape 2 : runtime
FROM python:3.12-slim

# Créer un utilisateur non-root
RUN useradd -m appuser

WORKDIR /app
COPY --from=builder /app /app
COPY . .

# Définir les permissions
RUN chown -R appuser:appuser /app

# Changer d’utilisateur
USER appuser

# Exposer le port (exemple)
EXPOSE 8000

# Commande par défaut
CMD ["python", "-m", "http.server", "8000"]

# Healthcheck pour surveiller le conteneur
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1
