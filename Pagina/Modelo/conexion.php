<?php
    class conexion{
        public static function getConexion(){
            $conexion = NULL;
            try{
                $conexion = new PDO("mysql:host=localhost;dbname=CONJUNTO", "root", "");
                $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            }catch(PDOException $e){
                echo "Error de conexion: " . $e->getMessage();
            }
            return $conexion;
        }
    }
