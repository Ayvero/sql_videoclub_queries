
-- ---------------------------------------------------------------
-- Proyecto SQL: Gestión de Videoteca 🎬
-- Contexto práctico:
-- Este conjunto de consultas pertenece a un sistema de gestión de videoteca.
-- A través de una base de datos relacional, se busca obtener información clave 
-- sobre empleados, películas, entregas, idiomas, distribuidores y tareas administrativas.
-- Cada consulta responde a una necesidad concreta en un entorno real.
-- ---------------------------------------------------------------

-- ===============================================================
-- 1. Obtener información básica de los departamentos registrados en el sistema.
-- Esta consulta se utiliza, por ejemplo, para generar un reporte interno que vincule
-- cada departamento con su distribuidor correspondiente. Es útil en análisis organizacionales 
-- o para tareas administrativas relacionadas con la estructura de la empresa.

select id_distribuidor, id_departamento, nombre from 
unc_esq_peliculas.departamento;

-- 2. Listar los empleados que cumplen una tarea específica.
-- Se busca obtener los datos personales de empleados que tienen asignado el id_tarea 7231.
-- Puede ser útil para el equipo de Recursos Humanos si se desea contactar o gestionar 
-- información relacionada con empleados de un mismo rol o área técnica.

select nombre, apellido, telefono from 
unc_esq_peliculas.empleado where id_tarea = '7231' 
order by apellido asc, nombre;

-- 3. Identificar empleados que no perciben comisión.
-- Esta consulta permite detectar a aquellos empleados cuyo campo de porcentaje de comisión 
-- no está registrado. Puede utilizarse para revisar situaciones salariales o actualizar 
-- datos faltantes en el sistema de liquidación de sueldos.

select apellido, id_empleado, porc_comision from 
unc_esq_peliculas.empleado where porc_comision IS NULL;

-- 4. Detectar distribuidores internacionales sin número de teléfono registrado.
-- Sirve para detectar datos incompletos en los registros de distribuidores internacionales,
-- lo cual es especialmente importante para asegurar una comunicación efectiva
-- y mantener actualizada la base de proveedores externos.

select * from unc_esq_peliculas.distribuidor 
where tipo = 'I' and telefono IS NULL;

-- 5. Listar empleados con correos de Gmail y sueldos superiores a $1000.
-- Esta consulta puede aplicarse en campañas de comunicación interna digital o para 
-- segmentar personal que utiliza servicios de correo masivos, en combinación con 
-- criterios salariales. Útil también para detectar posibles tendencias o perfiles digitales.

select apellido, nombre, e_mail from 
unc_esq_peliculas.empleado 
where e_mail like '%gmail%' and sueldo > 1000;


-- 6. Listar los diferentes identificadores de tareas en uso por los empleados.
-- Esta consulta permite identificar los distintos roles o funciones que actualmente 
-- están asignados en la organización. Es útil para auditar las tareas existentes y 
-- optimizar la gestión de recursos humanos.

select distinct id_tarea from unc_esq_peliculas.empleado;

-- 7. Listar cumpleaños de empleados con nombre completo y fecha simplificada.
-- Se muestra el nombre y apellido concatenados junto con el día y mes de cumpleaños, 
-- ordenados cronológicamente. Puede utilizarse en acciones institucionales, como 
-- saludos automáticos, o para eventos de celebración interna.

select nombre ||','||apellido as "Nombre, apellido.", 
extract(day from fecha_nacimiento)||'/'|| extract(month 
from fecha_nacimiento) as "cumpleaños" 
from unc_esq_peliculas.empleado 
order by extract (month from fecha_nacimiento) asc, 
extract(day from fecha_nacimiento);

-- 8. Mostrar la cantidad de películas según su idioma.
-- Esta consulta es útil para análisis de diversidad de catálogo, permitiendo ver 
-- en qué idiomas se concentran más producciones y así orientar decisiones de adquisición 
-- o doblaje.

select count(cantidad), p.idioma 
from unc_esq_peliculas.pelicula p 
inner join unc_esq_peliculas.renglon_entrega r 
on p.codigo_pelicula = r.codigo_pelicula 
group by p.idioma;

-- 9. Calcular la cantidad de empleados por departamento.
-- Permite obtener una visión general del personal asignado a cada área. Es clave 
-- para análisis de estructura organizacional, planificación de recursos o rediseño de equipos.

select count(e.id_empleado), e.id_departamento 
from unc_esq_peliculas.empleado e 
inner join unc_esq_peliculas.departamento d
on e.id_departamento = d.id_departamento 
group by e.id_departamento 
order by e.id_departamento asc;

-- 10. Identificar películas entregadas entre 3 y 5 veces.
-- Esta consulta detecta aquellas películas que han tenido entre 3 y 5 entregas, 
-- permitiendo evaluar su demanda. Es útil para estadísticas de circulación o 
-- toma de decisiones sobre reposición o retiro del catálogo.

select codigo_pelicula, count(nro_entrega) 
from unc_esq_peliculas.renglon_entrega
group by codigo_pelicula
having count(nro_entrega) between 3 and 5;


-- 11. Mostrar los ID de ciudades que tienen más de un departamento.
-- Esta consulta permite detectar concentraciones administrativas en ciertas ciudades, 
-- lo que puede indicar centros operativos importantes o redundancias posibles para revisar.

select id_ciudad, count(id_departamento) as "cant de departamentos" 
from unc_esq_peliculas.departamento
group by id_ciudad
having count(id_departamento) > 1;

-- 12. Listar películas en idioma inglés que tuvieron entregas durante 2006.
-- Sirve para analizar la distribución de películas de un idioma específico (Inglés)
-- en un año determinado, lo cual puede ayudar en estudios de demanda cultural o 
-- planificación de catálogo.

select titulo 
from unc_esq_peliculas.pelicula 
where idioma = 'Inglés'
and exists (
    select 1 
    from unc_esq_peliculas.renglon_entrega 
    where codigo_pelicula = pelicula.codigo_pelicula
)
and exists (
    select 1 
    from unc_esq_peliculas.entrega 
    where extract(year from fecha_entrega) = 2006
);

-- 13. Cantidad de películas entregadas en 2006 por distribuidores nacionales.
-- Esta consulta cuantifica la participación de distribuidores nacionales en el mercado
-- durante un año calendario, útil para informes de participación local en la distribución.

select count(cantidad) as "cantidad de peliculas" 
from unc_esq_peliculas.renglon_entrega r 
join unc_esq_peliculas.entrega e on e.nro_entrega = r.nro_entrega
join unc_esq_peliculas.distribuidor d on d.id_distribuidor = e.id_distribuidor
where extract(year from e.fecha_entrega) = '2006'
and d.tipo = 'N';

-- 14. Departamentos sin empleados cuya diferencia de sueldo (según la tarea) 
-- no supere el 10% del sueldo máximo.
-- Este filtro permite identificar departamentos que aún sin empleados asignados, 
-- poseen tareas con márgenes salariales muy acotados, lo que podría sugerir estructuras rígidas 
-- o funciones altamente estandarizadas.

select d.id_departamento 
from unc_esq_peliculas.departamento d 
join unc_esq_peliculas.empleado e on d.id_departamento = e.id_departamento
join unc_esq_peliculas.tarea t on e.id_tarea = t.id_tarea
where e.id_empleado is null 
and ((t.sueldo_maximo - t.sueldo_minimo) < (0.1 * t.sueldo_maximo));

-- 15. Listar películas que nunca fueron entregadas por un distribuidor nacional.
-- Permite detectar aquellas producciones que no han tenido circulación bajo distribución nacional, 
-- lo que puede reflejar estrategias de mercado, restricciones legales o decisiones comerciales.

select p.pelicula 
from unc_esq_peliculas.pelicula p 
join unc_esq_peliculas.renglon_entrega re on p.codigo_pelicula = re.codigo_pelicula
join unc_esq_peliculas.entrega e on e.nro_entrega = re.nro_entrega
join unc_esq_peliculas.distribuidor d on d.id_distribuidor = e.id_distribuidor
where not exists (
    select 1 
    from unc_esq_peliculas.distribuidor 
    where tipo = 'N'
);


-- 16. Determinar los jefes que poseen personal a cargo y cuyos departamentos están en Argentina.
-- Esta consulta permite identificar jefes operativos activos, específicamente aquellos que
-- lideran equipos en departamentos ubicados dentro del territorio argentino. Es útil para informes
-- de estructura organizacional regional.

select id_jefe 
from unc_esq_peliculas.empleado e 
join unc_esq_peliculas.departamento d on e.id_departamento = d.id_departamento
join unc_esq_peliculas.ciudad c on c.id_ciudad = d.id_ciudad
join unc_esq_peliculas.pais p on p.id_pais = c.id_pais
where id_jefe is not null 
and exists (
    select 1 from unc_esq_peliculas.departamento 
    where d.id_ciudad = c.id_ciudad
)
and exists (
    select 2 from unc_esq_peliculas.pais 
    where c.id_pais = p.id_pais
)
and p.nombre_pais = 'ARGENTINA';

-- 17. Listar nombre y apellido de empleados cuyo jefe tiene una comisión superior en más del 10%.
-- Esta consulta compara el porcentaje de comisión entre empleados y sus jefes en departamentos de Argentina,
-- permitiendo detectar posibles desigualdades o beneficios jerárquicos significativos.

SELECT e.apellido, e.nombre 
FROM unc_esq_peliculas.empleado e
JOIN unc_esq_peliculas.departamento d 
    ON e.id_distribuidor = d.id_distribuidor AND e.id_departamento = d.id_departamento
JOIN unc_esq_peliculas.ciudad c ON d.id_ciudad = c.id_ciudad
JOIN unc_esq_peliculas.pais p ON c.id_pais = p.id_pais
JOIN unc_esq_peliculas.empleado e2 ON e2.id_empleado = d.jefe_departamento
WHERE p.nombre_pais = 'Argentina'
AND (e.porc_comision) <= (e2.porc_comision * 1.10);

-- 18. Indicar la cantidad de películas entregadas a partir del 2010, por género.
-- Esta consulta clasifica la entrega de películas por género desde el año 2010 en adelante,
-- lo que permite evaluar preferencias o tendencias de consumo a nivel de género cinematográfico.

select r.cantidad, p.genero 
from unc_esq_peliculas.renglon_entrega r 
join unc_esq_peliculas.pelicula p on p.codigo_pelicula = r.codigo_pelicula
join unc_esq_peliculas.entrega e on e.nro_entrega = r.nro_entrega
where extract(year from fecha_entrega) > 2009
group by r.cantidad, p.genero;

-- 19. Resumen diario de entregas, mostrando el videoclub y la cantidad entregada.
-- Este informe diario es útil para hacer seguimiento de operaciones logísticas y volumen de distribución
-- por cliente (videoclub), facilitando la detección de picos de demanda.

select e.fecha_entrega, v.propietario, sum(re.cantidad) 
from unc_esq_peliculas.entrega e
join unc_esq_peliculas.renglon_entrega re on e.nro_entrega = re.nro_entrega
join unc_esq_peliculas.video v on v.id_video = e.id_video
group by e.fecha_entrega, v.propietario
order by e.fecha_entrega;

-- 20. Listar ciudades con al menos 30 empleados mayores de edad en tareas asignadas.
-- Consulta útil para evaluar la fuerza laboral activa (mayores de edad) distribuida por ciudad,
-- considerando únicamente aquellas con volumen significativo de empleados (mínimo 30).

SELECT c.nombre_ciudad, COUNT(*) AS "cantidad de empleados"
FROM unc_esq_peliculas.ciudad c
JOIN unc_esq_peliculas.departamento d ON c.id_ciudad = d.id_ciudad
JOIN unc_esq_peliculas.empleado e ON d.id_departamento = e.id_departamento AND d.id_distribuidor = e.id_distribuidor
WHERE age(e.fecha_nacimiento) > '30 years'
GROUP BY c.nombre_ciudad
HAVING COUNT(*) > 30;

-- 21. Para cada tarea, el sueldo máximo debe ser mayor que el sueldo mínimo.
-- Esta restricción de integridad garantiza coherencia en los rangos salariales definidos por tarea.
-- No puede implementarse directamente en PostgreSQL mediante un CHECK simple porque requiere comparar columnas.
-- Se verifica mediante consulta y se sugiere como restricción conceptual.
select id_tarea 
from tarea 
where sueldo_maximo <= sueldo_minimo;

-- Posible restricción teórica (no soportada directamente):
-- alter table tarea add constraint ck_sueldos check (sueldo_maximo > sueldo_minimo);

-- 22. No puede haber más de 70 empleados en cada departamento.
-- Esta es una restricción procedural, ya que depende de un conteo global agrupado por departamento,
-- algo que no puede implementarse mediante un CHECK estándar.
-- Por eso, se valida mediante una consulta de verificación y se plantea como pseudocódigo.

select id_departamento, count(*) as cantidad_empleados
from empleado
group by id_departamento
having count(*) > 70
order by id_departamento;

-- Posible restricción conceptual:
-- alter table empleado add constraint ck_cantidad_empleados
-- check (not exists (
--   select id_departamento from empleado
--   group by id_departamento
--   having count(*) > 70
-- ));

-- 23. Los empleados deben tener jefes que pertenezcan al mismo departamento.
-- Esta regla de integridad referencial no puede aplicarse directamente como restricción en la base de datos
-- porque requiere comparar registros entre filas (empleado y jefe).
-- Se evalúa mediante una consulta y se sugiere como ASSERTION teórica.

select e1.id_empleado, e1.id_departamento, e2.id_departamento 
from empleado e1 
join empleado e2 on e1.id_jefe = e2.id_empleado
where e1.id_departamento <> e2.id_departamento;

-- Posible restricción teórica:
-- create assertion jefes_departamentos
-- check (not exists (
--   select 1 from empleado e1 join empleado e2 
--   on e1.id_jefe = e2.id_empleado 
--   where e1.id_departamento <> e2.id_departamento
-- ));

-- 24. Todas las películas incluidas en una misma entrega deben ser del mismo idioma.
-- Esta regla busca garantizar homogeneidad lingüística dentro de una entrega.
-- No es posible expresarla como CHECK, y por tanto debe verificarse con consultas analíticas.
-- Aquí simplemente se muestra cuántos idiomas aparecen en las entregas.

select count(*), p.idioma 
from renglon_entrega e 
join pelicula p on e.codigo_pelicula = p.codigo_pelicula
group by p.idioma;

-- Nota: Para validar la integridad completa de cada entrega, se debería agrupar por `nro_entrega` y verificar
-- que no haya más de un idioma por entrega (esto requeriría lógica adicional con HAVING COUNT(DISTINCT idioma) > 1).

-- 25. No pueden existir más de 10 empresas productoras en una misma ciudad.
-- Esta restricción no puede imponerse directamente con un CHECK, ya que implica conteo agrupado.
-- Se verifica con consulta y se enuncia la posible restricción como pseudocódigo.

select id_ciudad, count(*) as cantidad_empresas
from empresa_productora
group by id_ciudad
having count(*) > 10
order by id_ciudad;

-- Posible restricción conceptual:
-- alter table empresa_productora add constraint ck_cantidad_por_ciudad
-- check (not exists (
--   select id_ciudad from empresa_productora
--   group by id_ciudad
--   having count(*) > 10
-- ));

-- 26. Para cada película, si el formato es 8mm, el idioma debe ser francés.
-- Esta restricción se puede expresar mediante un CHECK estándar,
-- ya que involucra solo datos de una misma fila.

alter table pelicula add constraint ck_formato_idioma
check (
  (formato = '8mm' and idioma = 'frances') or
  (formato <> '8mm')
);


-- 27. El teléfono de los distribuidores Nacionales debe tener la misma característica
-- (prefijo telefónico) que la de su distribuidor mayorista.
-- Esta restricción requiere comparar registros entre filas relacionadas, por lo tanto
-- no puede implementarse como CHECK y debe verificarse por consulta.

-- Verificación: distribuidores nacionales con diferente prefijo que su mayorista
select d.id_distribuidor, d.telefono as tel_nacional, 
       dm.id_distribuidor as id_mayorista, dm.telefono as tel_mayorista
from distribuidor d
join nacional n on d.id_distribuidor = n.id_distribuidor
join distribuidor dm on n.id_distrib_mayorista = dm.id_distribuidor
where left(d.telefono, 3) <> left(dm.telefono, 3);

-- Posible restricción conceptual (no implementable directamente):
-- create assertion ck_prefijo_mismo
-- check (
--   not exists (
--     select 1 from distribuidor d
--     join nacional n on d.id_distribuidor = n.id_distribuidor
--     join distribuidor dm on n.id_distrib_mayorista = dm.id_distribuidor
--     where left(d.telefono, 3) <> left(dm.telefono, 3)
--   )
-- );
