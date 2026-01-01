# On utilise Python 3.11 (Recommandé pour Archipelago moderne)
FROM python:3.11-slim

# Installation des outils système (Git est souvent requis pour Archipelago)
# On ajoute cmake pour compiler dolphin-memory-engine
RUN apt-get update && apt-get install -y git build-essential cmake && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Installation des dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie du code (sera écrasé par le volume en dev, mais utile pour la prod)
COPY . .

# Exposition du port Flask
EXPOSE 5000

# Lancement avec Gunicorn (Serveur de prod)
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]
