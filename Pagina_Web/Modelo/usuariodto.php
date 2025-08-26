<?php
    class usuariodto{
        private $cedula;
        private $nombre;
        private $apellido;
        private $clave;
        private $correo;
        private $telefono;
        private $genero;
        private $fecha_nacimiento;
        private $tipo_usuario;
        private $estado;

        public function getcedula(){
            return $this->cedula;
        }
        public function setcedula($cedula){
            $this->cedula = $cedula;
        }
        public function getnombre(){
            return $this->nombre;
        }
        public function setnombre($nombre){
            $this->nombre = $nombre;
        }
        public function getapellido(){
            return $this->apellido;
        }
        public function setapellido($apellido){
            $this->apellido = $apellido;
        }
        public function getclave(){
            return $this->clave;
        }
        public function setclave($clave){
            $this->clave = $clave;
        }
        public function getcorreo(){
            return $this->correo;
        }
        public function setcorreo($correo){
            $this->correo = $correo;
        }
        public function gettelefono(){
            return $this->telefono;
        }
        public function settelefono($telefono){
            $this->telefono = $telefono;
        }
        public function getgenero(){
            return $this->genero;
        }
        public function setgenero($genero){
            $this->genero = $genero;
        }
        public function getfecha_nacimiento(){
            return $this->fecha_nacimiento;
        }
        public function setfecha_nacimiento($fecha_nacimiento){
            $this->fecha_nacimiento = $fecha_nacimiento;
        }
        public function gettipo_usuario(){
            return $this->tipo_usuario;
        }
        public function settipo_usuario($tipo_usuario){
            $this->tipo_usuario = $tipo_usuario;
        }
        public function getestado(){
            return $this->estado;
        }
        public function setestado($estado){
            $this->estado = $estado;
        }
    }
?>