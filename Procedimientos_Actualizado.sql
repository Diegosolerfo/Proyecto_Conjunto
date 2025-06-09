DELIMITER //
CREATE FUNCTION DeudaConMora(CEDULA INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE TOTAL DECIMAL(10,2);
  
  SELECT SUM(
    SALDO +
    (CASE
      WHEN DATEDIFF(CURDATE(), fecha_limite) > 0
      THEN monto * 0.01 * FLOOR(DATEDIFF(CURDATE(), fecha_limite) / 7)
      ELSE 0
    END)
  )
  INTO TOTAL
  FROM ventas_credito
  WHERE id_cliente = id_cliente AND estado = 'pendiente';
  
  RETURN IFNULL(total, 0);
END;
DELIMITER ;
DELIMITER //
CREATE FUNCTION TotalGastoProveedorUltimoMes(id_proveedor INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE total DECIMAL(10,2);
  
  SELECT IFNULL(SUM(c.monto_total), 0)
  INTO total
  FROM compra c
  WHERE c.id_proveedor = id_proveedor
    AND c.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
    
  RETURN total;
END;
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE InsertarCompraYActualizarInventario (
  IN p_id_proveedor INT,
  IN p_fecha DATE,
  IN p_monto_total DECIMAL(10,2)
)
BEGIN
  DECLARE nueva_compra_id INT;

  -- Insertar la compra
  INSERT INTO compra(id_proveedor, fecha, monto_total)
  VALUES (p_id_proveedor, p_fecha, p_monto_total);

  SET nueva_compra_id = LAST_INSERT_ID();

  -- Aquí se debe insertar los detalles en detalle_compra (se asume que eso lo haces con otro proceso o por fuera)
  -- Luego actualizas inventario según el detalle_compra:

  UPDATE inventario i
  JOIN detalle_compra dc ON dc.id_producto = i.id_producto
  SET i.cantidad_stock = i.cantidad_stock + dc.cantidad
  WHERE dc.id_compra = nueva_compra_id;
END$$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE RegistrarVentaYActualizarInventario (
  IN p_id_cliente INT,
  IN p_fecha DATE,
  IN p_total DECIMAL(10,2)
)
BEGIN
  DECLARE nueva_venta_id INT;

  -- Insertar la venta
  INSERT INTO venta(id_cliente, fecha, total)
  VALUES (p_id_cliente, p_fecha, p_total);

  SET nueva_venta_id = LAST_INSERT_ID();

  -- Se asume que los productos se insertaron en detalle_venta (como paso externo o previo)
  -- Actualizar inventario restando productos vendidos

  UPDATE inventario i
  JOIN detalle_venta dv ON dv.id_producto = i.id_producto
  SET i.cantidad_stock = i.cantidad_stock - dv.cantidad
  WHERE dv.id_venta = nueva_venta_id;
END$$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE RegistrarDeudaCliente (
  IN p_id_cliente INT,
  IN p_fecha DATE,
  IN p_monto DECIMAL(10,2),
  IN p_fecha_limite DATE
)
BEGIN
  DECLARE nueva_venta_id INT;

  -- Insertar venta como crédito
  INSERT INTO venta(id_cliente, fecha, total)
  VALUES (p_id_cliente, p_fecha, p_monto);

  SET nueva_venta_id = LAST_INSERT_ID();

  -- Insertar deuda
  INSERT INTO ventas_credito(id_cliente, id_venta, monto, fecha_limite, estado)
  VALUES (p_id_cliente, nueva_venta_id, p_monto, p_fecha_limite, 'pendiente');

  -- Se asume que los productos ya se agregaron en detalle_venta
  -- Actualizar inventario

  UPDATE inventario i
  JOIN detalle_venta dv ON dv.id_producto = i.id_producto
  SET i.cantidad_stock = i.cantidad_stock - dv.cantidad
  WHERE dv.id_venta = nueva_venta_id;
END$$
DELIMITER ;

























































/* PROCEDIMIENTOS BASE DE DATOS CONJUNTO */
/*--------------------------------------------------------------------------------------------------------------------------- REGISTROS */
-- ------------------------------------------------------------------------------------------------------------------------ Registrar usuario
DELIMITER //
CREATE PROCEDURE REGISTRAR_USUARIO(
    IN P_CEDULA BIGINT UNSIGNED,
    IN P_NOMBRE VARCHAR(25),
    IN P_APELLIDO VARCHAR(25),
    IN P_CONTRASENA VARCHAR(25),
    IN P_CORREO VARCHAR(60),
    IN P_TIPO_USUARIO ENUM('ADMINISTRADOR','CAJERO','CLIENTE'),
    IN P_ESTADO ENUM('ACTIVO','INACTIVO'),
    IN P_TELEFONO INT UNSIGNED,
    IN P_GENERO ENUM('MASCULINO','FEMENINO')
)
BEGIN
    INSERT INTO USUARIO VALUES (
        P_CEDULA, P_NOMBRE, P_APELLIDO, P_CONTRASENA, P_CORREO,
        P_TIPO_USUARIO, P_ESTADO, P_TELEFONO, P_GENERO
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar proveedor
DELIMITER //
CREATE PROCEDURE REGISTRAR_PROVEEDOR(
    IN P_NOMBRE_PROVEEDOR VARCHAR(25),
    IN P_NUMERO_TELEFONICO BIGINT UNSIGNED,
    IN P_CORREO_PROVEEDOR VARCHAR(40),
    IN P_DIRECCION VARCHAR(40),
    IN P_ESTADO ENUM('ACTIVO','INACTIVO')
)
BEGIN
    INSERT INTO PROVEEDOR (
        NOMBRE_PROVEEDOR, NUMERO_TELEFONICO, CORREO_PROVEEDOR, DIRECCION, ESTADO
    ) VALUES (
        P_NOMBRE_PROVEEDOR, P_NUMERO_TELEFONICO, P_CORREO_PROVEEDOR, P_DIRECCION, P_ESTADO
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar inventario
DELIMITER //
CREATE PROCEDURE REGISTRAR_INVENTARIO(
    IN P_NOMBRE_PRODUCTO VARCHAR(30),
    IN P_DESCRIPCION_PRODUCTO VARCHAR(40),
    IN P_CANTIDAD_DISPONIBLE TINYINT UNSIGNED,
    IN P_UNIDAD_MEDIDA ENUM('L','Ml','Gal','M','Cm','Ft','Kg','G','Lb','Mg'),
    IN P_ESTADO_PRODUCTO ENUM('DISPONIBLE','NO DISPONIBLE'),
    IN P_COSTO_UNITARIO SMALLINT UNSIGNED,
    IN P_FECHA_ENTREGA DATE,
    IN P_REGISTRADO_POR BIGINT UNSIGNED
)
BEGIN
    INSERT INTO INVENTARIO (
        NOMBRE_PRODUCTO, DESCRIPCION_PRODUCTO, CANTIDAD_DISPONIBLE,
        UNIDAD_MEDIDA, ESTADO_PRODUCTO, COSTO_UNITARIO,
        FECHA_ENTREGA, REGISTRADO_POR
    ) VALUES (
        P_NOMBRE_PRODUCTO, P_DESCRIPCION_PRODUCTO, P_CANTIDAD_DISPONIBLE,
        P_UNIDAD_MEDIDA, P_ESTADO_PRODUCTO, P_COSTO_UNITARIO,
        P_FECHA_ENTREGA, P_REGISTRADO_POR
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar compra
DELIMITER //
CREATE PROCEDURE REGISTRAR_COMPRA(
    IN P_FECHA_COMPRA DATE,
    IN P_VALOR_COMPRA MEDIUMINT UNSIGNED,
    IN P_CANTIDAD_COMPRA TINYINT UNSIGNED,
    IN P_ESTADO_COMPRA ENUM('REALIZADA','NO REALIZADA'),
    IN P_DESCUENTO INT UNSIGNED,
    IN P_REGISTRADA_POR BIGINT UNSIGNED,
    IN P_SUMINISTRADA_POR INT UNSIGNED
)
BEGIN
    INSERT INTO COMPRA (
        FECHA_COMPRA, VALOR_COMPRA, CANTIDAD_COMPRA,
        ESTADO_COMPRA, DESCUENTO, REGISTRADA_POR, SUMINISTRADA_POR
    ) VALUES (
        P_FECHA_COMPRA, P_VALOR_COMPRA, P_CANTIDAD_COMPRA,
        P_ESTADO_COMPRA, P_DESCUENTO, P_REGISTRADA_POR, P_SUMINISTRADA_POR
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar detalles surte
DELIMITER //
CREATE PROCEDURE REGISTRAR_DETALLES_SURTE(
    IN P_VALOR_PRODUCTO MEDIUMINT,
    IN P_CANTIDAD_PRODUCTO INT,
    IN P_COMPRA TINYINT UNSIGNED,
    IN P_INVENTARIO TINYINT UNSIGNED
)
BEGIN
    INSERT INTO DETALLES_SURTE (
        VALOR_PRODUCTO, CANTIDAD_PRODUCTO, COMPRA, INVENTARIO
    ) VALUES (
        P_VALOR_PRODUCTO, P_CANTIDAD_PRODUCTO, P_COMPRA, P_INVENTARIO
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar detalles suministra
DELIMITER //
CREATE PROCEDURE REGISTRAR_DETALLES_SUMINISTRA(
    IN P_PROVEEDOR INT UNSIGNED,
    IN P_INVENTARIO TINYINT UNSIGNED
)
BEGIN
    INSERT INTO DETALLES_SUMINISTRA (PROVEEDOR, INVENTARIO)
    VALUES (P_PROVEEDOR, P_INVENTARIO);
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar venta
DELIMITER //
CREATE PROCEDURE REGISTRAR_VENTA(
    IN P_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN P_VALOR_UNITARIO_PRODUCTO SMALLINT UNSIGNED,
    IN P_VALOR_TOTAL INT UNSIGNED,
    IN P_ESTADO_VENTA ENUM('REALIZADA','PENDIENTE'),
    IN P_VENTA_REALIZADA_POR BIGINT UNSIGNED
)
BEGIN
    INSERT INTO VENTA (
        CANTIDAD_PRODUCTO, VALOR_UNITARIO_PRODUCTO, VALOR_TOTAL,
        ESTADO_VENTA, VENTA_REALIZADA_POR
    ) VALUES (
        P_CANTIDAD_PRODUCTO, P_VALOR_UNITARIO_PRODUCTO, P_VALOR_TOTAL,
        P_ESTADO_VENTA, P_VENTA_REALIZADA_POR
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar detalles abastece
DELIMITER //
CREATE PROCEDURE REGISTRAR_DETALLES_ABASTECE(
    IN P_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN P_FECHA_ENTRADA DATE,
    IN P_VALOR_PRODUCTO MEDIUMINT UNSIGNED,
    IN P_INVENTARIO TINYINT UNSIGNED,
    IN P_VENTA TINYINT UNSIGNED
)
BEGIN
    INSERT INTO DETALLES_ABASTECE (
        CANTIDAD_PRODUCTO, FECHA_ENTRADA, VALOR_PRODUCTO,
        INVENTARIO, VENTA
    ) VALUES (
        P_CANTIDAD_PRODUCTO, P_FECHA_ENTRADA, P_VALOR_PRODUCTO,
        P_INVENTARIO, P_VENTA
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar evento
DELIMITER //
CREATE PROCEDURE REGISTRAR_EVENTO(
    IN P_NOMBRE_EVENTO VARCHAR(100),
    IN P_DESCRIPCION_EVENTO VARCHAR(100),
    IN P_TIPO_EVENTO VARCHAR(30),
    IN P_FECHA_EVENTO DATE,
    IN P_HORA_INICIO TIME,
    IN P_HORA_FIN TIME,
    IN P_LUGAR VARCHAR(30),
    IN P_OBSERVACIONES VARCHAR(50)
)
BEGIN
    INSERT INTO EVENTO (
        NOMBRE_EVENTO, DESCRIPCION_EVENTO, TIPO_EVENTO, FECHA_EVENTO,
        HORA_INICIO, HORA_FIN, LUGAR, OBSERVACIONES
    ) VALUES (
        P_NOMBRE_EVENTO, P_DESCRIPCION_EVENTO, P_TIPO_EVENTO, P_FECHA_EVENTO,
        P_HORA_INICIO, P_HORA_FIN, P_LUGAR, P_OBSERVACIONES
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar detalle surte evento
DELIMITER //
CREATE PROCEDURE REGISTRAR_DETALLE_SURTE_EVENTO(
    IN P_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN P_VALOR_PRODUCTO MEDIUMINT UNSIGNED,
    IN P_INVENTARIO TINYINT UNSIGNED,
    IN P_EVENTO TINYINT UNSIGNED
)
BEGIN
    INSERT INTO DETALLE_SURTE_EVENTO (
        CANTIDAD_PRODUCTO, VALOR_PRODUCTO, INVENTARIO, EVENTO
    ) VALUES (
        P_CANTIDAD_PRODUCTO, P_VALOR_PRODUCTO, P_INVENTARIO, P_EVENTO
    );
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Registrar ventas credito
DELIMITER //
CREATE PROCEDURE REGISTRAR_VENTAS_CREDITO(
    IN P_SALDO INT UNSIGNED,
    IN P_NUMERO_CUOTAS TINYINT UNSIGNED,
    IN P_FECHA_PAGO_CUOTA DATE,
    IN P_FECHA_FIADO DATE,
    IN P_DEUDA_DE BIGINT UNSIGNED,
    IN P_DE_QUE_VENTA_ES TINYINT UNSIGNED,
    IN P_FECHA_VENCIMIENTO DATE
)
BEGIN
    INSERT INTO VENTAS_CREDITO (
        SALDO, NUMERO_CUOTAS, FECHA_PAGO_CUOTA, FECHA_FIADO,
        DEUDA_DE, DE_QUE_VENTA_ES, FECHA_VENCIMIENTO
    ) VALUES (
        P_SALDO, P_NUMERO_CUOTAS, P_FECHA_PAGO_CUOTA, P_FECHA_FIADO,
        P_DEUDA_DE, P_DE_QUE_VENTA_ES, P_FECHA_VENCIMIENTO
    );
END //
DELIMITER ;
/* -------------------------------------------------------------------------------------------------------------------------- ELIMINACIÓN DE REGISTROS */
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar USUARIO 
DELIMITER //
CREATE PROCEDURE ELIMINAR_USUARIO(
    IN P_CEDULA BIGINT UNSIGNED
)
BEGIN
    DELETE FROM USUARIO
    WHERE CEDULA = P_CEDULA;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar PROVEEDOR
DELIMITER //
CREATE PROCEDURE ELIMINAR_PROVEEDOR(
    IN P_ID_PROVEEDOR INT UNSIGNED
)
BEGIN
    DELETE FROM PROVEEDOR
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar INVENTARIO
DELIMITER //
CREATE PROCEDURE ELIMINAR_INVENTARIO(
    IN P_ID_INVENTARIO TINYINT UNSIGNED
)
BEGIN
    DELETE FROM INVENTARIO
    WHERE ID_INVENTARIO = P_ID_INVENTARIO;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar COMPRA
DELIMITER //
CREATE PROCEDURE ELIMINAR_COMPRA(
    IN P_ID_COMPRA TINYINT UNSIGNED
)
BEGIN
    DELETE FROM COMPRA
    WHERE ID_COMPRA = P_ID_COMPRA;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar Detalles surte
DELIMITER //
CREATE PROCEDURE ELIMINAR_DETALLES_SURTE(
    IN P_ID_DETALLE_SURTE INT UNSIGNED -- Reemplaza con el nombre de tu PK si es diferente
)
BEGIN
    DELETE FROM DETALLES_SURTE
    WHERE ID_DETALLE_SURTE = P_ID_DETALLE_SURTE;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar DETALLES_SUMINISTR
DELIMITER //
CREATE PROCEDURE ELIMINAR_DETALLES_SUMINISTRA(
    IN P_ID_DETALLE_SUMINISTRA INT UNSIGNED -- Reemplaza con el nombre de tu PK si es diferente
)
BEGIN
    DELETE FROM DETALLES_SUMINISTRA
    WHERE ID_DETALLE_SUMINISTRA = P_ID_DETALLE_SUMINISTRA;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar VENTA
DELIMITER //
CREATE PROCEDURE ELIMINAR_VENTA(
    IN P_ID_VENTA TINYINT UNSIGNED
)
BEGIN
    DELETE FROM VENTA
    WHERE ID_VENTA = P_ID_VENTA;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar DETALLES_ABASTECE
DELIMITER //
CREATE PROCEDURE ELIMINAR_DETALLES_ABASTECE(
    IN P_ID_DETALLE_ABASTECE INT UNSIGNED -- Reemplaza con el nombre de tu PK si es diferente
)
BEGIN
    DELETE FROM DETALLES_ABASTECE
    WHERE ID_DETALLE_ABASTECE = P_ID_DETALLE_ABASTECE;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar EVENTO
DELIMITER //
CREATE PROCEDURE ELIMINAR_EVENTO(
    IN P_ID_EVENTO TINYINT UNSIGNED
)
BEGIN
    DELETE FROM EVENTO
    WHERE ID_EVENTO = P_ID_EVENTO;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar DETALLE_SURTE_EVENTO
DELIMITER //
CREATE PROCEDURE ELIMINAR_DETALLE_SURTE_EVENTO(
    IN P_ID_DETALLE_SURTE_EVENTO INT UNSIGNED -- Reemplaza con el nombre de tu PK si es diferente
)
BEGIN
    DELETE FROM DETALLE_SURTE_EVENTO
    WHERE ID_DETALLE_SURTE_EVENTO = P_ID_DETALLE_SURTE_EVENTO;
END //
DELIMITER ;
-- ------------------------------------------------------------------------------------------------------------------------ Eliminar VENTAS_CREDITO
DELIMITER //
CREATE PROCEDURE ELIMINAR_VENTAS_CREDITO(
    IN P_ID_VENTA_CREDITO TINYINT UNSIGNED
)
BEGIN
    DELETE FROM VENTAS_CREDITO
    WHERE ID_VENTA_CREDITO = P_ID_VENTA_CREDITO;
END //
DELIMITER ;

USE CONJUNTO;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR USUARIO
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarUsuario (
    IN p_CEDULA BIGINT UNSIGNED,
    IN p_NOMBRE VARCHAR(25),
    IN p_APELLIDO VARCHAR(25),
    IN p_CONTRASENA VARCHAR(25),
    IN p_CORREO VARCHAR(60),
    IN p_TIPO_USUARIO ENUM('ADMINISTRADOR','CAJERO','CLIENTE'),
    IN p_ESTADO ENUM('ACTIVO','INACTIVO'),
    IN p_TELEFONO INT UNSIGNED,
    IN p_GENERO ENUM('MASCULINO','FEMENINO')
)
BEGIN
    UPDATE USUARIO
    SET
        NOMBRE = p_NOMBRE,
        APELLIDO = p_APELLIDO,
        CONTRASENA = p_CONTRASENA,
        CORREO = p_CORREO,
        TIPO_USUARIO = p_TIPO_USUARIO,
        ESTADO = p_ESTADO,
        TELEFONO = p_TELEFONO,
        GENERO = p_GENERO
    WHERE CEDULA = p_CEDULA;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR PROVEEDOR
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarProveedor (
    IN p_ID_PROVEEDOR INT UNSIGNED,
    IN p_NOMBRE_PROVEEDOR VARCHAR(25),
    IN p_NUMERO_TELEFONICO BIGINT UNSIGNED,
    IN p_CORREO_PROVEEDOR VARCHAR(40),
    IN p_DIRECCION VARCHAR(40),
    IN p_ESTADO ENUM('ACTIVO','INACTIVO')
)
BEGIN
    UPDATE PROVEEDOR
    SET
        NOMBRE_PROVEEDOR = p_NOMBRE_PROVEEDOR,
        NUMERO_TELEFONICO = p_NUMERO_TELEFONICO,
        CORREO_PROVEEDOR = p_CORREO_PROVEEDOR,
        DIRECCION = p_DIRECCION,
        ESTADO = p_ESTADO
    WHERE ID_PROVEEDOR = p_ID_PROVEEDOR;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR INVENTARIO
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarInventario (
    IN p_ID_INVENTARIO TINYINT UNSIGNED,
    IN p_NOMBRE_PRODUCTO VARCHAR(30),
    IN p_DESCRIPCION_PRODUCTO VARCHAR(40),
    IN p_CANTIDAD_DISPONIBLE TINYINT UNSIGNED,
    IN p_UNIDAD_MEDIDA ENUM('L','Ml','Gal','M','Cm','Ft','Kg','G','Lb','Mg'),
    IN p_ESTADO_PRODUCTO ENUM('DISPONIBLE','NO DISPONIBLE'),
    IN p_COSTO_UNITARIO SMALLINT UNSIGNED,
    IN p_FECHA_ENTREGA DATE,
    IN p_REGISTRADO_POR BIGINT UNSIGNED
)
BEGIN
    UPDATE INVENTARIO
    SET
        NOMBRE_PRODUCTO = p_NOMBRE_PRODUCTO,
        DESCRIPCION_PRODUCTO = p_DESCRIPCION_PRODUCTO,
        CANTIDAD_DISPONIBLE = p_CANTIDAD_DISPONIBLE,
        UNIDAD_MEDIDA = p_UNIDAD_MEDIDA,
        ESTADO_PRODUCTO = p_ESTADO_PRODUCTO,
        COSTO_UNITARIO = p_COSTO_UNITARIO,
        FECHA_ENTREGA = p_FECHA_ENTREGA,
        REGISTRADO_POR = p_REGISTRADO_POR
    WHERE ID_INVENTARIO = p_ID_INVENTARIO;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR COMPRA
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarCompra (
    IN p_ID_COMPRA TINYINT UNSIGNED,
    IN p_FECHA_COMPRA DATE,
    IN p_VALOR_COMPRA MEDIUMINT UNSIGNED,
    IN p_CANTIDAD_COMPRA TINYINT UNSIGNED,
    IN p_ESTADO_COMPRA ENUM('REALIZADA','NO REALIZADA'),
    IN p_DESCUENTO INT UNSIGNED,
    IN p_REGISTRADA_POR BIGINT UNSIGNED,
    IN p_SUMINISTRADA_POR INT UNSIGNED
)
BEGIN
    UPDATE COMPRA
    SET
        FECHA_COMPRA = p_FECHA_COMPRA,
        VALOR_COMPRA = p_VALOR_COMPRA,
        CANTIDAD_COMPRA = p_CANTIDAD_COMPRA,
        ESTADO_COMPRA = p_ESTADO_COMPRA,
        DESCUENTO = p_DESCUENTO,
        REGISTRADA_POR = p_REGISTRADA_POR,
        SUMINISTRADA_POR = p_SUMINISTRADA_POR
    WHERE ID_COMPRA = p_ID_COMPRA;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR DETALLES_SURTE
-- NOTA: Esta tabla tiene una clave primaria compuesta implícita (COMPRA, INVENTARIO).
-- Para actualizar un registro específico, se necesitan ambas claves.
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarDetallesSurte (
    IN p_COMPRA TINYINT UNSIGNED,
    IN p_INVENTARIO TINYINT UNSIGNED,
    IN p_NUEVO_VALOR_PRODUCTO MEDIUMINT,
    IN p_NUEVA_CANTIDAD_PRODUCTO INT
)
BEGIN
    UPDATE DETALLES_SURTE
    SET
        VALOR_PRODUCTO = p_NUEVO_VALOR_PRODUCTO,
        CANTIDAD_PRODUCTO = p_NUEVA_CANTIDAD_PRODUCTO
    WHERE COMPRA = p_COMPRA AND INVENTARIO = p_INVENTARIO;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR DETALLES_SUMINISTRA
-- NOTA: Esta tabla tiene una clave primaria compuesta implícita (PROVEEDOR, INVENTARIO).
-- Para actualizar un registro específico, se necesitan ambas claves.
-- Si solo se quiere actualizar un vínculo, se borraría y se volvería a insertar.
-- Este SP asume que se quiere cambiar uno de los ID de la relación o ambos.
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarDetallesSuministra (
    IN p_OLD_PROVEEDOR INT UNSIGNED,
    IN p_OLD_INVENTARIO TINYINT UNSIGNED,
    IN p_NEW_PROVEEDOR INT UNSIGNED,
    IN p_NEW_INVENTARIO TINYINT UNSIGNED
)
BEGIN
    UPDATE DETALLES_SUMINISTRA
    SET
        PROVEEDOR = p_NEW_PROVEEDOR,
        INVENTARIO = p_NEW_INVENTARIO
    WHERE PROVEEDOR = p_OLD_PROVEEDOR AND INVENTARIO = p_OLD_INVENTARIO;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR VENTA
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarVenta (
    IN p_ID_VENTA TINYINT UNSIGNED,
    IN p_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN p_VALOR_UNITARIO_PRODUCTO SMALLINT UNSIGNED,
    IN p_VALOR_TOTAL INT UNSIGNED,
    IN p_ESTADO_VENTA ENUM('REALIZADA','PENDIENTE'),
    IN p_VENTA_REALIZADA_POR BIGINT UNSIGNED
)
BEGIN
    UPDATE VENTA
    SET
        CANTIDAD_PRODUCTO = p_CANTIDAD_PRODUCTO,
        VALOR_UNITARIO_PRODUCTO = p_VALOR_UNITARIO_PRODUCTO,
        VALOR_TOTAL = p_VALOR_TOTAL,
        ESTADO_VENTA = p_ESTADO_VENTA,
        VENTA_REALIZADA_POR = p_VENTA_REALIZADA_POR
    WHERE ID_VENTA = p_ID_VENTA;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR DETALLES_ABASTECE
-- NOTA: Esta tabla tiene una clave primaria compuesta implícita (INVENTARIO, VENTA).
-- Para actualizar un registro específico, se necesitan ambas claves.
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarDetallesAbastece (
    IN p_INVENTARIO TINYINT UNSIGNED,
    IN p_VENTA TINYINT UNSIGNED,
    IN p_NUEVA_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN p_NUEVA_FECHA_ENTRADA DATE,
    IN p_NUEVO_VALOR_PRODUCTO MEDIUMINT UNSIGNED
)
BEGIN
    UPDATE DETALLES_ABASTECE
    SET
        CANTIDAD_PRODUCTO = p_NUEVA_CANTIDAD_PRODUCTO,
        FECHA_ENTRADA = p_NUEVA_FECHA_ENTRADA,
        VALOR_PRODUCTO = p_NUEVO_VALOR_PRODUCTO
    WHERE INVENTARIO = p_INVENTARIO AND VENTA = p_VENTA;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR EVENTO
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarEvento (
    IN p_ID_EVENTO TINYINT UNSIGNED,
    IN p_NOMBRE_EVENTO VARCHAR(100),
    IN p_DESCRIPCION_EVENTO VARCHAR(100),
    IN p_TIPO_EVENTO VARCHAR(30),
    IN p_FECHA_EVENTO DATE,
    IN p_HORA_INICIO TIME,
    IN p_HORA_FIN TIME,
    IN p_LUGAR VARCHAR(30),
    IN p_OBSERVACIONES VARCHAR(50)
)
BEGIN
    UPDATE EVENTO
    SET
        NOMBRE_EVENTO = p_NOMBRE_EVENTO,
        DESCRIPCION_EVENTO = p_DESCRIPCION_EVENTO,
        TIPO_EVENTO = p_TIPO_EVENTO,
        FECHA_EVENTO = p_FECHA_EVENTO,
        HORA_INICIO = p_HORA_INICIO,
        HORA_FIN = p_HORA_FIN,
        LUGAR = p_LUGAR,
        OBSERVACIONES = p_OBSERVACIONES
    WHERE ID_EVENTO = p_ID_EVENTO;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR DETALLE_SURTE_EVENTO
-- NOTA: Esta tabla tiene una clave primaria compuesta implícita (INVENTARIO, EVENTO).
-- Para actualizar un registro específico, se necesitan ambas claves.
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarDetalleSurteEvento (
    IN p_INVENTARIO TINYINT UNSIGNED,
    IN p_EVENTO TINYINT UNSIGNED,
    IN p_NUEVA_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN p_NUEVO_VALOR_PRODUCTO MEDIUMINT UNSIGNED
)
BEGIN
    UPDATE DETALLE_SURTE_EVENTO
    SET
        CANTIDAD_PRODUCTO = p_NUEVA_CANTIDAD_PRODUCTO,
        VALOR_PRODUCTO = p_NUEVO_VALOR_PRODUCTO
    WHERE INVENTARIO = p_INVENTARIO AND EVENTO = p_EVENTO;
END //
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO PARA ACTUALIZAR VENTAS_CREDITO
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE SP_ActualizarVentasCredito (
    IN p_ID_FIADO TINYINT UNSIGNED,
    IN p_SALDO INT UNSIGNED,
    IN p_NUMERO_CUOTAS TINYINT UNSIGNED,
    IN p_FECHA_PAGO_CUOTA DATE,
    IN p_FECHA_FIADO DATE,
    IN p_DEUDA_DE BIGINT UNSIGNED,
    IN p_DE_QUE_VENTA_ES TINYINT UNSIGNED,
    IN p_FECHA_VENCIMIENTO DATE
)
BEGIN
    UPDATE VENTAS_CREDITO
    SET
        SALDO = p_SALDO,
        NUMERO_CUOTAS = p_NUMERO_CUOTAS,
        FECHA_PAGO_CUOTA = p_FECHA_PAGO_CUOTA,
        FECHA_FIADO = p_FECHA_FIADO,
        DEUDA_DE = p_DEUDA_DE,
        DE_QUE_VENTA_ES = p_DE_QUE_VENTA_ES,
        FECHA_VENCIMIENTO = p_FECHA_VENCIMIENTO
    WHERE ID_FIADO = p_ID_FIADO;
END //
DELIMITER ;