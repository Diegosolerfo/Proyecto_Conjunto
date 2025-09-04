<?php
    class movimientodto{
        private $id_movimiento;
        private $fecha_movimiento;
        private $observaciones;
        private $valor_movimiento;
        private $descuento;
        private $tipo_movimiento;
        private $estado_movimiento;
        private $cliente;

        public function getid_movimiento(){
            return $this->id_movimiento;
        }
        public function setid_movimiento($id_movimiento){
            $this->id_movimiento = $id_movimiento;
        }
        public function getfecha_movimiento(){
            return $this->fecha_movimiento;
        }
        public function setfecha_movimiento($fecha_movimiento){
            $this->fecha_movimiento = $fecha_movimiento;
        }
        public function getobservaciones(){
            return $this->observaciones;
        }
        public function setobservaciones($observaciones){
            $this->observaciones = $observaciones;
        }
        public function getvalor_movimiento(){
            return $this->valor_movimiento;
        }
        public function setvalor_movimiento($valor_movimiento){
            $this->valor_movimiento = $valor_movimiento;
        }
        public function getdescuento(){
            return $this->descuento;
        }
        public function setdescuento($descuento){
            $this->descuento = $descuento;
        }
        public function gettipo_movimiento(){
            return $this->tipo_movimiento;
        }
        public function settipo_movimiento($tipo_movimiento){
            $this->tipo_movimiento = $tipo_movimiento;
        }
        public function getestado_movimiento(){
            return $this->estado_movimiento;
        }
        public function setestado_movimiento($estado_movimiento){
            $this->estado_movimiento = $estado_movimiento;
        }
        public function getcliente(){
            return $this->cliente;
        }
        public function setcliente($cliente){
            $this->cliente = $cliente;
        }
    }
