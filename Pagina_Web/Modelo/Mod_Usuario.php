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
        public function panel_admin(){
            $conexion = new PDO("mysql:host=localhost;dbname=conjunto", "root");
            $sentencia = $conexion->prepare("call PANEL_ADMIN()");
            $sentencia->execute();
            return $sentencia->fetch(PDO::FETCH_ASSOC);
        }#------------------------------------------------------------------ CLIENTES
        public function crear_cliente(){
            $conexion = new PDO("mysql:host=localhost;dbname=conjunto", "root");
            $sentencia = $conexion->prepare("call crear_cliente(?,?,?,?,?,?,?,?,?)");
            $sentencia->bindParam(1, $this->cedula);
            $sentencia->bindParam(2, $this->nombre);
            $sentencia->bindParam(3, $this->apellido);
            $sentencia->bindParam(4, $this->contrasena);
            $sentencia->bindParam(5, $this->correo);
            $sentencia->bindParam(6, $this->tipo_usuario);
            $sentencia->bindParam(7, $this->telefono);
            $sentencia->bindParam(8, $this->genero);
            $sentencia->bindParam(9, $this->fecha_nacimiento);
            return $sentencia->execute();
        }
        public function ver_clientes(){
            $conexion = new PDO("mysql:host=localhost;dbname=conjunto", "root");
            $sentencia = $conexion->prepare("call ver_clientes()");
            $sentencia->execute();
            return $sentencia->fetchAll(PDO::FETCH_ASSOC);
        }
        public function actualizar_cliente(){
            $conexion = new PDO("mysql:host=localhost;dbname=conjunto", "root");
            $sentencia = $conexion->prepare("call actualizar_cliente(?,?,?,?,?,?,?,?)");
            $sentencia->bindParam(1, $this->cedula);
            $sentencia->bindParam(2, $this->nombre);
            $sentencia->bindParam(3, $this->apellido);
            $sentencia->bindParam(4, $this->correo);
            $sentencia->bindParam(5, $this->telefono);
            $sentencia->bindParam(6, $this->genero);
            $sentencia->bindParam(7, $this->fecha_nacimiento);
            $sentencia->bindParam(8, $this->estado);
            return $sentencia->execute();
        }
    }
?>