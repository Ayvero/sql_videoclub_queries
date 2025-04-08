
-- Insertando países
INSERT INTO pais (id_pais, nombre_pais) VALUES 
('AR', 'ARGENTINA'),
('US', 'ESTADOS UNIDOS');

-- Insertando ciudades
INSERT INTO ciudad (id_ciudad, nombre_ciudad, id_pais) VALUES
(1, 'Buenos Aires', 'AR'),
(2, 'New York', 'US');

-- Insertando empresas productoras
INSERT INTO empresa_productora (codigo_productora, nombre_productora, id_ciudad) VALUES
('PRD1', 'Productora Argentina', 1),
('PRD2', 'Productora USA', 2);

-- Insertando películas
INSERT INTO pelicula (codigo_pelicula, titulo, idioma, formato, genero, codigo_productora) VALUES
(101, 'El Secreto de sus Ojos', 'Español', 'DVD', 'Drama', 'PRD1'),
(102, 'Inception', 'Inglés', 'BluRay', 'Ciencia Ficción', 'PRD2'),
(103, 'Amélie', 'Francés', '8mm', 'Romántica', 'PRD2');

-- Insertando distribuidores
INSERT INTO distribuidor (id_distribuidor, telefono) VALUES
(1, '0111234567'),
(2, '0117654321');

-- Inserciones de ejemplo para continuar más adelante si es necesario


-- Insertar departamentos
INSERT INTO unc_esq_peliculas.departamento (id_departamento, nombre, id_ciudad, id_distribuidor, jefe_departamento)
VALUES 
(1, 'Ventas', 1, 1, NULL),
(2, 'Logística', 2, 2, NULL);

-- Insertar empleados
INSERT INTO unc_esq_peliculas.empleado (id_empleado, nombre, apellido, fecha_nacimiento, telefono, e_mail, id_departamento, id_distribuidor, id_tarea, porc_comision, sueldo, id_jefe)
VALUES 
(1, 'Carlos', 'Pérez', '1985-03-22', '3411234567', 'carlos.perez@gmail.com', 1, 1, 7231, 0.15, 1200, NULL),
(2, 'María', 'García', '1990-07-10', '3417654321', 'maria.garcia@yahoo.com', 1, 1, 7231, NULL, 1100, 1),
(3, 'Pedro', 'López', '1980-05-30', '3413344556', 'pedro.lopez@gmail.com', 2, 2, 7232, 0.1, 950, 1);

-- Insertar tareas
INSERT INTO unc_esq_peliculas.tarea (id_tarea, descripcion, sueldo_minimo, sueldo_maximo)
VALUES 
(7231, 'Gerente de ventas', 1000, 2000),
(7232, 'Auxiliar logístico', 800, 1200);

-- Insertar video clubes
INSERT INTO unc_esq_peliculas.video (id_video, nombre_video, propietario, direccion)
VALUES 
(1, 'Videoclub Norte', 'Juan Rodríguez', 'Av. Libertad 123'),
(2, 'BlockVideo Sur', 'Laura Gómez', 'Calle 56 Nº1023');

-- Insertar entregas
INSERT INTO unc_esq_peliculas.entrega (nro_entrega, id_video, fecha_entrega, id_distribuidor)
VALUES 
(1, 1, '2006-04-15', 1),
(2, 2, '2012-08-21', 2);

-- Insertar renglones de entrega
INSERT INTO unc_esq_peliculas.renglon_entrega (nro_entrega, codigo_pelicula, cantidad)
VALUES 
(1, 1, 5),
(1, 2, 3),
(2, 3, 2),
(2, 4, 1);
