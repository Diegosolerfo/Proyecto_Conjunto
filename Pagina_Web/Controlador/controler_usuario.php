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
    }elseif($_POST['accion'] == 'crear_usuario'){
        $objeto = new usuario(
            cedula: $_POST['cedula'],
            nombre: $_POST['nombre'],
            apellido: $_POST['apellido'],
            contrasena: $_POST['contrasena'],
            correo: $_POST['correo'],
            tipo_usuario: $_POST['tipo_usuario'],
            telefono: $_POST['telefono'],
            genero: $_POST['genero'],
            fecha_nacimiento: $_POST['fecha_nacimiento']
        );
        $resultado = $objeto->crear_usuario();
        if($resultado){
            header('Location: ../Vista/Admin/adminis.php');
        }else{
            echo "<script>alert('Error al crear el usuario');</script>";
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
        $objeto->actualizar_usuario();
        //var_dump($_POST);
        header('Location: ../Vista/Admin/adminis.php');
        echo "<script>alert('Usuario actualizado correctamente');</script>";
    }elseif($_POST['accion'] == 'eliminar'){
        $objeto = new usuario(
            cedula: $_POST['cedula']
        );
        $respuesta = $objeto->eliminar_usuario();
        if($respuesta[0]['mensaje'] == '0' ){
            echo "<script>
                    alert('Usuario no se puede eliminar, tiene procesos abiertos');
                    window.location.href = '../Vista/Admin/adminis.php';
                </script>";            
        }else{
            echo "<script>
                    alert('Usuario fue eliminado correctamente');
                    window.location.href = '../Vista/Admin/adminis.php';
                </script>";
        }
    }
?>