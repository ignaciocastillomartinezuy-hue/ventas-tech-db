USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Vista base del proyecto
-- Proposito: ver las ventas con informacion de clientes, productos y categorias.

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Las ventas quedan relacionadas con el cliente, su ciudad,
-- el producto y su categoria, facilitando el analisis del negocio.


-- CONSULTA 2: Clientes sin ventas
-- Proposito: identificar clientes que todavia no realizaron compras.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: No hay clientes registrados sin compras en los datos actuales.
-- CRM no tiene clientes pendientes de primera compra en esta muestra.


-- CONSULTA 3: Productos sin ventas
-- Proposito: identificar productos del catalogo que no se vendieron.

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: No hay productos sin ventas registradas en esta muestra.
-- Todos los productos del catalogo tuvieron movimiento.


-- CONSULTA 4: Consolidado por origen
-- Proposito: comparar la facturacion de dos periodos.
-- Los nombres de origen son etiquetas de ejemplo, no canales reales.

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Periodo 1' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Periodo 2' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal;

-- Hallazgo: El Periodo 1 facturo 3620 y el Periodo 2 facturo 2824.
-- El Periodo 1 genero una facturacion mayor.
