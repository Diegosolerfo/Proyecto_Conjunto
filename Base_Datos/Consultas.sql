-- Consulta todos los usuarios
SELECT * FROM USUARIO;
-- Consulta todos los proveedores
SELECT * FROM PROVEEDOR;
-- Consulta todo el inventario
SELECT * FROM INVENTARIO;
-- Consulta todas las compras
SELECT * FROM COMPRA;
-- Consulta los detalles de surtido
SELECT * FROM DETALLES_SURTE;
-- Consulta los detalles de suministro
SELECT * FROM DETALLES_SUMINISTRA;
-- Consulta todas las ventas
SELECT * FROM VENTA;
-- Consulta los detalles de abastecimiento
SELECT * FROM DETALLES_ABASTECE;
-- Consulta todos los eventos
SELECT * FROM EVENTO;
-- Consulta los detalles de surtido de eventos
SELECT * FROM DETALLE_SURTE_EVENTO;
-- Consulta todas las ventas a crédito
SELECT * FROM VENTAS_CREDITO;
-- Obtener el nombre del usuario que registró cada inventario
SELECT I.NOMBRE_PRODUCTO, U.NOMBRE AS REGISTRADO_POR_NOMBRE, U.APELLIDO AS REGISTRADO_POR_APELLIDO
FROM INVENTARIO I
JOIN USUARIO U ON I.REGISTRADO_POR = U.CEDULA;
-- Obtener información de la compra incluyendo el nombre del usuario que la registró y el proveedor
SELECT
    C.ID_COMPRA,
    C.FECHA_COMPRA,
    C.VALOR_COMPRA,
    U.NOMBRE AS REGISTRADA_POR_USUARIO,
    P.NOMBRE_PROVEEDOR AS SUMINISTRADA_POR_PROVEEDOR
FROM COMPRA C
JOIN USUARIO U ON C.REGISTRADA_POR = U.CEDULA
JOIN PROVEEDOR P ON C.SUMINISTRADA_POR = P.ID_PROVEEDOR;
-- Listar los productos comprados en cada compra con sus detalles
SELECT
    C.ID_COMPRA,
    C.FECHA_COMPRA,
    I.NOMBRE_PRODUCTO,
    DS.CANTIDAD_PRODUCTO AS CANTIDAD_COMPRADA,
    DS.VALOR_PRODUCTO AS VALOR_UNITARIO_EN_COMPRA
FROM COMPRA C
JOIN DETALLES_SURTE DS ON C.ID_COMPRA = DS.COMPRA
JOIN INVENTARIO I ON DS.INVENTARIO = I.ID_INVENTARIO;
-- Mostrar las ventas realizadas, incluyendo el nombre del cajero que las realizó
SELECT
    V.ID_VENTA,
    V.CANTIDAD_PRODUCTO,
    V.VALOR_TOTAL,
    V.ESTADO_VENTA,
    U.NOMBRE AS CAJERO_NOMBRE,
    U.APELLIDO AS CAJERO_APELLIDO
FROM VENTA V
JOIN USUARIO U ON V.VENTA_REALIZADA_POR = U.CEDULA;
-- Obtener los productos que han sido abastecidos para una venta específica
SELECT
    V.ID_VENTA,
    I.NOMBRE_PRODUCTO,
    DA.CANTIDAD_PRODUCTO AS CANTIDAD_ABASTECIDA,
    DA.VALOR_PRODUCTO AS VALOR_ABASTECIDO
FROM VENTA V
JOIN DETALLES_ABASTECE DA ON V.ID_VENTA = DA.VENTA
JOIN INVENTARIO I ON DA.INVENTARIO = I.ID_INVENTARIO;
-- Ver qué productos están asociados a qué eventos
SELECT
    E.NOMBRE_EVENTO,
    I.NOMBRE_PRODUCTO,
    DSE.CANTIDAD_PRODUCTO,
    DSE.VALOR_PRODUCTO
FROM EVENTO E
JOIN DETALLE_SURTE_EVENTO DSE ON E.ID_EVENTO = DSE.EVENTO
JOIN INVENTARIO I ON DSE.INVENTARIO = I.ID_INVENTARIO;
-- Consultar ventas a crédito, mostrando el nombre del cliente y la venta asociada
SELECT
    VC.ID_FIADO,
    VC.SALDO AS VALOR_FIADO,
    VC.NUMERO_CUOTAS,
    VC.FECHA_FIADO,
    U.NOMBRE AS CLIENTE_NOMBRE,
    U.APELLIDO AS CLIENTE_APELLIDO,
    V.ID_VENTA AS VENTA_ORIGEN
FROM VENTAS_CREDITO VC
JOIN USUARIO U ON VC.DEUDA_DE = U.CEDULA
JOIN VENTA V ON VC.DE_QUE_VENTA_ES = V.ID_VENTA;
-- Mostrar el inventario y los proveedores que lo suministran
SELECT
    I.NOMBRE_PRODUCTO,
    P.NOMBRE_PROVEEDOR
FROM INVENTARIO I
JOIN DETALLES_SUMINISTRA DS ON I.ID_INVENTARIO = DS.INVENTARIO
JOIN PROVEEDOR P ON DS.PROVEEDOR = P.ID_PROVEEDOR;
-- Obtener el total de productos disponibles por cada estado de producto
SELECT ESTADO_PRODUCTO, SUM(CANTIDAD_DISPONIBLE) AS TOTAL_PRODUCTOS
FROM INVENTARIO
GROUP BY ESTADO_PRODUCTO;

/* Consulta para obtener las compras con
los datos del usuario que las registró,
el proveedor que las suministró y
el inventario recibido en dichas compras */
SELECT c.ID_COMPRA, c.FECHA_COMPRA, u.NOMBRE, u.APELLIDO,
       p.NOMBRE_PROVEEDOR, i.NOMBRE_PRODUCTO, ds.CANTIDAD_PRODUCTO
FROM COMPRA c
JOIN USUARIO u ON c.REGISTRADA_POR = u.CEDULA
JOIN PROVEEDOR p ON c.SUMINISTRADA_POR = p.ID_PROVEEDOR
JOIN DETALLES_SURTE ds ON c.ID_COMPRA = ds.COMPRA
JOIN INVENTARIO i ON ds.INVENTARIO = i.ID_INVENTARIO;

/* Consulta que permite mostrar los eventos
y qué productos del inventario fueron usados
para abastecer dichos eventos incluyendo
el valor y cantidad usados por evento */
SELECT e.NOMBRE_EVENTO, e.FECHA_EVENTO, 
       i.NOMBRE_PRODUCTO, dse.CANTIDAD_PRODUCTO,
       dse.VALOR_PRODUCTO
FROM EVENTO e
JOIN DETALLE_SURTE_EVENTO dse ON e.ID_EVENTO = dse.EVENTO
JOIN INVENTARIO i ON dse.INVENTARIO = i.ID_INVENTARIO
JOIN PROVEEDOR p ON p.ID_PROVEEDOR IN (
  SELECT PROVEEDOR FROM DETALLES_SUMINISTRA WHERE INVENTARIO = i.ID_INVENTARIO
);

/* Consulta de control administrativo para ver
las ventas realizadas, con el usuario vendedor,
los productos entregados en dicha venta y
datos básicos del inventario involucrado */
SELECT v.ID_VENTA, u.NOMBRE, u.APELLIDO, 
       i.NOMBRE_PRODUCTO, da.CANTIDAD_PRODUCTO
FROM VENTA v
JOIN USUARIO u ON v.VENTA_REALIZADA_POR = u.CEDULA
JOIN DETALLES_ABASTECE da ON v.ID_VENTA = da.VENTA
JOIN INVENTARIO i ON da.INVENTARIO = i.ID_INVENTARIO;

/* Consulta enfocada a la gestión de fiados,
identificando al usuario deudor, la venta
a la que pertenece la deuda y el detalle
de los productos vendidos en dicha venta */
SELECT vc.ID_FIADO, u.NOMBRE, u.APELLIDO,
       i.NOMBRE_PRODUCTO, da.VALOR_PRODUCTO
FROM VENTAS_CREDITO vc
JOIN USUARIO u ON vc.DEUDA_DE = u.CEDULA
JOIN VENTA v ON vc.DE_QUE_VENTA_ES = v.ID_VENTA
JOIN DETALLES_ABASTECE da ON v.ID_VENTA = da.VENTA
JOIN INVENTARIO i ON da.INVENTARIO = i.ID_INVENTARIO;

/* Reporte completo para la gerencia, muestra
los productos del inventario, su proveedor,
las compras donde fueron incluidos y
la cantidad registrada en cada compra */
SELECT i.NOMBRE_PRODUCTO, p.NOMBRE_PROVEEDOR,
       c.ID_COMPRA, ds.CANTIDAD_PRODUCTO
FROM INVENTARIO i
JOIN DETALLES_SUMINISTRA dsum ON i.ID_INVENTARIO = dsum.INVENTARIO
JOIN PROVEEDOR p ON dsum.PROVEEDOR = p.ID_PROVEEDOR
JOIN DETALLES_SURTE ds ON i.ID_INVENTARIO = ds.INVENTARIO
JOIN COMPRA c ON ds.COMPRA = c.ID_COMPRA;

/* Informe de auditoría completo, que une
datos de ventas a crédito, sus productos,
inventario asociado, vendedor de la venta
y datos de usuario deudor para auditoría */
SELECT vc.ID_FIADO, u.NOMBRE AS DEUDOR, 
       v.ID_VENTA, uv.NOMBRE AS VENDEDOR,
       i.NOMBRE_PRODUCTO, da.VALOR_PRODUCTO
FROM VENTAS_CREDITO vc
JOIN USUARIO u ON vc.DEUDA_DE = u.CEDULA
JOIN VENTA v ON vc.DE_QUE_VENTA_ES = v.ID_VENTA
JOIN USUARIO uv ON v.VENTA_REALIZADA_POR = uv.CEDULA
JOIN DETALLES_ABASTECE da ON v.ID_VENTA = da.VENTA
JOIN INVENTARIO i ON da.INVENTARIO = i.ID_INVENTARIO;