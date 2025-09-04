<?php
    require_once '../Modelo/conexion.php';    
    require_once "../Modelo/InventarioDTO.php";
    require_once "../Modelo/InventarioDAO.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $accion = $_POST['accion'];

    if ($accion == 'crear_inventario') {
    
    $inventarioDTO = new InventarioDTO();
    $inventarioDTO->setID_ITEM($_POST['id_item']);
    $inventarioDTO->setUBICACION($_POST['ubicacion']);
    $inventarioDTO->setCANTIDAD($_POST['cantidad']);
    $inventarioDTO->setESPECIFICACIONES($_POST['especificaciones']);
    $inventarioDTO->setFECHA_VENCIMIENTO($_POST['fecha_vencimiento']);
    $inventarioDTO->setESTADO($_POST['estado']);

    $inventarioDAO = new InventarioDAO();
    $resultado = $inventarioDAO->registrar_inventario($inventarioDTO);

        if ($resultado) {
            header('Location: ../Vista/Admin/adminis.php');
            exit();
        } else {
            echo "<script>alert('Error al crear el inventario, reintente'); window.location.href = '../Vista/Admin/adminis.php';</script>";
        }
    }elseif ($accion == 'consultar_inventario') {
        $inventarioDAO = new InventarioDAO();
        $inventario = $inventarioDAO->ver_inventario();

        header('Location: ../Vista/Admin/adminis.php');
        exit();
    } 
    elseif ($accion == 'actualizar') {
    $inventarioDTO = new InventarioDTO();
    $inventarioDTO->setID_ITEM($_POST['id_item']);
    $inventarioDTO->setUBICACION($_POST['ubicacion']);
    $inventarioDTO->setCANTIDAD($_POST['cantidad']);
    $inventarioDTO->setESPECIFICACIONES($_POST['especificaciones']);
    $inventarioDTO->setFECHA_VENCIMIENTO($_POST['fecha_vencimiento']);
    $inventarioDTO->setESTADO($_POST['estado']);

    $inventarioDAO = new InventarioDAO();
    $inventarioDAO->modificar($inventarioDTO);

    header('Location: ../Vista/Admin/adminis.php');
    exit();
} elseif ($accion == 'eliminar') {
    $inventarioDTO = new InventarioDTO();
    $inventarioDTO->setID_INV($_POST['id_inve']); // <--- CORRECTO

    $inventarioDAO = new InventarioDAO();
    $inventarioDAO->eliminar($inventarioDTO);

    header('Location: ../Vista/Admin/adminis.php');
    exit();
}
}
