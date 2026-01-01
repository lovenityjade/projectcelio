#!/bin/bash

# ==========================================
# PROJECT CELIO - INITIAL DEPLOYMENT SCRIPT (V2)
# Author: TheLovenityJade & Gemini (Architect)
# ==========================================

# --- CONFIGURATION ---
DOMAIN="projectcelio.xyz"
EMAIL="admin@projectcelio.xyz"
DB_NAME="celio_db"
DB_USER="celio_master"
DB_PASS=$(openssl rand -base64 12)
PROJECT_ROOT="/home/projectcelio"
WEB_ROOT="/var/www/projectcelio"
REPO_URL="https://github.com/lovenityjade/projectcelio.git"

# Liens Sociaux
LINK_GITHUB="https://github.com/lovenityjade/projectcelio"
LINK_DISCORD="https://discord.gg/mMqWGWrX"
LINK_TWITTER="https://x.com/celiorando"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==============================================${NC}"
echo -e "${CYAN}   PROJECT CELIO: DEPLOYMENT V2 STARTED       ${NC}"
echo -e "${CYAN}==============================================${NC}"

# 1. SYSTEM HYGIENE
echo -e "${GREEN}[1/8] Nettoyage et Mise à jour du système...${NC}"
rm /etc/apt/sources.list.d/webmin.list 2>/dev/null || true
rm /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-*.list 2>/dev/null || true
apt-get clean
apt-get update -y
apt-get upgrade -y

# 2. DEPENDENCIES
echo -e "${GREEN}[2/8] Installation des dépendances...${NC}"
apt-get install -y apache2 python3 python3-pip python3-venv git curl unzip software-properties-common mariadb-client certbot python3-certbot-apache

a2enmod proxy proxy_http headers rewrite ssl
systemctl restart apache2

# 3. DATABASE SETUP
echo -e "${GREEN}[3/8] Configuration de la Base de Données...${NC}"
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

mysql -u root ${DB_NAME} <<EOF
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role ENUM('user', 'admin', 'mod') DEFAULT 'user'
);
EOF

# Sauvegarde des credentials
echo "DB_NAME=${DB_NAME}" > /root/celio_db_creds.txt
echo "DB_USER=${DB_USER}" >> /root/celio_db_creds.txt
echo "DB_PASS=${DB_PASS}" >> /root/celio_db_creds.txt
chmod 600 /root/celio_db_creds.txt

# 4. FILESYSTEM
echo -e "${GREEN}[4/8] Création de l'arborescence...${NC}"
mkdir -p ${PROJECT_ROOT}/backend
mkdir -p ${PROJECT_ROOT}/frontend
mkdir -p ${PROJECT_ROOT}/data
mkdir -p ${WEB_ROOT}

if [ -d "${PROJECT_ROOT}/.git" ]; then
    echo "   -> Repo déjà présent, mise à jour..."
    cd ${PROJECT_ROOT} && git pull
else
    echo "   -> Clonage du repo Project Celio..."
    git clone ${REPO_URL} ${PROJECT_ROOT}
fi

touch ${PROJECT_ROOT}/docker-compose.yml
touch ${PROJECT_ROOT}/.env

# 5. LANDING PAGE (UPDATED WITH SOCIALS)
echo -e "${GREEN}[5/8] Génération de la Landing Page V2...${NC}"
cat <<EOF > ${WEB_ROOT}/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Celio | Network Center</title>
    <style>
        :root {
            --bg-main: #0a0f1c;
            --text-main: #F0F4F8;
            --color-primary: #00E5FF;
            --color-secondary: #0070F3;
            --color-hover: #1f2d40;
        }
        body {
            background-color: var(--bg-main);
            color: var(--text-main);
            font-family: 'Courier New', Courier, monospace;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }
        h1 {
            font-size: 3rem;
            text-shadow: 0 0 10px var(--color-primary);
            margin-bottom: 0.5rem;
        }
        .status {
            color: var(--color-primary);
            border: 1px solid var(--color-primary);
            padding: 10px 20px;
            border-radius: 5px;
            text-transform: uppercase;
            letter-spacing: 2px;
            box-shadow: 0 0 15px rgba(0, 229, 255, 0.2);
            display: inline-block;
            margin-bottom: 2rem;
        }
        .container {
            max-width: 800px;
            padding: 20px;
        }
        p { color: #8892b0; margin-bottom: 2rem; }
        
        /* SOCIAL LINKS STYLING */
        .social-row {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }
        .btn-social {
            text-decoration: none;
            color: var(--text-main);
            border: 1px solid var(--color-secondary);
            padding: 10px 20px;
            border-radius: 4px;
            transition: all 0.3s ease;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 0.9rem;
        }
        .btn-social:hover {
            background-color: var(--color-secondary);
            box-shadow: 0 0 15px var(--color-secondary);
            color: white;
            transform: translateY(-2px);
        }
        .footer {
            margin-top: 50px;
            font-size: 0.8rem;
            color: #4a5568;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>PROJECT CELIO</h1>
        <p>Cross-Game Infrastructure for Pokémon FRLG + Emerald</p>
        
        <div class="status">Network Center : Online</div>
        
        <p>The Factory is currently being deployed. Join the network:</p>
        
        <div class="social-row">
            <a href="${LINK_GITHUB}" target="_blank" class="btn-social">GitHub</a>
            <a href="${LINK_DISCORD}" target="_blank" class="btn-social">Discord</a>
            <a href="${LINK_TWITTER}" target="_blank" class="btn-social">X / Twitter</a>
        </div>

        <div class="footer">
            Developed by TheLovenityJade
        </div>
    </div>
</body>
</html>
EOF

# 6. APACHE CONFIG
echo -e "${GREEN}[6/8] Configuration Apache VHost...${NC}"
cat <<EOF > /etc/apache2/sites-available/projectcelio.conf
<VirtualHost *:80>
    ServerName ${DOMAIN}
    ServerAlias www.${DOMAIN}
    DocumentRoot ${WEB_ROOT}

    <Directory ${WEB_ROOT}>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/celio_error.log
    CustomLog \${APACHE_LOG_DIR}/celio_access.log combined
</VirtualHost>
EOF

a2dissite 000-default.conf 2>/dev/null || true
a2ensite projectcelio.conf
systemctl reload apache2

# 7. PERMISSIONS
echo -e "${GREEN}[7/8] Ajustement des permissions...${NC}"
REAL_USER=${SUDO_USER:-$(whoami)}
chown -R $REAL_USER:$REAL_USER ${PROJECT_ROOT}
chown -R www-data:www-data ${WEB_ROOT}
chmod -R 755 ${WEB_ROOT}

# 8. SSL
echo -e "${GREEN}[8/8] Sécurisation SSL...${NC}"
certbot --apache -d ${DOMAIN} --non-interactive --agree-tos -m ${EMAIL} || echo -e "${RED}Warning: SSL setup issue. Check logs.${NC}"

echo -e "${CYAN}==============================================${NC}"
echo -e "${CYAN}   DEPLOYMENT V2 COMPLETE                     ${NC}"
echo -e "${CYAN}==============================================${NC}"
echo -e "Web Access : http://${DOMAIN}"
