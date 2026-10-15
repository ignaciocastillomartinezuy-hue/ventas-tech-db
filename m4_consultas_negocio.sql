USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Resumen ejecutivo mensual

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- CONSULTA 2: Ranking de productos

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- CONSULTA 3: Clientes recurrentes

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;


-- CONSULTA 4: Comparación con el promedio mensual

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE
        WHEN SUM(cantidad * precio_unitario) >
            (SELECT AVG(total_mensual)
             FROM (
                 SELECT SUM(cantidad * precio_unitario) AS total_mensual
                 FROM ventas
                 GROUP BY MONTH(fecha_venta)
             ) AS meses)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- HALLAZGOS
-- 1. El producto 1 genero la mayor facturacion, con un total de 3600.
-- 2. El producto 2 fue el mas vendido en unidades, con 13 unidades.
-- 3. Los cinco clientes realizaron dos pedidos cada uno.