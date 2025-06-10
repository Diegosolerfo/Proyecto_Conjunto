CREATE DATABASE CONJUNTO;
USE CONJUNTO;
#Drop database CONJUNTO;
CREATE TABLE USUARIO (
		CEDULA BIGINT UNSIGNED PRIMARY KEY,
		NOMBRE VARCHAR(25) NOT NULL,
        APELLIDO VARCHAR(25) NOT NULL,
        CONTRASENA VARCHAR(25) NOT NULL,
		CORREO VARCHAR(60) NOT NULL,
		TIPO_USUARIO ENUM('ADMINISTRADOR','CAJERO','CLIENTE') NOT NULL,
		ESTADO ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO' NOT NULL,
		TELEFONO INT UNSIGNED NOT NULL,
		GENERO ENUM('MASCULINO','FEMENINO') NOT NULL
	);
    SELECT * FROM USUARIO;
    CREATE TABLE PROVEEDOR (
		ID_PROVEEDOR INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
		NOMBRE_PROVEEDOR VARCHAR(25) NOT NULL,
		NUMERO_TELEFONICO BIGINT UNSIGNED NOT NULL,
        CORREO_PROVEEDOR VARCHAR(40) NOT NULL,
        DIRECCION VARCHAR(40) NOT NULL,
		ESTADO ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO' NOT NULL
	);
    CREATE TABLE INVENTARIO (
		ID_INVENTARIO TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
		NOMBRE_PRODUCTO VARCHAR(30) NOT NULL,
		DESCRIPCION_PRODUCTO VARCHAR(40) NOT NULL,
		CANTIDAD_DISPONIBLE TINYINT UNSIGNED NOT NULL,
        UNIDAD_MEDIDA ENUM('L','Ml','Gal','M','Cm','Ft','Kg','G','Lb','Mg') NOT NULL,
		ESTADO_PRODUCTO ENUM('DISPONIBLE','NO DISPONIBLE') DEFAULT 'DISPONIBLE' NOT NULL, 
		COSTO_UNITARIO SMALLINT UNSIGNED NOT NULL,
        FECHA_ENTREGA DATE NOT NULL,
		REGISTRADO_POR BIGINT UNSIGNED NOT NULL,
		FOREIGN KEY (REGISTRADO_POR) REFERENCES USUARIO (CEDULA)
	);
    CREATE TABLE COMPRA (
		ID_COMPRA TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
		FECHA_COMPRA DATE NOT NULL,
		VALOR_COMPRA MEDIUMINT UNSIGNED NOT NULL,
		CANTIDAD_COMPRA TINYINT UNSIGNED NOT NULL,
		ESTADO_COMPRA ENUM('REALIZADA','NO REALIZADA') DEFAULT 'NO REALIZADA' NOT NULL,
		DESCUENTO INT UNSIGNED NULL,
		REGISTRADA_POR BIGINT UNSIGNED NOT NULL,
		SUMINISTRADA_POR INT UNSIGNED NOT NULL,
		FOREIGN KEY (REGISTRADA_POR) REFERENCES USUARIO (CEDULA),
		FOREIGN KEY (SUMINISTRADA_POR) REFERENCES PROVEEDOR (ID_PROVEEDOR)
	);
CREATE TABLE DETALLES_SURTE (
		VALOR_PRODUCTO MEDIUMINT NOT NULL,
		CANTIDAD_PRODUCTO INT NOT NULL,
		COMPRA TINYINT UNSIGNED NOT NULL,
		INVENTARIO TINYINT UNSIGNED NOT NULL,
		FOREIGN KEY (COMPRA) REFERENCES COMPRA (ID_COMPRA),
		FOREIGN KEY (INVENTARIO) REFERENCES INVENTARIO (ID_INVENTARIO)
	);
CREATE TABLE DETALLES_SUMINISTRA (
		PROVEEDOR INT UNSIGNED NOT NULL,
		INVENTARIO TINYINT UNSIGNED NOT NULL,
		FOREIGN KEY (PROVEEDOR) REFERENCES PROVEEDOR (ID_PROVEEDOR),
		FOREIGN KEY (INVENTARIO) REFERENCES INVENTARIO (ID_INVENTARIO)
	);
CREATE TABLE VENTA(
       ID_VENTA TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
       /* valor unitario estan en el inventario*/
       CANTIDAD_PRODUCTO TINYINT UNSIGNED NOT NULL,
       VALOR_UNITARIO_PRODUCTO SMALLINT UNSIGNED NOT NULL,
       VALOR_TOTAL INT UNSIGNED NOT NULL,
       ESTADO_VENTA ENUM('REALIZADA','PENDIENTE') NOT NULL,
       VENTA_REALIZADA_POR BIGINT UNSIGNED NOT NULL,
       FOREIGN KEY (VENTA_REALIZADA_POR) REFERENCES USUARIO (CEDULA)
    );
    CREATE TABLE DETALLES_ABASTECE (
    /*cantidad producto ya esta en venta*/
		CANTIDAD_PRODUCTO TINYINT UNSIGNED NOT NULL,
        /*Es fecha salida*/
        FECHA_ENTRADA DATE NOT NULL,
		VALOR_PRODUCTO MEDIUMINT UNSIGNED NOT NULL,
		INVENTARIO TINYINT UNSIGNED NOT NULL,
		VENTA TINYINT UNSIGNED NOT NULL,
		FOREIGN KEY (INVENTARIO) REFERENCES INVENTARIO (ID_INVENTARIO),
		FOREIGN KEY (VENTA) REFERENCES VENTA (ID_VENTA)
	);
CREATE TABLE EVENTO( 
	   ID_EVENTO TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
       NOMBRE_EVENTO VARCHAR(100) NOT NULL,
       DESCRIPCION_EVENTO VARCHAR(100) NOT NULL,
       TIPO_EVENTO VARCHAR(30) NOT NULL,
       FECHA_EVENTO DATE NOT NULL,
       HORA_INICIO TIME NOT NULL,
       HORA_FIN TIME NOT NULL,
       LUGAR VARCHAR(30) NOT NULL,
       OBSERVACIONES VARCHAR(50) NOT NULL
    );
    CREATE TABLE DETALLE_SURTE_EVENTO (
    CANTIDAD_PRODUCTO TINYINT UNSIGNED NOT NULL,
	VALOR_PRODUCTO MEDIUMINT UNSIGNED NOT NULL,
    INVENTARIO TINYINT UNSIGNED NOT NULL,
	EVENTO TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (INVENTARIO) REFERENCES INVENTARIO (ID_INVENTARIO),
	FOREIGN KEY (EVENTO) REFERENCES EVENTO (ID_EVENTO)
    );
    CREATE TABLE VENTAS_CREDITO (
    ID_FIADO TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	SALDO INT UNSIGNED NOT NULL,
    NUMERO_CUOTAS TINYINT UNSIGNED NOT NULL,
    FECHA_PAGO_CUOTA DATE NOT NULL,
    FECHA_FIADO DATE NOT NULL,
	DEUDA_DE BIGINT UNSIGNED NOT NULL,
    DE_QUE_VENTA_ES TINYINT UNSIGNED NOT NULL,
    FECHA_VENCIMIENTO DATE NOT NULL,
	FOREIGN KEY (DEUDA_DE) REFERENCES USUARIO (CEDULA),
    FOREIGN KEY (DE_QUE_VENTA_ES) REFERENCES VENTA (ID_VENTA)
    );
-- 20 Inserciones de prueba para la tabla USUARIO
INSERT INTO USUARIO (CEDULA, NOMBRE, APELLIDO, CONTRASENA, CORREO, TIPO_USUARIO, ESTADO, TELEFONO, GENERO) VALUES
(1023488570,'Juan', 'Perez', 'pass123', 'juan.perez@example.com', 'ADMINISTRADOR', 'ACTIVO', 3001234567, 'MASCULINO'),
(1065488767,'Maria', 'Lopez', 'securepass', 'maria.lopez@example.com', 'CAJERO', 'ACTIVO', 3109876543, 'FEMENINO'),
(1023488579,'Carlos', 'Gomez', 'mysecret', 'carlos.gomez@example.com', 'CLIENTE', 'ACTIVO', 3205551234, 'MASCULINO'),
(1023488578,'Ana', 'Diaz', 'anapass', 'ana.diaz@example.com', 'CLIENTE', 'ACTIVO', 3012345678, 'FEMENINO'),
(1023488556,'Pedro', 'Ramirez', 'pedroR', 'pedro.r@example.com', 'CAJERO', 'ACTIVO', 3112223344, 'MASCULINO'),
(1023488533,'Laura', 'Garcia', 'lauraG', 'laura.g@example.com', 'CLIENTE', 'ACTIVO', 3054445566, 'FEMENINO'),
(1023488512,'Miguel', 'Hernandez', 'miguelH', 'miguel.h@example.com', 'ADMINISTRADOR', 'ACTIVO', 3156667788, 'MASCULINO'),
(1023488526,'Sofia', 'Martinez', 'sofiaM', 'sofia.m@example.com', 'CAJERO', 'ACTIVO', 3048889900, 'FEMENINO'),
(1023488577,'Diego', 'Rodriguez', 'diegoR', 'diego.r@example.com', 'CLIENTE', 'INACTIVO', 3121112233, 'MASCULINO'),
(1023488545,'Valentina', 'Sanchez', 'valeS', 'vale.s@example.com', 'CLIENTE', 'ACTIVO', 3009998877, 'FEMENINO'),
(1023488590,'Andres', 'Torres', 'andresT', 'andres.t@example.com', 'CAJERO', 'ACTIVO', 3137776655, 'MASCULINO'),
(1023488567,'Camila', 'Flores', 'camiF', 'cami.f@example.com', 'CLIENTE', 'ACTIVO', 3025554433, 'FEMENINO'),
(1023488592,'Felipe', 'Vargas', 'felipeV', 'felipe.v@example.com', 'ADMINISTRADOR', 'ACTIVO', 3163332211, 'MASCULINO'),
(1023488573,'Isabella', 'Rojas', 'isaR', 'isa.r@example.com', 'CAJERO', 'ACTIVO', 3031110099, 'FEMENINO'),
(1023488584,'Gabriel', 'Cruz', 'gaboC', 'gabo.c@example.com', 'CLIENTE', 'ACTIVO', 3179990011, 'MASCULINO'),
(1023488546,'Lucia', 'Morales', 'valeM', 'vale.m@example.com', 'CLIENTE', 'INACTIVO', 3068887766, 'FEMENINO'),
(1023488575,'Santiago', 'Herrera', 'santiH', 'santi.h@example.com', 'CAJERO', 'ACTIVO', 3187776655, 'MASCULINO'),
(1023488523,'Daniela', 'Castillo', 'daniC', 'dani.c@example.com', 'CLIENTE', 'ACTIVO', 3075554433, 'FEMENINO'),
(1023488542,'Joaquin', 'Ruiz', 'joaquinR', 'joaquin.r@example.com', 'ADMINISTRADOR', 'ACTIVO', 3193332211, 'MASCULINO'),
(1023488561,'Natalia', 'Ortega', 'natiO', 'nati.o@example.com', 'CLIENTE', 'ACTIVO', 3081110099, 'FEMENINO');


-- 20 Inserciones de prueba para la tabla PROVEEDOR
INSERT INTO PROVEEDOR (NOMBRE_PROVEEDOR, NUMERO_TELEFONICO, CORREO_PROVEEDOR, ESTADO) VALUES
('TecnoSuministros', 6011112222, 'info@tecnosuministros.com', 'ACTIVO'),
('ElectroDistribuidor', 6013334444, 'ventas@electrodistribuidor.com', 'ACTIVO'),
('Materiales SAS', 6015556666, 'contacto@materialessas.com', 'INACTIVO'),
('Suministros Globales', 6017778888, 'info@suministrosglobales.com', 'ACTIVO'),
('Distribuciones Alfa', 6019990000, 'ventas@distribucionesalfa.com', 'ACTIVO'),
('Proveedores Unidos', 6012221111, 'contacto@proveedoresunidos.com', 'ACTIVO'),
('Comercializadora Beta', 6014443333, 'ventas@comercializadorabeta.com', 'INACTIVO'),
('Logística Express', 6016665555, 'info@logisticaexpress.com', 'ACTIVO'),
('Importaciones Del Sol', 6018887777, 'ventas@importacionesdelsol.com', 'ACTIVO'),
('Grupo Mayorista', 6010009999, 'contacto@grupomayorista.com', 'ACTIVO'),
('TecnoFuturo Ltda.', 6011234567, 'tecno@tecnofuturo.com', 'ACTIVO'),
('EcoSuministros', 6017654321, 'eco@ecosuministros.com', 'ACTIVO'),
('Innovación Mayorista', 6019876543, 'innova@innovacion.com', 'ACTIVO'),
('Global Parts S.A.S.', 6012345678, 'global@globalparts.com', 'ACTIVO'),
('Mundo Electrónico', 6018765432, 'mundo@mundoelectronico.com', 'INACTIVO'),
('Componentes Premium', 6013456789, 'premium@componentes.com', 'ACTIVO'),
('Servicios Industriales', 6017890123, 'industrial@servicios.com', 'ACTIVO'),
('Soluciones Tecnológicas', 6014567890, 'soluciones@soluciones.com', 'ACTIVO'),
('Red de Distribución', 6019012345, 'red@distribucion.com', 'ACTIVO'),
('Proyectos Integrales', 6016789012, 'proyectos@integrales.com', 'ACTIVO');


-- 20 Inserciones de prueba para la tabla INVENTARIO
INSERT INTO INVENTARIO (NOMBRE_PRODUCTO, DESCRIPCION_PRODUCTO, CANTIDAD_DISPONIBLE, ESTADO_PRODUCTO, COSTO_UNITARIO, FECHA_ENTREGA, REGISTRADO_POR) VALUES
('Laptop Dell XPS', 'Portátil de alta gama', 10, 'DISPONIBLE', 1500, '2024-05-15', 1023488512),
('Monitor LG Ultrawide', 'Monitor curvo 34 pulgadas', 25, 'DISPONIBLE', 300, '2024-05-10', 1023488533),
('Teclado Mecánico', 'Teclado RGB gaming', 50, 'DISPONIBLE', 75, '2024-05-20', 1023488556),
('Mouse Inalámbrico', 'Mouse ergonómico', 100, 'DISPONIBLE', 20, '2024-05-18', 1023488556),
('Impresora HP', 'Impresora multifuncional', 5, 'NO DISPONIBLE', 200, '2024-05-01', 1023488533),
('Disco Duro SSD 1TB', 'Almacenamiento de alta velocidad', 30, 'DISPONIBLE', 100, '2024-05-25', 1023488512),
('Tarjeta Gráfica RTX', 'Para gaming y diseño gráfico', 8, 'DISPONIBLE', 800, '2024-05-22', 1023488533),
('Webcam Full HD', 'Para videollamadas de calidad', 60, 'DISPONIBLE', 40, '2024-05-19', 1023488556),
('Router WiFi 6', 'Conexión a internet rápida', 15, 'DISPONIBLE', 90, '2024-05-17', 1023488578),
('Auriculares Gaming', 'Sonido envolvente para juegos', 40, 'DISPONIBLE', 60, '2024-05-21', 1023488579),
('Memoria RAM 16GB', 'Para mejorar rendimiento PC', 70, 'DISPONIBLE', 50, '2024-05-16', 1023488579),
('Fuente de Poder 750W', 'Para equipos de alto consumo', 12, 'DISPONIBLE', 80, '2024-05-24', 1065488767),
('Cámara de Seguridad IP', 'Vigilancia remota', 20, 'DISPONIBLE', 120, '2024-05-13', 1023488533);


-- 20 Inserciones de prueba para la tabla COMPRA
INSERT INTO COMPRA (FECHA_COMPRA, VALOR_COMPRA, CANTIDAD_COMPRA, ESTADO_COMPRA, DESCUENTO, REGISTRADA_POR, SUMINISTRADA_POR) VALUES
('2024-05-20', 15000, 10, 'REALIZADA', 500, 1023488578, 1),
('2024-05-22', 7500, 25, 'REALIZADA', 200, 1023488570, 2),
('2024-05-23', 1000, 5, 'NO REALIZADA', NULL, 1023488579, 1),
('2024-05-24', 3000, 30, 'REALIZADA', 100, 1023488579, 4),
('2024-05-25', 6400, 8, 'REALIZADA', 300, 1023488578, 4),
('2024-05-26', 2400, 60, 'REALIZADA', 80, 1023488512, 5),
('2024-05-27', 1350, 15, 'REALIZADA', 50, 1023488533, 6),
('2024-05-28', 2400, 40, 'REALIZADA', 100, 1023488512, 7),
('2024-05-29', 3500, 70, 'REALIZADA', 150, 1023488533, 8),
('2024-05-30', 960, 12, 'REALIZADA', 40, 1023488533, 9),
('2024-05-31', 2400, 20, 'REALIZADA', 100, 1023488512, 10),
('2024-06-01', 7000, 3, 'REALIZADA', 250, 1023488579, 11),
('2024-06-02', 22000, 200, 'REALIZADA', 1000, 1065488767, 12),
('2024-06-03', 2450, 7, 'REALIZADA', 100, 1023488579, 13),
('2024-06-04', 1350, 90, 'REALIZADA', 50, 1023488578, 14),
('2024-06-05', 1500, 150, 'REALIZADA', 75, 1023488556, 15),
('2024-06-06', 1050, 35, 'REALIZADA', 30, 1023488512, 16),
('2024-06-07', 550, 22, 'REALIZADA', 20, 1023488556, 17),
('2024-06-08', 2500, 10, 'REALIZADA', 100, 1023488533, 18),
('2024-06-09', 4000, 20, 'NO REALIZADA', 150, 1023488512, 19);

-- 20 Inserciones de prueba para la tabla DETALLES_SURTE
INSERT INTO DETALLES_SURTE (VALOR_PRODUCTO, CANTIDAD_PRODUCTO, COMPRA, INVENTARIO) VALUES
(1500, 10, 1, 1),    -- Laptop Dell XPS
(300, 25, 2, 2),     -- Monitor LG Ultrawide
(75, 50, 2, 3),      -- Teclado Mecánico
(100, 30, 4, 6),     -- Disco Duro SSD 1TB
(800, 8, 5, 7),      -- Tarjeta Gráfica RTX
(40, 60, 6, 8),      -- Webcam Full HD
(90, 15, 7, 9),      -- Router WiFi 6
(60, 40, 8, 8),     -- Auriculares Gaming
(50, 70, 9, 11),     -- Memoria RAM 16GB
(80, 12, 10, 12),    -- Fuente de Poder 750W
(120, 20, 11, 13),   -- Cámara de Seguridad IP
(700, 3, 12, 12),    -- Smart TV 55 pulgadas
(110, 200, 13, 7),   -- Licencia Windows 11
(350, 7, 14, 2),    -- Procesador Intel i7
(15, 90, 15, 1),    -- Adaptador USB-C
(10, 150, 16, 11),   -- Cable HDMI 2.1
(30, 35, 17, 13),    -- Batería Externa 20000mAh
(25, 22, 18, 10),    -- Ventilador CPU RGB
(20, 50, 19, 4),     -- Mouse Inalámbrico (de una compra más grande, un resto)
(200, 5, 3, 5);      -- Impresora HP

-- 20 Inserciones de prueba para la tabla DETALLES_SUMINISTRA
INSERT INTO DETALLES_SUMINISTRA (PROVEEDOR, INVENTARIO) VALUES
(1, 1), (1, 3), (1, 5), (1, 9), (1, 12), (1, 11), (1, 1),
(2, 2), (2, 4), (2, 8), (2, 13), (2, 12), (2, 13),(4, 6),
(4, 7), (4, 10), (4, 11),(5, 12), (5, 13), (5, 10);

-- 20 Inserciones de prueba para la tabla VENTA
INSERT INTO VENTA (CANTIDAD_PRODUCTO, VALOR_UNITARIO_PRODUCTO, VALOR_TOTAL, ESTADO_VENTA, VENTA_REALIZADA_POR) VALUES
(1, 1600, 1600, 'REALIZADA', 1023488512), -- Laptop Dell XPS (Inventario 1)
(2, 80, 160,    'REALIZADA', 1023488533),  -- Teclado Mecánico (Inventario 3)
(1, 320, 320,   'PENDIENTE', 1023488556), -- Monitor LG Ultrawide (Inventario 2)
(1, 25, 25,     'REALIZADA', 1023488578),  -- Mouse Inalámbrico (Inventario 4)
(1, 110, 110,   'REALIZADA', 1023488512), -- Disco Duro SSD 1TB (Inventario 6)
(1, 850, 850,   'REALIZADA', 1023488578), -- Tarjeta Gráfica RTX (Inventario 7)
(2, 45, 90,     'REALIZADA', 1023488578),  -- Webcam Full HD (Inventario 8)
(1, 100, 100,   'PENDIENTE', 1065488767), -- Router WiFi 6 (Inventario 9)
(1, 65, 65,     'REALIZADA', 1023488570),  -- Auriculares Gaming (Inventario 10)
(1, 55, 55,     'REALIZADA', 1023488512), -- Memoria RAM 16GB (Inventario 11)
(1, 85, 85,     'REALIZADA', 1023488512),  -- Fuente de Poder 750W (Inventario 12)
(1, 130, 130,   'PENDIENTE', 1023488556), -- Cámara de Seguridad IP (Inventario 13)
(1, 750, 750,   'REALIZADA', 1023488533), -- Smart TV 55 pulgadas (Inventario 14)
(1, 120, 120,   'REALIZADA', 1023488579), -- Licencia Windows 11 (Inventario 15)
(1, 380, 380,   'REALIZADA', 1023488512), -- Procesador Intel i7 (Inventario 16)
(2, 18, 36,     'REALIZADA', 1065488767),  -- Adaptador USB-C (Inventario 17)
(1, 12, 12,     'REALIZADA', 1023488512),  -- Cable HDMI 2.1 (Inventario 18)
(1, 35, 35,     'PENDIENTE', 1023488570), -- Batería Externa 20000mAh (Inventario 19)
(1, 30, 30,     'REALIZADA', 1023488570),  -- Ventilador CPU RGB (Inventario 20)
(1, 220, 220,   'REALIZADA', 1023488512); -- Impresora HP (Inventario 5)

-- 20 Inserciones de prueba para la tabla DETALLES_ABASTECE
INSERT INTO DETALLES_ABASTECE (CANTIDAD_PRODUCTO, FECHA_ENTRADA, VALOR_PRODUCTO, INVENTARIO, VENTA) VALUES
(1, '2024-05-21', 1500, 1, 1),
(2, '2024-05-23', 75, 3, 2),
(1, '2024-05-23', 300, 2, 3),
(1, '2024-05-25', 20, 4, 4),
(1, '2024-05-26', 100, 6, 5),
(1, '2024-05-27', 800, 7, 6),
(2, '2024-05-27', 40, 8, 7),
(1, '2024-05-28', 90, 9, 8),
(1, '2024-05-29', 60, 10, 9),
(1, '2024-05-30', 50, 11, 10),
(1, '2024-05-31', 80, 12, 11),
(1, '2024-06-01', 120, 13, 12),
(1, '2024-06-02', 700, 11, 13),
(1, '2024-06-03', 110, 12, 14),
(1, '2024-06-04', 350, 13, 15),
(2, '2024-06-05', 15, 9, 16),
(1, '2024-06-06', 10, 8, 17),
(1, '2024-06-07', 30, 1, 18),
(1, '2024-06-08', 25, 2, 19),
(1, '2024-06-09', 200, 5, 20);


-- 20 Inserciones de prueba para la tabla EVENTO
INSERT INTO EVENTO (NOMBRE_EVENTO, DESCRIPCION_EVENTO, TIPO_EVENTO, FECHA_EVENTO) VALUES
('Promoción Verano', 'Descuentos en electrónica', 'Promoción', '2024-06-01'),
('Feria Tecnológica', 'Demostración de nuevos productos', 'Feria', '2024-07-15'),
('Liquidación Fin de Año', 'Grandes descuentos en todo el inventario', 'Liquidación', '2024-12-01'),
('Lanzamiento Smart Home', 'Presentación de dispositivos para el hogar inteligente', 'Lanzamiento', '2024-08-20'),
('Cyber Monday', 'Ofertas online por tiempo limitado', 'Promoción', '2024-11-25'),
('Black Friday', 'Mega descuentos en toda la tienda', 'Promoción', '2024-11-29'),
('Taller de Ensamblaje PC', 'Aprende a armar tu propio computador', 'Taller', '2024-09-10'),
('Exposición de Realidad Virtual', 'Prueba las últimas experiencias VR', 'Exposición', '2024-10-05'),
('Venta Aniversario', 'Celebra con nosotros con precios especiales', 'Promoción', '2024-07-01'),
('Capacitación Software', 'Curso de manejo de software de diseño', 'Capacitación', '2024-08-01'),
('Festival Gamer', 'Torneos y demostraciones de juegos', 'Festival', '2024-09-20'),
('Día del Cliente', 'Sorpresas y descuentos exclusivos para nuestros clientes', 'Promoción', '2024-05-15'),
('Seminario de Ciberseguridad', 'Protege tus datos y dispositivos', 'Seminario', '2024-10-25'),
('Venta Flash Laptops', 'Ofertas relámpago en portátiles', 'Promoción', '2024-06-10'),
('Show de Impresoras 3D', 'Descubre el mundo de la impresión 3D', 'Demostración', '2024-11-10'),
('Ofertas de Regreso a Clases', 'Descuentos en equipos para estudiantes', 'Promoción', '2024-07-25'),
('Charla de Inteligencia Artificial', 'Explorando el futuro de la IA', 'Conferencia', '2024-09-01'),
('Venta Nocturna', 'Descuentos especiales por la noche', 'Promoción', '2024-12-15'),
('Taller de Robótica para Niños', 'Introducción a la robótica divertida', 'Taller', '2024-08-10'),
('Feria de Emprendedores Tech', 'Apoyando a nuevos talentos tecnológicos', 'Feria', '2024-10-10');

-- 20 Inserciones de prueba para la tabla DETALLE_SURTE_EVENTO
INSERT INTO DETALLE_SURTE_EVENTO (CANTIDAD_PRODUCTO, VALOR_PRODUCTO, INVENTARIO, EVENTO) VALUES
(5, 1500, 1, 1),    -- Laptop Dell XPS en Promoción Verano
(10, 75, 3, 1),     -- Teclado Mecánico en Promoción Verano
(3, 300, 2, 2),     -- Monitor LG Ultrawide en Feria Tecnológica
(20, 20, 4, 3),     -- Mouse Inalámbrico en Liquidación Fin de Año
(15, 100, 6, 3),    -- Disco Duro SSD 1TB en Liquidación Fin de Año
(2, 800, 7, 4),     -- Tarjeta Gráfica RTX en Lanzamiento Smart Home (ej. para demos)
(30, 40, 8, 5),     -- Webcam Full HD en Cyber Monday
(7, 90, 9, 6),      -- Router WiFi 6 en Black Friday
(10, 60, 10, 7),    -- Auriculares Gaming en Taller de Ensamblaje PC (para kits)
(5, 50, 11, 8),     -- Memoria RAM 16GB en Exposición de Realidad Virtual (para equipos demo)
(8, 80, 12, 9),     -- Fuente de Poder 750W en Venta Aniversario
(10, 120, 13, 10),   -- Cámara de Seguridad IP en Capacitación Software (para laboratorios)
(1, 700, 10, 11),    -- Smart TV 55 pulgadas en Festival Gamer (para exhibición)
(50, 110, 13, 12),   -- Licencia Windows 11 en Día del Cliente
(3, 350, 11, 13),    -- Procesador Intel i7 en Seminario de Ciberseguridad (para servidores)
(40, 15, 12, 14),    -- Adaptador USB-C en Venta Flash Laptops
(60, 10, 13, 15),    -- Cable HDMI 2.1 en Show de Impresoras 3D
(15, 30, 1, 16),    -- Batería Externa 20000mAh en Ofertas de Regreso a Clases
(10, 25, 10, 17),    -- Ventilador CPU RGB en Charla de Inteligencia Artificial (para equipos de IA)
(1, 200, 5, 18);     -- Impresora HP en Venta Nocturna

-- 20 Inserciones de prueba para la tabla VENTAS_CREDITO
INSERT INTO VENTAS_CREDITO (SALDO, NUMERO_CUOTAS, FECHA_PAGO_CUOTA, FECHA_FIADO, DEUDA_DE, DE_QUE_VENTA_ES) VALUES
(320, 3, '2024-06-22', '2024-05-22',1023488545, 3), -- Monitor LG Ultrawide a Carlos Gomez
(100, 2, '2024-07-01', '2024-06-01', 1023488577, 8), -- Router WiFi 6 a Diego Rodriguez
(130, 4, '2024-08-15', '2024-06-15', 1023488533, 12), -- Cámara de Seguridad IP a Carlos Gomez
(35, 1, '2024-06-08', '2024-06-07', 1023488545, 18), -- Batería Externa 20000mAh a Valeria Morales
(1600, 6, '2024-07-10', '2024-06-10', 1023488577, 1), -- Laptop Dell XPS a Carlos Gomez
(850, 5, '2024-08-20', '2024-06-20', 1023488533, 6), -- Tarjeta Gráfica RTX a Laura Garcia
(90, 2, '2024-07-05', '2024-06-05', 1023488577, 7), -- Webcam Full HD a Valentina Sanchez
(65, 1, '2024-06-12', '2024-06-12', 1023488545, 9), -- Auriculares Gaming a Gabriel Cruz
(55, 1, '2024-06-18', '2024-06-18', 1023488533, 10), -- Memoria RAM 16GB a Daniela Castillo
(85, 3, '2024-07-25', '2024-06-25', 1023488578, 11), -- Fuente de Poder 750W a Natalia Ortega
(750, 5, '2024-09-01', '2024-07-01', 1023488579, 13), -- Smart TV 55 pulgadas a Carlos Gomez
(120, 2, '2024-07-15', '2024-07-01', 1023488579, 14), -- Licencia Windows 11 a Diego Rodriguez
(380, 4, '2024-08-01', '2024-07-01', 1023488578, 15), -- Procesador Intel i7 a Laura Garcia
(36, 1, '2024-07-03', '2024-07-02', 1023488577, 16), -- Adaptador USB-C a Valentina Sanchez
(12, 1, '2024-07-09', '2024-07-08', 1023488545, 17), -- Cable HDMI 2.1 a Gabriel Cruz
(30, 1, '2024-07-11', '2024-07-10', 1023488577, 19), -- Ventilador CPU RGB a Daniela Castillo
(220, 2, '2024-08-05', '2024-07-05', 1023488533, 20), -- Impresora HP a Natalia Ortega
(25, 1, '2024-07-13', '2024-07-13', 1023488577, 4), -- Mouse Inalámbrico a Carlos Gomez
(110, 2, '2024-08-22', '2024-07-22', 1023488579, 5), -- Disco Duro SSD 1TB a Diego Rodriguez
(160, 2, '2024-08-03', '2024-07-03', 1023488578, 2); -- Teclado Mecánico a Valeria Morales
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