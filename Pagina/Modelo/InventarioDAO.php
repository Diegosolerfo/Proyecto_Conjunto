<?php
    class InventarioDAO {
    public function registrar_inventario(InventarioDTO $inventarioDTO) {
        $conexion = Conexion::getConexion();
        $sql = "INSERT INTO INVENTARIO (ID_ITEM, UBICACION, CANTIDAD, ESPECIFICACIONES, FECHA_VENCIMIENTO, ESTADO)
                VALUES (?, ?, ?, ?, ?, ?);";
        try {
            $stmt = $conexion->prepare($sql);
            $stmt->bindParam(1, $inventarioDTO->getID_ITEM());
            $stmt->bindParam(2, $inventarioDTO->getUBICACION());
            $stmt->bindParam(3, $inventarioDTO->getCANTIDAD());
            $stmt->bindParam(4, $inventarioDTO->getESPECIFICACIONES());
            $stmt->bindParam(5, $inventarioDTO->getFECHA_VENCIMIENTO());
            $stmt->bindParam(6, $inventarioDTO->getESTADO());
            return $stmt->execute();
        } catch (PDOException $e) {
            return "Error al registrar inventario: " . $e->getMessage();
        }
    }

    public function panel_inventario() {
        $conexion = Conexion::getConexion();
        try {
            $sql = "CALL PANEL_INVENTARIO();";
            $stm = $conexion->prepare($sql);
            $stm->execute();
            return $stm->fetch();
        } catch (Exception $e) {
            return "Error en la consulta: " . $e->getMessage();
        }
    }

    public function ver_inventario() {
        $conexion = Conexion::getConexion();
        try {
            $sql = "SELECT ID_ITEM, UBICACION, CANTIDAD, ESPECIFICACIONES, FECHA_VENCIMIENTO, ESTADO FROM INVENTARIO;";
            $stm = $conexion->prepare($sql);
            $stm->execute();
            return $stm->fetchAll();
        } catch (Exception $e) {
            return "Error en la consulta: " . $e->getMessage();
        }
    }

    public function ver_inventario_inactivo() {
        $conexion = Conexion::getConexion();
        try {
            $sql = "SELECT ID_ITEM, UBICACION, CANTIDAD, ESPECIFICACIONES, FECHA_VENCIMIENTO, ESTADO FROM INVENTARIO WHERE ESTADO = 'NO DISPONIBLE';";
            $stm = $conexion->prepare($sql);
            $stm->execute();
            return $stm->fetchAll();
        } catch (Exception $e) {
            return "Error en la consulta: " . $e->getMessage();
        }
    }

    public function conid($id_inve) {
        $conexion = Conexion::getConexion();
        try {
            $sql = "SELECT * FROM INVENTARIO WHERE ID_ITEM = ?";
            $stm = $conexion->prepare($sql);
            $stm->bindParam(1, $id_item);
            $stm->execute();
            return $stm->fetch();
        } catch (Exception $e) {
            return "Error en la consulta: " . $e->getMessage();
        }
    }

    public function modificar(InventarioDTO $inventarioDTO) {
        $conexion = Conexion::getConexion();
        try {
            $sql = "UPDATE INVENTARIO SET ID_ITEM=?, UBICACION=?, CANTIDAD=?, ESPECIFICACIONES=?, FECHA_VENCIMIENTO=?, ESTADO=? WHERE ID_ITEM=?";
            $stm = $conexion->prepare($sql);
            $id_item = $inventarioDTO->getID_ITEM();
            $Ubicacion = $inventarioDTO->getUBICACION();
            $Cantidad = $inventarioDTO->getCANTIDAD();
            $Especificaciones = $inventarioDTO->getESPECIFICACIONES();
            $Fecha_Vencimiento = $inventarioDTO->getFECHA_VENCIMIENTO();
            $Estado = $inventarioDTO->getESTADO();
            $stm->bindParam(1, $id_item);
            $stm->bindParam(2, $Ubicacion);
            $stm->bindParam(3, $Cantidad);
            $stm->bindParam(4, $Especificaciones);
            $stm->bindParam(5, $Fecha_Vencimiento);
            $stm->bindParam(6, $Estado);
            $stm->bindParam(7, $id_item);
            $stm->execute();
        } catch (Exception $e) {
            return "Error en la actualización: " . $e->getMessage();
        }
    }

    public function eliminar(InventarioDTO $inventarioDTO) {
        $conexion = Conexion::getConexion();
        try {
            $sql = "UPDATE INVENTARIO SET ESTADO='NO DISPONIBLE' WHERE ID_ITEM=?";
            $stm = $conexion->prepare($sql);
            $stm->bindParam(1, $inventarioDTO->getID_ITEM());
            $stm->execute();
        } catch (Exception $e) {
            return "Error en la eliminación: " . $e->getMessage();
        }
    }
}
