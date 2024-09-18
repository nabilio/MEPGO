# Utilise l'image officielle WordPress avec PHP et Apache
FROM wordpress:latest

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    less \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Installer WP-CLI pour configurer WordPress via ligne de commande
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Changer les permissions de /var/www/html pour permettre l'accès à l'utilisateur non-root
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html

# Changer le port d'écoute d'Apache à 8080 pour éviter les problèmes de permissions sur le port 80
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/:80/:8080/' /etc/apache2/sites-available/*.conf

# Copier le script de démarrage personnalisé
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copier le configurateur PHP pour la page de préconfiguration
COPY ./configurator.php /var/www/html/configurator.php

# Exposer le port 8080 pour le serveur web
EXPOSE 8080

# Utiliser notre script d'entrypoint personnalisé
ENTRYPOINT ["/entrypoint.sh"]

# Commande par défaut pour démarrer Apache
CMD ["apache2-foreground"]
