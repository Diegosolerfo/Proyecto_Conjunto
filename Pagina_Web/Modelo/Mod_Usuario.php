<?php
    class usuario{
        private $cedula;
        private $nombre;
        private $apellido;
        private $contrasena;
        private $correo;
        private $tipo_usuario;
        private $estado;
        private $telefono;
        private $genero;
        private $fecha_nacimiento;
        public function __construct(
        $cedula=NULL, 
        $nombre=NULL, 
        $apellido=NULL, 
        $contrasena=NULL, 
        $correo=NULL, 
        $tipo_usuario=NULL, 
        $estado=NULL, 
        $telefono=NULL, 
        $genero=NULL, 
        $fecha_nacimiento=NULL){
            $this->cedula = $cedula;
            $this->nombre = $nombre;
            $this->apellido = $apellido;
            $this->contrasena = $contrasena;
            $this->correo = $correo;
            $this->tipo_usuario = $tipo_usuario;
            $this->estado = $estado;
            $this->telefono = $telefono;
            $this->genero = $genero;
            $this->fecha_nacimiento = $fecha_nacimiento;
        }
        public function inicio_sesion(){
            $conexion = new PDO("mysql:host=localhost;dbname=conjunto", "root");
            $sentencia = $conexion->prepare("call iniciar_sesion(?,?)");
            $sentencia->bindParam(1, $this->cedula);
            $sentencia->bindParam(2, $this->contrasena);
            $sentencia->execute();
            return $sentencia->fetch(PDO::FETCH_ASSOC);
        }
    }
?>