# Utilise l'image officielle WordPress avec PHP et Apache
FROM wordpress:latest

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    less \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Ajouter une configuration pour le ServerName afin d'éviter l'erreur AH00558
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Installer WP-CLI pour configurer WordPress via ligne de commande
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Créer un utilisateur non-root
RUN useradd -ms /bin/bash wpuser

# Copier le script de démarrage personnalisé
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copier le configurateur PHP pour la page de préconfiguration
COPY ./configurator.php /var/www/html/configurator.php

# Changer les permissions pour l'utilisateur non-root
RUN chown -R wpuser:wpuser /var/www/html

# Passer à l'utilisateur non-root
USER wpuser

# Utiliser notre script d'entrypoint personnalisé
ENTRYPOINT ["/entrypoint.sh"]

# Exposer le port 80 pour le serveur web
EXPOSE 80

# Commande par défaut pour démarrer Apache
CMD ["apache2-foreground"]
