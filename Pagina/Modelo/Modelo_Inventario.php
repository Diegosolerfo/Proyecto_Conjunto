<?php
class Modelo_Inventario {
    private $ID_INV;
    private $ID_ITEM;
    private $UBICACION;
    private $CANTIDAD;
    private $ESPECIFICACIONES;
    private $FECHA_VENCIMIENTO;
    private $ESTADO;

    public function REGISTRAR_INV($ID_INV, $ID_ITEM, $UB, $CAN, $ESP, $FECHA,$EST) {  
        $this->ID_INV = $ID_INV;
        $this->ID_ITEM = $ID_ITEM;
        $this->UBICACION = $UB;
        $this->CANTIDAD = $CAN;
        $this->ESPECIFICACIONES = $ESP;
        $this->FECHA_VENCIMIENTO = $FECHA;
        $this->ESTADO = $EST;

    $conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root");
        $sentencia = $conexion->prepare("call RINVENTARIO(?,?,?,?,?)");
        $sentencia->bindParam(1, $this->ID_ITEM);
        $sentencia->bindParam(2, $this->UBICACION);
        $sentencia->bindParam(3, $this->CANTIDAD);
        $sentencia->bindParam(4, $this->ESPECIFICACIONES);
        $sentencia->bindParam(5, $this->FECHA_VENCIMIENTO); 
        $sentencia->bindParam(6, $this->ESTADO);
        $r = $sentencia->execute();
        return $r;
}
public function General_Inventario(){
        $Conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root");
        $Sentencia = $Conexion->prepare("Call CONSULTA_GENERAL_INVENTARIO");
        $Sentencia->execute();
        $R = $Sentencia->fetchAll(PDO::FETCH_ASSOC);
        return $R;
    }
    public function Consultar_Inactivos(){
        $Conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root");
        $Sentencia = $Conexion->prepare("Call CONSULTA_GENERAL_INVENTARIO_INACTIVO");
        $Sentencia->execute();
        $R = $Sentencia->fetchAll(PDO::FETCH_ASSOC);
        return $R;
    }
    public function Habilitar(){
        $Conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root");
        $Sentencia = $Conexion->prepare("Call HABILITAR_INVENTARIO(?)");
        $Sentencia->bindParam(1, $this->ID_INV);
        $R = $Sentencia->execute();
        return $R;
    }
    public function Especifica_Inventario() {
        $Conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root");
        $Sentencia = $Conexion->prepare("Call CONSULTA_ESPECIFICA_INVENTARIO(?)");
        $Sentencia->bindParam(1, $this->ID_INV);
        $Sentencia->execute();
        $R = $Sentencia->fetchAll();
        return $R;
    }
    public function Actualizar_Inventario(){
        $Conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root");
        $Sentencia = $Conexion->prepare("Call ACTUALIZAR_INVENTARIO(?,?,?,?,?,?)");
        $Sentencia->bindParam(1, $this->ID_INV);
        $Sentencia->bindParam(2, $this->ID_ITEM);
        $Sentencia->bindParam(3, $this->UBICACION);
        $Sentencia->bindParam(4, $this->CANTIDAD);
        $Sentencia->bindParam(5, $this->ESPECIFICACIONES);
        $Sentencia->bindParam(6, $this->FECHA_VENCIMIENTO); 
        $R = $Sentencia->execute();
        return $R;
    }    
    public function Eliminar_Inventario(){
        $Conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root");
        $Sentencia = $Conexion->prepare("call ELIMINAR_INVENTARIO(?)");
        $Sentencia->bindParam(1,$this->ID_INV);
        $R=$Sentencia -> execute();
        return $R;
    }

}
