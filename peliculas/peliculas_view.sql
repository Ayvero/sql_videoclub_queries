
-- ========================================
-- Vistas de la Base de Datos de Películas
-- ========================================

-- 1) Vista EMPLEADO_DIST
-- Muestra nombre, apellido, sueldo y fecha de nacimiento de los empleados
-- que pertenecen al distribuidor con ID 20.
CREATE VIEW EMPLEADO_DIST AS
SELECT nombre, apellido, sueldo, fecha_nacimiento
FROM unc_esq_pelicula.empleado
WHERE id_distribuidor = 20;

--==========================================================

-- 2) Vista EMPLEADO_DIST_2000
-- Derivada de EMPLEADO_DIST. Lista a los empleados cuyo sueldo supera los 2000.
CREATE VIEW EMPLEADO_DIST_2000 AS
SELECT nombre, apellido, sueldo
FROM EMPLEADO_DIST
WHERE sueldo > 2000;

--======================================================


-- 3) Vista EMPLEADO_DIST_20_70
-- Derivada de EMPLEADO_DIST. Filtra a los empleados nacidos en la década del 70.
CREATE VIEW EMPLEADO_DIST_20_70 AS
SELECT *
FROM EMPLEADO_DIST
WHERE EXTRACT(YEAR FROM fecha_nacimiento) BETWEEN 1970 AND 1979;

--========================================================

-- 4) Vista PELICULAS_ENTREGADAS
-- Muestra el código de cada película junto con la suma total de unidades entregadas.
CREATE VIEW PELICULAS_ENTREGADAS AS
SELECT codigo_pelicula, SUM(cantidad) AS total_entregado
FROM unc_esq_pelicula.renglon_entrega
GROUP BY codigo_pelicula;

--=====================================================

-- 5) Vista ACCION_2000
-- Selecciona películas del género ‘Acción’ que fueron entregadas en el año 2006.
-- Incluye código, título, idioma y formato.
CREATE VIEW ACCION_2000 AS
SELECT codigo_pelicula, titulo, idioma, formato
FROM unc_esq_pelicula.pelicula
WHERE genero = 'Acción'
AND codigo_pelicula IN (
  SELECT codigo_pelicula
  FROM unc_esq_pelicula.renglon_entrega
  WHERE nro_entrega IN (
    SELECT nro_entrega
    FROM unc_esq_pelicula.entrega
    WHERE EXTRACT(YEAR FROM fecha_entrega) = 2006
  )
);

--============================================================

-- 6) Vista DISTRIBUIDORAS_ARGENTINA
-- Incluye datos completos de las distribuidoras nacionales junto con sus departamentos.
CREATE VIEW DISTRIBUIDORAS_ARGENTINA AS
SELECT d.id_distribuidor, d.nombre, d.direccion, d.telefono, d.tipo,
       n.nro_inscripcion, n.encargado, n.id_distrib_mayorista, depto.id_departamento
FROM unc_esq_pelicula.distribuidor d
JOIN unc_esq_pelicula.departamento depto ON d.id_distribuidor = depto.id_distribuidor
JOIN unc_esq_pelicula.nacional n ON d.id_distribuidor = n.id_distribuidor
WHERE tipo = 'N';

--============================================================

-- 7) Vista Distribuidoras_mas_2_emp
-- Derivada de DISTRIBUIDORAS_ARGENTINA. Filtra aquellas distribuidoras cuyos departamentos tienen más de 2 empleados.
CREATE VIEW Distribuidoras_mas_2_emp AS
SELECT *
FROM DISTRIBUIDORAS_ARGENTINA
WHERE (id_distribuidor, id_departamento) IN (
  SELECT id_distribuidor, id_departamento
  FROM unc_esq_pelicula.empleado
  GROUP BY id_distribuidor, id_departamento
  HAVING COUNT(id_empleado) > 2
);


--=======================================================

-- 8) Vista PELI_ARGENTINA
-- Reúne información de películas producidas por empresas productoras argentinas.
-- Incluye datos de la película y de la productora.
CREATE VIEW PELI_ARGENTINA AS
SELECT p.codigo_pelicula, p.titulo, p.idioma, p.formato, p.genero,
       ep.codigo_productora, ep.nombre_productora, c.id_ciudad
FROM unc_esq_pelicula.pelicula p
JOIN unc_esq_pelicula.empresa_productora ep ON p.codigo_productora = ep.codigo_productora
JOIN unc_esq_pelicula.ciudad c ON ep.id_ciudad = c.ciudad
WHERE c.id_pais = 'AR';


--=====================================================

-- 9) Vista ARGENTINAS_NO_ENTREGADA
-- Derivada de PELI_ARGENTINA. Filtra películas argentinas que no han sido entregadas.
CREATE VIEW ARGENTINAS_NO_ENTREGADA AS
SELECT *
FROM PELI_ARGENTINA
WHERE codigo_pelicula NOT IN (
  SELECT codigo_pelicula
  FROM unc_esq_pelicula.renglon_entrega
);


--===================================================

-- 10) Vista PRODUCTORA_MARKETINERA
-- Muestra las empresas productoras que hayan entregado al menos una película
-- a TODOS los distribuidores registrados en el sistema.
-- Se utiliza lógica de división relacional con NOT EXISTS para garantizar que cada
-- distribuidor haya recibido alguna película de la productora.

CREATE VIEW PRODUCTORA_MARKETINERA AS
SELECT ep.*
FROM unc_esq_pelicula.empresa_productora ep
WHERE NOT EXISTS (
  SELECT d.id_distribuidor
  FROM unc_esq_pelicula.distribuidor d
  WHERE NOT EXISTS (
    SELECT 1
    FROM unc_esq_pelicula.entrega e
    JOIN unc_esq_pelicula.renglon_entrega re ON e.nro_entrega = re.nro_entrega
    JOIN unc_esq_pelicula.pelicula p ON p.codigo_pelicula = re.codigo_pelicula
    WHERE e.id_distribuidor = d.id_distribuidor
      AND p.codigo_productora = ep.codigo_productora
  )
);

--==============================================================