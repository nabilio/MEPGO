<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Enregistrer les données soumises
    file_put_contents('sitename.txt', $_POST['sitename']);
    file_put_contents('adminuser.txt', $_POST['adminuser']);
    file_put_contents('adminpass.txt', $_POST['adminpass']);
    file_put_contents('adminemail.txt', $_POST['adminemail']);
    file_put_contents('themename.txt', $_POST['themename']);
    file_put_contents('woocommerce.txt', $_POST['woocommerce'] == 'on' ? 'yes' : 'no');
    
    // Créer le fichier de configuration WordPress pour indiquer que l'installation peut commencer
    touch('wp-config.php');
    echo "Configuration enregistrée avec succès. WordPress va maintenant s'installer.";
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Configuration Initiale de Votre Site</title>
</head>
<body>
    <h1>Configurer votre site WordPress</h1>
    <form method="post">
        <label for="sitename">Nom du site:</label>
        <input type="text" id="sitename" name="sitename" required><br>

        <label for="adminuser">Nom d'utilisateur admin:</label>
        <input type="text" id="adminuser" name="adminuser" required><br>

        <label for="adminpass">Mot de passe admin:</label>
        <input type="password" id="adminpass" name="adminpass" required><br>

        <label for="adminemail">Email admin:</label>
        <input type="email" id="adminemail" name="adminemail" required><br>

        <label for="themename">Thème (optionnel):</label>
        <input type="text" id="themename" name="themename"><br>

        <label for="woocommerce">Activer WooCommerce:</label>
        <input type="checkbox" id="woocommerce" name="woocommerce"><br>

        <input type="submit" value="Configurer">
    </form>
</body>
</html>
