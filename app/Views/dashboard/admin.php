<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administrador</title>
</head>
<body>
    
    <h1>Bienvenido, Administrador <?= session()->get('Nombre') ?></h1>
    <nav>
        <ul>
            <li><a href="#">Gestionar Usuarios</a></li>
            <li><a href="#">Gestionar Productos</a></li>
            <li><a href="#">Reportes y Estadísticas</a></li>
            <li><a href="#">Configuración del Sistema</a></li>
        </ul>
    </nav>
    <a href="<?= base_url('logout') ?>">Cerrar Sesión</a>
</body>
</html>