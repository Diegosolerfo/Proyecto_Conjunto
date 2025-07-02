DELIMITER //

CREATE FUNCTION DeudaConMora(CEDULA BIGINT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE TOTAL DECIMAL(10,2);

  SELECT SUM(
    SALDO +
    (CASE
      WHEN DATEDIFF(CURDATE(), FECHA_VENCIMIENTO) > 0
      THEN SALDO * 0.01 * FLOOR(DATEDIFF(CURDATE(), FECHA_VENCIMIENTO) / 7)
      ELSE 0
    END)
  )
  INTO TOTAL
  FROM VENTAS_CREDITO
  WHERE DEUDA_DE = CEDULA;

  RETURN IFNULL(TOTAL, 0);
END //
DELIMITER ;
#DROP FUNCTION DEUDACONMORA;
Select DeudaConMora(106789012);

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
END //
DELIMITER ;

-- Procedimiento para registrar productos y actualizar el valor de la compra y la cantidad del inventario
DELIMITER $$
CREATE PROCEDURE RegistrarProductos (
    IN P_VALOR_PRODUCTO MEDIUMINT,
    IN P_CANT_PRODUCTO BIGINT,
    IN P_INVENTARIO TINYINT,
    IN P_COMPRA TINYINT
)
BEGIN
	DECLARE TOTAL INT UNSIGNED;
	INSERT INTO DETALLES_SURTE (VALOR_PRODUCTO,CANTIDAD_PRODUCTO,INVENTARIO,COMPRA) 
    VALUES (P_VALOR_PRODUCTO,P_CANT_PRODUCTO,P_INVENTARIO,P_COMPRA);
    
    UPDATE INVENTARIO SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE + P_CANT_PRODUCTO WHERE P_INVENTARIO = ID_INVENTARIO;
    SET TOTAL = P_VALOR_PRODUCTO * P_CANT_PRODUCTO;
    UPDATE COMPRA SET VALOR_COMPRA = VALOR_COMPRA + TOTAL WHERE P_COMPRA = ID_COMPRA;
END$$
DELIMITER ;
#DROP PROCEDURE RegistrarProductos;
CALL REGISTRARPRODUCTOS(2500,10,2,1);
CALL REGISTRARPRODUCTOS(1250,6,1,1);

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