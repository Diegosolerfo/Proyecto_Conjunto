<?php
    include 'Modelo/Mod_Usuario.php';
    $objeto = new usuario(
        cedula: $_POST['cedula'],
        contrasena: $_POST['contrasena']
    );
    $resultado = $objeto->inicio_sesion();
    var_dump($resultado);
?>