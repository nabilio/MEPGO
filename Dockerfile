# Utilise l'image officielle WordPress avec PHP et Apache
FROM wordpress:latest

# Installer les dépendances nécessaires, y compris WP-CLI
RUN apt-get update && apt-get install -y \
    curl \
    less \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Installer WP-CLI pour gérer WordPress en ligne de commande
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# S'assurer que le répertoire WordPress est accessible à Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html

# Créer le fichier wp-config.php avec WP-CLI
RUN wp config create --dbname=wordpress --dbuser=root --dbpass=root --dbhost=db --path=/var/www/html --allow-root

# Changer le port d'écoute d'Apache à 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/:80/:8080/' /etc/apache2/sites-available/*.conf

# Exposer le port 8080 pour le serveur web
EXPOSE 8080

# Utiliser notre script d'entrypoint personnalisé pour gérer l'installation automatique
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Commande par défaut pour démarrer Apache
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
