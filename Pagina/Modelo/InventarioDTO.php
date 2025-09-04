<?php
 class InventarioDTO{
    private $ID_ITEM;
    private $UBICACION;
    private $CANTIDAD;
    private $ESPECIFICACIONES;
    private $FECHA_VENCIMIENTO;
    private $ESTADO;

    public function getID_ITEM(){
        return $this->ID_ITEM;
    }
    public function setID_ITEM($ID_ITEM){
        $this->ID_ITEM = $ID_ITEM;
    }
    public function getUBICACION(){
        return $this->UBICACION;
    }
    public function setUBICACION($UBICACION){
        $this->UBICACION = $UBICACION;
    }
    public function getCANTIDAD(){
        return $this->CANTIDAD;
    }
    public function setCANTIDAD($CANTIDAD){
        $this->CANTIDAD = $CANTIDAD;
    }
    public function getESPECIFICACIONES(){
        return $this->ESPECIFICACIONES;
    }
    public function setESPECIFICACIONES($ESPECIFICACIONES){
        $this->ESPECIFICACIONES = $ESPECIFICACIONES;
    }
    public function getFECHA_VENCIMIENTO(){
        return $this->FECHA_VENCIMIENTO;
    }
    public function setFECHA_VENCIMIENTO($FECHA_VENCIMIENTO){
        $this->FECHA_VENCIMIENTO = $FECHA_VENCIMIENTO;
    }
    public function getESTADO(){
        return $this->ESTADO;
    }
    public function setESTADO($ESTADO){
        $this->ESTADO = $ESTADO;
    }
}
