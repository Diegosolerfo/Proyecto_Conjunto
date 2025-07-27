<?php
    include '../Modelo/Mod_Usuario.php';    
    if($_POST['accion'] == 'login'){    
    $objeto = new usuario(
        cedula: $_POST['cedula'],
        contrasena: $_POST['contrasena']
    );
    $resultado = $objeto->inicio_sesion();
    if(!empty($resultado)){
        session_start();
        $_SESSION['cedula'] = $resultado;
        if($resultado['TIPO_USUARIO'] == 'ADMINISTRADOR'){
            header('Location: ../Vista/Admin/adminis.php');
        }elseif($resultado['TIPO_USUARIO'] == 'CLIENTE'){
            header('Location: ../Vista/Cliente/client.php');
        }elseif($resultado['TIPO_USUARIO'] == 'CAJERO'){
            header('Location: ../Vista/Empleado/cajero.php');
        }else{
            echo "<script>alert('Tipo de usuario no reconocido');</script>";
            header('Location: ../Vista/login.html');
        }
    }
    }elseif($_POST['accion'] == 'crear_cliente'){
        $objeto = new usuario(
            cedula: $_POST['cedula'],
            nombre: $_POST['nombre'],
            apellido: $_POST['apellido'],
            contrasena: $_POST['contrasena'],
            correo: $_POST['correo'],
            tipo_usuario: 'CLIENTE',
            telefono: $_POST['telefono'],
            genero: $_POST['genero'],
            fecha_nacimiento: $_POST['fecha_nacimiento']
        );
        $resultado = $objeto->crear_cliente();
        if($resultado){
            header('Location: ../Vista/Admin/adminis.php');
        }else{
            echo "<script>alert('Error al crear el cliente');</script>";
            header('Location: ../Vista/Admin/adminis.php');
        }
    }elseif($_POST['accion'] == 'actualizar'){
        $objeto = new usuario(
            cedula: $_POST['cedula'],
            nombre: $_POST['nombre'],
            apellido: $_POST['apellido'],
            correo: $_POST['correo'],
            telefono: $_POST['telefono'],
            genero: $_POST['genero'],
            fecha_nacimiento: $_POST['fecha_nacimiento'],
            estado: $_POST['estado']
        );
        $objeto->actualizar_cliente();
        //var_dump($_POST);
        header('Location: ../Vista/Admin/adminis.php');
        echo "<script>alert('Usuario actualizado correctamente');</script>";
}
?>