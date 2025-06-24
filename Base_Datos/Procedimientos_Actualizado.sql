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