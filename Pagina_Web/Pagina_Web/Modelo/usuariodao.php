<?php
    require_once 'conexion.php';
    require_once 'usuariodto.php';

    class usuariodao{
        public function iniciar_sesion(usuariodto $usuariodto){
            $conexion = Conexion::getConexion();
            $sql = "SELECT * FROM usuario WHERE cedula=? AND clave=?";
            try{
                $stmt = $conexion->prepare($sql);
                $cedula = $usuariodto->getcedula();
                $clave = $usuariodto->getclave();
                $stmt->bindParam(1,$cedula);
                $stmt->bindParam(2,$clave);
                $stmt->execute();
                return $stmt->fetch();
            }catch(PDOException $e){
                return null;
            }
        }
        public function panel_admin(){
            $conexion = Conexion::getConexion();
            try{
                $sql = "CALL PANEL_ADMIN();";
                $stm = $conexion->prepare($sql);
                $stm->execute();
                return $stm->fetch();
            }catch(Exception $e){
                $mensaje = "Error en la consulta: ". $e->getMessage();
            }
        }
        public function crear_usuario(usuariodto $usuariodto){
            $conexion = Conexion::getConexion();
            $sql = "INSERT INTO USUARIO (CEDULA,NOMBRE,APELLIDO,CLAVE,CORREO,TIPO_USUARIO,TELEFONO,GENERO,FECHA_NACIMIENTO)
                    VALUES (?,?,?,?,?,?,?,?,?);";
            $cedula = $usuariodto->getcedula();
            $nombre = $usuariodto->getnombre();
            $apellido = $usuariodto->getapellido();
            $clave = $usuariodto->getclave();
            $correo = $usuariodto->getcorreo();
            $tipo_usuario = $usuariodto->gettipo_usuario();
            $telefono = $usuariodto->gettelefono();
            $genero = $usuariodto->getgenero();
            $fecha_nacimiento = $usuariodto->getfecha_nacimiento();
            try{
                $stmt = $conexion->prepare($sql);
                $stmt->bindParam(1,$cedula);
                $stmt->bindParam(2,$nombre);
                $stmt->bindParam(3,$apellido);
                $stmt->bindParam(4,$clave);
                $stmt->bindParam(5,$correo);
                $stmt->bindParam(6,$tipo_usuario);
                $stmt->bindParam(7,$telefono);
                $stmt->bindParam(8,$genero);
                $stmt->bindParam(9,$fecha_nacimiento);
                return $stmt->execute();
                $mensaje = "Persona registrada correctamente";
            }catch(PDOException $e){
                $mensaje = "Error al registrar persona: " . $e->getMessage();
            }
            return $mensaje;
        }
        public function ver_usuarios(){
            $conexion = Conexion::getConexion();
            try{
                $sql = "SELECT CEDULA,NOMBRE,APELLIDO,CORREO,TELEFONO,GENERO,FECHA_NACIMIENTO,ESTADO FROM USUARIO WHERE TIPO_USUARIO = 'CLIENTE';";
                $stm = $conexion->prepare($sql);
                $stm->execute();
            return $stm->fetchAll();
            }catch(Exception $e){
                $mensaje = "Error en la consulta: ". $e->getMessage();
            }
        }
        public function ver_usuarios_2(){
            $conexion = Conexion::getConexion();
            try{
                $sql = "SELECT CEDULA,NOMBRE,APELLIDO,CORREO,TELEFONO,GENERO,FECHA_NACIMIENTO,ESTADO FROM USUARIO WHERE TIPO_USUARIO = 'CAJERO';";
                $stm = $conexion->prepare($sql);
                $stm->execute();
            return $stm->fetchAll();
            }catch(Exception $e){
                $mensaje = "Error en la consulta: ". $e->getMessage();
            }
        }
        public function conid($cedula){
            $conexion = Conexion::getConexion();
            try{
                $sql = "SELECT * FROM usuario WHERE cedula=?";
                $stm = $conexion->prepare($sql);
                $stm->bindParam(1,$cedula);
                $stm->execute();
                return $stm->fetch();
            }catch(Exception $e){
                $mensaje = "Error en la consulta: ". $e->getMessage();
            }
        }
        public function modificar(usuariodto $usuariodto){
            $mensaje= "";
            $conexion = Conexion::getConexion();
            try{
                $sql = "UPDATE usuario SET nombre=?, apellido=?, clave=?, correo=?, telefono=?, genero=?, fecha_nacimiento=?, estado=? WHERE cedula=?";
                $stm = $conexion->prepare($sql);
                $stm->bindParam(1,$usuariodto->getnombre());
                $stm->bindParam(2,$usuariodto->getapellido());
                $stm->bindParam(3,$usuariodto->getclave());
                $stm->bindParam(4,$usuariodto->getcorreo());
                $stm->bindParam(5,$usuariodto->gettelefono());
                $stm->bindParam(6,$usuariodto->getgenero());
                $stm->bindParam(7,$usuariodto->getfecha_nacimiento());
                $stm->bindParam(8,$usuariodto->getestado());
                $stm->bindParam(9,$usuariodto->getcedula());
                $stm->execute();
            }catch(Exception $e){
                $mensaje = "Error en la actualizacion: ". $e->getMessage();
            }
        }
        public function eliminar(usuariodto $usuariodto){
            $conexion = Conexion::getConexion();
            $mensaje = "";
            try{
                $sql = "DELETE FROM usuario WHERE cedula=?";
                $stm = $conexion->prepare($sql);
                $cedula = $usuariodto->getcedula();
                $stm->bindParam(1,$cedula);
                $stm->execute();
            }catch(Exception $e){
                $mensaje = "Error en la eliminacion: ". $e->getMessage();
            }
        }
        
    }
?>