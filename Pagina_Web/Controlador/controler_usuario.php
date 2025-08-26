<?php
    require_once '../Modelo/conexion.php';    
    require_once '../Modelo/usuariodto.php';    
    require_once '../Modelo/usuariodao.php';
    //var_dump($_POST);
    if($_POST['accion'] == 'login'){
    $usuariodto = new usuariodto();
    $usuariodto->setcedula($_POST['cedula']);
    $usuariodto->setclave($_POST['clave']);

    $usuariodao = new usuariodao();
    $resultado = $usuariodao->iniciar_sesion($usuariodto);
    //var_dump($usuariodto);
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
        //var_dump($_POST);
        $usuariodto_p = new usuariodto();
        $usuariodto_p->setcedula($_POST['cedula']);
        $usuariodao_p = new usuariodao();
        $respuesta_2 = $usuariodao_p->conid($usuariodto_p->getcedula());
        if($respuesta_2 != false){
            echo "<script>
                    alert('Error al crear usuario, la cédula ya existe');
                    window.location.href = '../Vista/Admin/adminis.php';
                </script>";
        }else{
            $usuariodto = new usuariodto();
            $usuariodto->setcedula($_POST['cedula']);
            $usuariodto->setnombre($_POST['nombre']);
            $usuariodto->setapellido($_POST['apellido']);
            $usuariodto->setclave($_POST['clave']);
            $usuariodto->setcorreo($_POST['correo']);
            $usuariodto->settipo_usuario($_POST['tipo_usuario']);
            $usuariodto->settelefono($_POST['telefono']);
            $usuariodto->setgenero($_POST['genero']);
            $usuariodto->setfecha_nacimiento($_POST['fecha_nacimiento']);
            $usuariodao = new usuariodao();
            $resultado = $usuariodao->crear_usuario($usuariodto);
            if($resultado){
                header('Location: ../Vista/Admin/adminis.php');
            }else{
                echo "<script>alert('Error al crear el usuario, reintente');</script>";
                header('Location: ../Vista/Admin/adminis.php');
            }
        }
    }elseif($_POST['accion'] == 'actualizar'){
        $usuariodto = new usuariodto();
        $usuariodto->setcedula($_POST['cedula']);
        $usuariodto->setnombre($_POST['nombre']);
        $usuariodto->setapellido($_POST['apellido']);
        $usuariodto->setcorreo($_POST['correo']);
        $usuariodto->settelefono($_POST['telefono']);
        $usuariodto->setgenero($_POST['genero']);
        $usuariodto->setfecha_nacimiento($_POST['fecha_nacimiento']);
        $usuariodto->setestado($_POST['estado']);
        $usuariodao = new usuariodao();
        $usuariodao->modificar($usuariodto);
        //var_dump($_POST);
        header('Location: ../Vista/Admin/adminis.php');
        echo "<script>alert('Usuario actualizado correctamente');</script>";
    }elseif($_POST['accion'] == 'eliminar'){
        $usuariodto = new usuariodto();
        $usuariodto->setcedula($_POST['cedula']);
        $usuariodao = new usuariodao();
        $respuesta = $usuariodao->eliminar($usuariodto);
        //var_dump($respuesta);
        $usuariodao_2 = new usuariodao();
        $respuesta_2 = $usuariodao_2->conid($usuariodto->getcedula());
        //var_dump($respuesta_2);
        if($respuesta == NULL && $respuesta_2 == false){
            echo "<script>
                    alert('Usuario fue eliminado correctamente');
                    window.location.href = '../Vista/Admin/adminis.php';
                </script>";            
        }else{
            echo "<script>
                    alert('Error al eliminar usuario, tiene procesos abiertos');
                    window.location.href = '../Vista/Admin/adminis.php';
                </script>";
        }
    }
    //var_dump($_POST);
?>