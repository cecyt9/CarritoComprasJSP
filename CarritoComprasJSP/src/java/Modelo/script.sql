

-- ------------------------------------------------------
-- CARRITO DE COMPRAS USANDO
-- MODELO VISTA CONTROLADOR
--
-- Creando la base de datos
--

CREATE DATABASE IF NOT EXISTS carritoCompras;
USE carritoCompras;

--
-- Creando la tabla `detalleventa`
--

DROP TABLE IF EXISTS `detalleventa`;
CREATE TABLE `detalleventa` (
  `codigoVenta` int(11) NOT NULL,
  `codigoProducto` int(11) NOT NULL,
  `cantidad` decimal(18,2) NOT NULL,
  `descuento` decimal(18,2) NOT NULL,
  PRIMARY KEY  (`codigoVenta`,`codigoProducto`),
  KEY `FK_DetalleVenta_Producto` (`codigoProducto`),
  CONSTRAINT `FK_DetalleVenta_Producto` FOREIGN KEY (`codigoProducto`) REFERENCES `producto` (`codigoProducto`),
  CONSTRAINT `FK_DetalleVenta_Venta` FOREIGN KEY (`codigoVenta`) REFERENCES `venta` (`codigoVenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Creando la tabla `producto`
--

DROP TABLE IF EXISTS `producto`;
CREATE TABLE `producto` (
  `codigoProducto` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `precio` decimal(18,2) NOT NULL,
  PRIMARY KEY  (`codigoProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Creando la tabla venta
--

DROP TABLE IF EXISTS `venta`;
CREATE TABLE `venta` (
  `codigoVenta` int(11) NOT NULL,
  `cliente` varchar(100) NOT NULL,
  `fecha` datetime NOT NULL,
  PRIMARY KEY  (`codigoVenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

3.2. Creando los procedimientos almacenados

Según Wikipedia un procedimiento almacenado (stored procedure en inglés) es un programa (o procedimiento) el cual es almacenado físicamente en una base de datos. Su implementación varía de un manejador de bases de datos a otro. La ventaja de un procedimiento almacenado es que al ser ejecutado, en respuesta a una petición de usuario, es ejecutado directamente en el motor de bases de datos, el cual usualmente corre en un servidor separado. Como tal, posee acceso directo a los datos que necesita manipular y sólo necesita enviar sus resultados de regreso al usuario, deshaciéndose de la sobrecarga resultante de comunicar grandes cantidades de datos salientes y entrantes.

3.2.1. Procedimientos almacenados para la tabla Producto


-- Procedimiento almacenado para insertar un producto
DROP PROCEDURE IF EXISTS `spI_producto`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spI_producto`(
   INOUT _codigoProducto  int ,
   _nombre  varchar(100) ,
   _precio  decimal(18, 2)
)
BEGIN
-- Genera una especie de autoincremental pero yo controlo los codigos
-- que genero
SELECT IFNULL(MAX(codigoProducto),0)+1 into _codigoProducto FROM `producto`;
INSERT INTO `producto`(
   `codigoProducto`,
   `nombre`,
   `precio`
)
VALUES (
   _codigoProducto,
   _nombre,
   _precio
);
END $$
DELIMITER ;

-- Procedimiento almacenado para actualizar un producto
DROP PROCEDURE IF EXISTS `spU_producto`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spU_producto`(
   _codigoProducto  int ,
   _nombre  varchar(100) ,
   _precio  decimal(18, 2)
)
BEGIN

UPDATE producto
SET 
   `nombre` = _nombre,
   `precio` = _precio
WHERE
    `codigoProducto` = _codigoProducto
;
END $$
DELIMITER ;

-- Procedimiento almacenado para obtener todos los productos
DROP PROCEDURE IF EXISTS `spF_producto_all`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spF_producto_all`(
)
BEGIN

SELECT
    p.codigoProducto,
    p.nombre,
    p.precio
FROM
    producto p
ORDER BY
    P.nombre

;
END $$
DELIMITER ;


-- Procedimiento almacenado para obtener todos los productos
DROP PROCEDURE IF EXISTS `spF_producto_one`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spF_producto_one`(
_codigoProducto  int 
)
BEGIN

SELECT
    p.codigoProducto,
    p.nombre,
    p.precio
FROM
    producto p
WHERE
    p.codigoProducto = _codigoProducto
ORDER BY
    P.nombre

;
END $$
DELIMITER ;


3.2.2. Procedimientos almacenados para la tabla venta



-- Procedimiento almacenado para insertar una venta
DROP PROCEDURE IF EXISTS `spI_venta`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spI_venta`(
   INOUT _codigoVenta  int ,
   _cliente  varchar(100) 
)
BEGIN
-- Codigo autogenerado
SELECT IFNULL(MAX(codigoVenta),0)+1 into _codigoVenta FROM `venta`;
INSERT INTO `venta`(
   `codigoVenta`,
   `cliente`,
   `fecha`
)
VALUES (
   _codigoVenta,
   _cliente,
   CURDATE()
);
END $$
DELIMITER ;

-- Procedimiento almacenado para obtener todas las ventas
DROP PROCEDURE IF EXISTS `spF_venta_All`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spF_venta_All`(
)
BEGIN
SELECT
    v.codigoVenta AS CodigoVenta,
    v.cliente AS Cliente, 
    v.fecha AS Fecha,
    d.codigoProducto AS CodigoProducto, 
    p.nombre AS Nombre,
    p.precio AS Precio, 
    d.cantidad AS Cantidad,
    d.descuento AS Descuento,
    p.precio*d.cantidad AS Parcial,
    ((p.precio*d.cantidad)-d.descuento) AS SubTotal,
    (
    SELECT     
        SUM((dT.cantidad * pT.precio)-dT.descuento) AS TotalPagar
    FROM         
        DetalleVenta AS dT INNER JOIN
        Producto AS pT ON dT.codigoProducto = pT.codigoProducto
    WHERE
        dT.codigoVenta=v.codigoVenta
    ) AS TotalPagar
FROM 
    Venta AS v INNER JOIN
    DetalleVenta AS d ON v.codigoVenta = d.codigoVenta INNER JOIN
    Producto AS p ON d.codigoProducto = p.codigoProducto
ORDER BY
    CodigoVenta, Nombre
 ;
END $$
DELIMITER ;

-- Procedimiento almacenado para obtener una venta
DROP PROCEDURE IF EXISTS `spF_venta_one`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spF_venta_one`(
  _codigoVenta  int
)
BEGIN
SELECT
    v.codigoVenta AS CodigoVenta,
    v.cliente AS Cliente, 
    v.fecha AS Fecha, 
    d.codigoProducto AS CodigoProducto, 
    p.nombre AS Nombre,
    p.precio AS Precio, 
    d.cantidad AS Cantidad, 
    d.descuento AS Descuento,
    p.precio*d.cantidad AS Parcial,
    ((p.precio*d.cantidad)-d.descuento) AS SubTotal,
    (
    SELECT     
        SUM((dT.cantidad * pT.precio)-dT.descuento) AS TotalPagar
    FROM         
        DetalleVenta AS dT INNER JOIN
        Producto AS pT ON dT.codigoProducto = pT.codigoProducto
    WHERE
        dT.codigoVenta=v.codigoVenta
    ) AS TotalPagar
FROM 
    Venta AS v INNER JOIN
    DetalleVenta AS d ON v.codigoVenta = d.codigoVenta INNER JOIN
    Producto AS p ON d.codigoProducto = p.codigoProducto
WHERE
    v.codigoVenta=_codigoVenta
ORDER BY
    Nombre
;
END $$
DELIMITER ;

3.2.3. Procedimientos almacenados para la tabla DetalleVenta


-- Procedimiento almacenado para insertar un detalle de venta
DROP PROCEDURE IF EXISTS `spI_detalleventa`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spI_detalleventa`(
   _codigoVenta  int ,
   _codigoProducto  int ,
   _cantidad  decimal(18, 2) ,
   _descuento  decimal(18, 2)
)
BEGIN

INSERT INTO `detalleventa`(
   `codigoVenta`,
   `codigoProducto`,
   `cantidad`,
   `descuento`
)
VALUES (
   _codigoVenta,
   _codigoProducto,
   _cantidad,
   _descuento
);
END $$
DELIMITER ;