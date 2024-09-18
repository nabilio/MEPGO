#!/bin/bash

# Vérifier si WordPress est téléchargé, sinon le télécharger
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Téléchargement de WordPress..."
    wp core download --path=/var/www/html --allow-root

    echo "Création du fichier wp-config.php..."
    wp config create --dbname=wordpress --dbuser=root --dbpass=root --dbhost=db --path=/var/www/html --allow-root
fi

# Vérifier si WordPress est déjà configuré
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Lancement de l'interface de préconfiguration..."

    # Lancer Apache en arrière-plan pour permettre l'accès à l'interface de configuration
    apache2-foreground &
    
    # Attendre que l'utilisateur soumette le formulaire de préconfiguration
    while [ ! -f /var/www/html/wp-config.php ]; do
        sleep 5
    done

    echo "Configuration initiale terminée, installation de WordPress..."

    # Lire les paramètres configurés
    SITENAME=$(cat /var/www/html/sitename.txt)
    ADMINUSER=$(cat /var/www/html/adminuser.txt)
    ADMINPASS=$(cat /var/www/html/adminpass.txt)
    ADMINEMAIL=$(cat /var/www/html/adminemail.txt)
    THEMENAME=$(cat /var/www/html/themename.txt)
    WOOCOMMERCE=$(cat /var/www/html/woocommerce.txt)

    # Installer WordPress
    wp core install --url="http://localhost:8080" --title="$SITENAME" --admin_user="$ADMINUSER" --admin_password="$ADMINPASS" --admin_email="$ADMINEMAIL" --path=/var/www/html --allow-root

    # Installer le thème choisi
    if [ ! -z "$THEMENAME" ]; then
        wp theme install $THEMENAME --activate --path=/var/www/html --allow-root
    fi

    # Activer WooCommerce si sélectionné
    if [ "$WOOCOMMERCE" == "yes" ]; then
        wp plugin install woocommerce --activate --path=/var/www/html --allow-root
    fi

    echo "WordPress installé avec succès."
else
    # Démarrer Apache normalement si WordPress est déjà installé
    apache2-foreground
fi
