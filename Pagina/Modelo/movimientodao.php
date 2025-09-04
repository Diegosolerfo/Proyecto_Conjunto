<?php
    require_once 'conexion.php';
    require_once 'movimientodto.php';    

    class movimientodao{
        public function crear_usuario(movimientodto $movimientodto){
            $conexion = Conexion::getConexion();
            $sql = "INSERT INTO USUARIO (VALOR_MOVIMIENTO, FECHA_MOVIMIENTO, OBSERVACIONES, DESCUENTO, TIPO_MOVIMIENTO, ESTADO_MOVIMIENTO, CLIENTE)
                    VALUES (?,?,?,?,?,?,?);";
            $id_movimiento = $movimientodto->getid();
            $fecha_movimiento = $movimientodto->getfecha_movimiento();
            $observaciones = $movimientodto->getobervaciones();
            $valor_movimiento = $movimientodto->getvalor_movimiento();
            $descuento = $movimientodto->getdescuento();
            $tipo_movimiento = $movimientodto->gettipo_movimiento();
            $estado_movimiento = $movimientodto->getestado_movimiento();
            $cliente = $movimientodto->getcliente();
            try{
                $stmt = $conexion->prepare($sql);
                $stmt->bindParam(1,$fecha_movimiento);
                $stmt->bindParam(2,$observaciones);
                $stmt->bindParam(3,$valor_movimiento);
                $stmt->bindParam(4,$descuento);
                $stmt->bindParam(5,$tipo_movimiento);
                $stmt->bindParam(6,$estado_movimiento);
                $stmt->bindParam(7,$cliente);
                return $stmt->execute();
                $mensaje = "Movimiento registrada correctamente";
            }catch(PDOException $e){
                $mensaje = "Error al registrar movimiento: " . $e->getMessage();
            }
            return $mensaje;
        }
        public function ver_movimientos(){
            $conexion = Conexion::getConexion();
            try{
                $sql = "SELECT * FROM MOVIMIENTO;";
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
