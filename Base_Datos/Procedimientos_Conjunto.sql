USE CONJUNTO;

/*Procedimiento que registra las compras que se les hacen a los proveedores, donde se agrega cuando se compro y por caunto se compro al sistema
*/
CALL RegistrarCompraProveedor(10,1200,'2025-06-09',1000,1023488512,2,4);
#DROP PROCEDURE RegistrarCompraProveedor;
DELIMITER $$
CREATE PROCEDURE RegistrarCompraProveedor(
    IN p_CANTIDAD_COMPRA TINYINT UNSIGNED,
    IN p_COSTO_UNITARIO SMALLINT UNSIGNED,
    IN p_FECHA_COMPRA DATE,
    IN p_DESCUENTO INT UNSIGNED,
    IN p_CEDULA BIGINT UNSIGNED,
    IN p_ID_PROVEEDOR INT UNSIGNED,
    IN p_ID_INVENTARIO INT UNSIGNED
)
BEGIN
    DECLARE v_ID_COMPRA TINYINT UNSIGNED;
	DECLARE p_VALOR_TOTAL INT UNSIGNED;
    SET p_VALOR_TOTAL = p_COSTO_UNITARIO * p_CANTIDAD_COMPRA;
    
    INSERT INTO COMPRA (
        FECHA_COMPRA, VALOR_COMPRA, CANTIDAD_COMPRA, DESCUENTO,
        REGISTRADA_POR, SUMINISTRADA_POR, ESTADO_COMPRA
    ) VALUES (
        p_FECHA_COMPRA, p_VALOR_TOTAL, p_CANTIDAD_COMPRA, p_DESCUENTO,
        p_CEDULA, p_ID_PROVEEDOR, 'REALIZADA'
    );

    SET v_ID_COMPRA = LAST_INSERT_ID();

	UPDATE INVENTARIO
	SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE + p_CANTIDAD_COMPRA,
		FECHA_ENTREGA = p_FECHA_COMPRA
	WHERE ID_INVENTARIO = p_ID_INVENTARIO;

    INSERT INTO DETALLES_SURTE (
        VALOR_PRODUCTO, CANTIDAD_PRODUCTO, COMPRA, INVENTARIO
    ) VALUES (
        p_COSTO_UNITARIO, p_CANTIDAD_COMPRA, v_ID_COMPRA, p_ID_INVENTARIO
    );

END $$
DELIMITER ;
/* Procedimiento para registrar las ventas que se hacen a los clientes, donde se elimina lo que se vendio y se registra por cuanto se vendio
*/
CALL RegistrarVentaProducto(4, 61, 20, '2025-06-09', 1023488512);
DELIMITER $$
CREATE PROCEDURE RegistrarVentaProducto(
    IN p_ID_INVENTARIO TINYINT UNSIGNED,
    IN p_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN p_VALOR_UNITARIO SMALLINT UNSIGNED,
    IN p_FECHA_ENTRADA DATE,
    IN p_CEDULA BIGINT UNSIGNED
)
BEGIN
    DECLARE v_VALOR_TOTAL INT UNSIGNED;
    DECLARE v_ID_VENTA TINYINT UNSIGNED;
    SET v_VALOR_TOTAL = p_CANTIDAD_PRODUCTO * p_VALOR_UNITARIO;
    INSERT INTO VENTA (
        CANTIDAD_PRODUCTO,
        VALOR_UNITARIO_PRODUCTO,
        VALOR_TOTAL,
        ESTADO_VENTA,
        VENTA_REALIZADA_POR
    ) VALUES (
        p_CANTIDAD_PRODUCTO,
        p_VALOR_UNITARIO,
        v_VALOR_TOTAL,
        'REALIZADA',
        p_CEDULA
    );
    SET v_ID_VENTA = LAST_INSERT_ID();
    UPDATE INVENTARIO
    SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE - p_CANTIDAD_PRODUCTO
    WHERE ID_INVENTARIO = p_ID_INVENTARIO;
    INSERT INTO DETALLES_ABASTECE (
        CANTIDAD_PRODUCTO,
        FECHA_ENTRADA,
        VALOR_PRODUCTO,
        INVENTARIO,
        VENTA
    ) VALUES (
        p_CANTIDAD_PRODUCTO,
        p_FECHA_ENTRADA,
        p_VALOR_UNITARIO,
        p_ID_INVENTARIO,
        v_ID_VENTA
    );
END $$
DELIMITER ;
/*
*/
DELIMITER //
CREATE PROCEDURE REGISTRAR_DEUDAS()
BEGIN
END //
DELIMITER ;
/* Procedimiento para registrar las deudas de un cliente, y si tiene deuda sumarle y actualizar su fecha de vencimiento de la deuda
*/
SELECT * FROM USUARIO;
SELECT * FROM VENTAS_CREDITO;
SELECT * FROM VENTA;
CALL RegistrarVentaCredito(1, 2, '2025-06-15', '2025-07-15', 1023488523, 1023488526);
DELIMITER $$
CREATE PROCEDURE RegistrarVentaCredito(
    IN p_ID_INVENTARIO TINYINT UNSIGNED,
    IN p_CANTIDAD_PRODUCTO TINYINT UNSIGNED,
    IN p_FECHA_PAGO_CUOTA DATE,
    IN p_FECHA_VENCIMIENTO DATE,
    IN p_DEUDA_DE BIGINT UNSIGNED,
    IN p_CEDULA_REGISTRA BIGINT UNSIGNED
)
BEGIN
    DECLARE v_VALOR_UNITARIO SMALLINT UNSIGNED;
    DECLARE v_VALOR_TOTAL INT UNSIGNED;
    DECLARE v_ID_VENTA TINYINT UNSIGNED;
    DECLARE v_SALDO_ANTERIOR INT UNSIGNED;

    SELECT COSTO_UNITARIO INTO v_VALOR_UNITARIO FROM INVENTARIO WHERE ID_INVENTARIO = p_ID_INVENTARIO;
    SET v_VALOR_TOTAL = v_VALOR_UNITARIO * p_CANTIDAD_PRODUCTO;

    INSERT INTO VENTA (CANTIDAD_PRODUCTO, VALOR_UNITARIO_PRODUCTO, VALOR_TOTAL, ESTADO_VENTA, VENTA_REALIZADA_POR)
    VALUES (p_CANTIDAD_PRODUCTO, v_VALOR_UNITARIO, v_VALOR_TOTAL, 'PENDIENTE', p_CEDULA_REGISTRA);

    SET v_ID_VENTA = LAST_INSERT_ID();

    UPDATE INVENTARIO SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE - p_CANTIDAD_PRODUCTO
    WHERE ID_INVENTARIO = p_ID_INVENTARIO;

    INSERT INTO DETALLES_ABASTECE (CANTIDAD_PRODUCTO, FECHA_ENTRADA, VALOR_PRODUCTO, INVENTARIO, VENTA)
    VALUES (p_CANTIDAD_PRODUCTO, CURDATE(), v_VALOR_UNITARIO, p_ID_INVENTARIO, v_ID_VENTA);

    SELECT IFNULL(SUM(SALDO), 0) INTO v_SALDO_ANTERIOR FROM VENTAS_CREDITO WHERE DEUDA_DE = p_DEUDA_DE;

    INSERT INTO VENTAS_CREDITO (SALDO, NUMERO_CUOTAS, FECHA_PAGO_CUOTA, FECHA_FIADO, DEUDA_DE, DE_QUE_VENTA_ES, FECHA_VENCIMIENTO)
    VALUES (v_SALDO_ANTERIOR + v_VALOR_TOTAL, 1, p_FECHA_PAGO_CUOTA, CURDATE(), p_DEUDA_DE, v_ID_VENTA, p_FECHA_VENCIMIENTO);
END $$
DELIMITER ;

/*Devuelve el total de deuda activa de un cliente específico. Puede usarse para decidir si se le permite seguir comprando a crédito o si debe primero cancelar su deuda pendiente.
*/
DELIMITER $$
CREATE FUNCTION TotalDeudaCliente(p_cedula BIGINT UNSIGNED)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE total INT UNSIGNED;
    SELECT IFNULL(SUM(saldo), 0) INTO total
    FROM VENTAS_CREDITO
    WHERE DEUDA_DE = p_cedula;
    RETURN total;
END $$
DELIMITER ;
SELECT 
    CASE 
        WHEN TotalDeudaCliente(1023488523) > 50000 THEN 'NO PERMITIR MÁS CRÉDITO'
        ELSE 'PERMITIR FIADO'
    END AS Decision_Credito;
/*Devuelve la cantidad disponible de un producto en inventario. Esto permite saber si hay suficiente stock antes de permitir una venta o programar una entrega/evento.
*/
DELIMITER $$
CREATE FUNCTION StockDisponible(p_id_inventario TINYINT UNSIGNED)
RETURNS TINYINT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE cantidad TINYINT UNSIGNED;
    SELECT CANTIDAD_DISPONIBLE INTO cantidad
    FROM INVENTARIO
    WHERE ID_INVENTARIO = p_id_inventario;
    RETURN cantidad;
END $$
DELIMITER ;
SELECT 
    CASE 
        WHEN StockDisponible(10) >= 10 THEN 'STOCK SUFICIENTE'
        ELSE 'REPOSICIÓN NECESARIA'
    END AS Estado_Stock;