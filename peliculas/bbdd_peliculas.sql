create table pais
(
    id_pais     char(2) not null
        constraint pk_pais
            primary key
        constraint pais_id_pais_check
            check (id_pais IS NOT NULL),
    nombre_pais varchar(40)
)
    with (autovacuum_enabled = true);

alter table pais
    owner to postgres;

create table ciudad
(
    id_ciudad     numeric(6) not null
        constraint pk_ciudad
            primary key
        constraint ciudad_id_ciudad_check
            check (id_ciudad IS NOT NULL),
    nombre_ciudad varchar(100)
        constraint ciudad_nombre_ciudad_check
            check (nombre_ciudad IS NOT NULL),
    id_pais       char(2)
        references pais
        constraint ciudad_id_pais_check
            check (id_pais IS NOT NULL)
)
    with (autovacuum_enabled = true);

alter table ciudad
    owner to postgres;

grant references, select on ciudad to public;

grant delete, insert, references, select, trigger, truncate, update on ciudad to unc_staff;

create table empresa_productora
(
    codigo_productora varchar(6) not null
        constraint pk_empresa_productora
            primary key
        constraint empresa_productora_codigo_productora_check
            check (codigo_productora IS NOT NULL),
    nombre_productora varchar(60)
        constraint empresa_productora_nombre_productora_check
            check (nombre_productora IS NOT NULL),
    id_ciudad         numeric(6)
        references ciudad
)
    with (autovacuum_enabled = true);

alter table empresa_productora
    owner to postgres;

create table pelicula
(
    codigo_pelicula   numeric(5) not null
        constraint pk_pelicula
            primary key
        constraint pelicula_codigo_pelicula_check
            check (codigo_pelicula IS NOT NULL),
    titulo            varchar(60)
        constraint pelicula_titulo_check
            check (titulo IS NOT NULL),
    idioma            varchar(20)
        constraint pelicula_idioma_check
            check (idioma IS NOT NULL),
    formato           varchar(20)
        constraint pelicula_formato_check
            check (formato IS NOT NULL),
    genero            varchar(30)
        constraint pelicula_genero_check
            check (genero IS NOT NULL),
    codigo_productora varchar(6)
        references empresa_productora
        constraint pelicula_codigo_productora_check
            check (codigo_productora IS NOT NULL)
)
    with (autovacuum_enabled = true);

alter table pelicula
    owner to postgres;

grant references, select on pelicula to public;

grant delete, insert, references, select, trigger, truncate, update on pelicula to unc_staff;

grant references, select on empresa_productora to public;

grant delete, insert, references, select, trigger, truncate, update on empresa_productora to unc_staff;

grant references, select on pais to public;

grant delete, insert, references, select, trigger, truncate, update on pais to unc_staff;

create table distribuidor
(
    id_distribuidor numeric(5) not null
        constraint pk_distribuidor
            primary key
        constraint distribuidor_id_distribuidor_check
            check (id_distribuidor IS NOT NULL),
    nombre          varchar(80)
        constraint distribuidor_nombre_check
            check (nombre IS NOT NULL),
    direccion       varchar(120)
        constraint distribuidor_direccion_check
            check (direccion IS NOT NULL),
    telefono        varchar(20),
    tipo            char
        constraint distribuidor_tipo_check
            check (tipo IS NOT NULL)
)
    with (autovacuum_enabled = true);

alter table distribuidor
    owner to postgres;

create table departamento
(
    id_departamento   numeric(4) not null
        constraint departamento_id_departamento_check
            check (id_departamento IS NOT NULL),
    id_distribuidor   numeric(5) not null
        references distribuidor
        constraint departamento_id_distribuidor_check
            check (id_distribuidor IS NOT NULL),
    nombre            varchar(30)
        constraint departamento_nombre_departamento_check
            check (nombre IS NOT NULL),
    calle             varchar(40),
    numero            numeric(6),
    id_ciudad         numeric(6)
        references ciudad
        constraint departamento_id_ciudad_check
            check (id_ciudad IS NOT NULL),
    jefe_departamento numeric(6)
        constraint departamento_jefe_departamento_check
            check (jefe_departamento IS NOT NULL),
    constraint pk_departamento
        primary key (id_distribuidor, id_departamento)
)
    with (autovacuum_enabled = true);

alter table departamento
    owner to postgres;

grant references, select on departamento to public;

grant delete, insert, references, select, trigger, truncate, update on departamento to unc_staff;

grant references, select on distribuidor to public;

grant delete, insert, references, select, trigger, truncate, update on distribuidor to unc_staff;

create table internacional
(
    id_distribuidor numeric(5) not null
        constraint pk_internacional
            primary key
        references distribuidor
            on delete cascade
        constraint internacional_id_distribuidor_check
            check (id_distribuidor IS NOT NULL),
    codigo_pais     varchar(5)
        constraint internacional_codigo_pais_check
            check (codigo_pais IS NOT NULL)
)
    with (autovacuum_enabled = true);

alter table internacional
    owner to postgres;

grant references, select on internacional to public;

grant delete, insert, references, select, trigger, truncate, update on internacional to unc_staff;

create table nacional
(
    id_distribuidor      numeric(5) not null
        constraint pk_nacional
            primary key
        constraint fk_nacional_distribuidor
            references distribuidor
        constraint nacional_id_distribuidor_check
            check (id_distribuidor IS NOT NULL),
    nro_inscripcion      numeric(8)
        constraint nacional_nro_inscripcion_check
            check (nro_inscripcion IS NOT NULL),
    encargado            varchar(60)
        constraint nacional_encargado_check
            check (encargado IS NOT NULL),
    id_distrib_mayorista numeric(5)
        constraint fk_nacional_mayorista
            references internacional
)
    with (autovacuum_enabled = true);

alter table nacional
    owner to postgres;

create index fk_nacional_mayorista
    on nacional (id_distrib_mayorista);

grant references, select on nacional to public;

grant delete, insert, references, select, trigger, truncate, update on nacional to unc_staff;

create table pelis_mas_entragadas
(
    código_pelicula      numeric(5)  not null,
    titulo               varchar(60) not null,
    cantidad_de_entregas integer     not null
);

alter table pelis_mas_entragadas
    owner to unc_vferraggine;

create table tarea
(
    id_tarea      varchar(10) not null
        constraint pk_tarea
            primary key
        constraint tarea_id_tarea_check
            check (id_tarea IS NOT NULL),
    nombre_tarea  varchar(35)
        constraint tarea_nombre_tarea_check
            check (nombre_tarea IS NOT NULL),
    sueldo_maximo numeric(6)
        constraint tarea_sueldo_maximo_check
            check (sueldo_maximo IS NOT NULL),
    sueldo_minimo numeric(6)
        constraint tarea_sueldo_minimo_check
            check (sueldo_minimo IS NOT NULL)
)
    with (autovacuum_enabled = true);

alter table tarea
    owner to postgres;

create table empleado
(
    id_empleado      numeric(6) not null
        constraint pk_empleado
            primary key
        constraint empleado_id_empleado_check
            check (id_empleado IS NOT NULL),
    nombre           varchar(30),
    apellido         varchar(30)
        constraint empleado_apellido_check
            check (apellido IS NOT NULL),
    porc_comision    numeric(6, 2),
    sueldo           numeric(8, 2),
    e_mail           varchar(120)
        constraint empleado_e_mail_check
            check (e_mail IS NOT NULL),
    fecha_nacimiento date
        constraint empleado_fecha_nacimiento_check
            check (fecha_nacimiento IS NOT NULL),
    telefono         varchar(20),
    id_tarea         varchar(10)
        references tarea
        constraint empleado_id_tarea_check
            check (id_tarea IS NOT NULL),
    id_departamento  numeric(4),
    id_distribuidor  numeric(5),
    id_jefe          numeric(6)
        references empleado,
    constraint empleado_id_distribuidor_fkey
        foreign key (id_distribuidor, id_departamento) references departamento
)
    with (autovacuum_enabled = true);

alter table empleado
    owner to postgres;

alter table departamento
    add foreign key (jefe_departamento) references empleado;

grant references, select on empleado to public;

grant delete, insert, references, select, trigger, truncate, update on empleado to unc_staff;

grant references, select on tarea to public;

grant delete, insert, references, select, trigger, truncate, update on tarea to unc_staff;

create table video
(
    id_video     numeric(5) not null
        constraint pk_video
            primary key
        constraint video_id_video_check
            check (id_video IS NOT NULL),
    razon_social varchar(60)
        constraint video_razon_social_check
            check (razon_social IS NOT NULL),
    direccion    varchar(80)
        constraint video_direccion_check
            check (direccion IS NOT NULL),
    telefono     varchar(15),
    propietario  varchar(60)
        constraint video_propietario_check
            check (propietario IS NOT NULL)
)
    with (autovacuum_enabled = true);

alter table video
    owner to postgres;

create table entrega
(
    nro_entrega     numeric(10) not null
        constraint pk_entrega
            primary key
        constraint entrega_nro_entrega_check
            check (nro_entrega IS NOT NULL),
    fecha_entrega   date
        constraint entrega_fecha_entrega_check
            check (fecha_entrega IS NOT NULL),
    id_video        numeric(5)
        constraint fk_entrega_video
            references video
        constraint entrega_id_video_check
            check (id_video IS NOT NULL),
    id_distribuidor numeric(5)
        constraint fk_entrega_distribuidor
            references distribuidor
        constraint entrega_id_distribuidor_check
            check (id_distribuidor IS NOT NULL)
)
    with (autovacuum_enabled = true);

alter table entrega
    owner to postgres;

create index fki_entrega_distribuidor
    on entrega (id_distribuidor);

create index fki_entrega_video
    on entrega (id_video);

grant references, select on entrega to public;

grant delete, insert, references, select, trigger, truncate, update on entrega to unc_staff;

create table renglon_entrega
(
    nro_entrega     numeric(10) not null
        constraint fk_re_entrega
            references entrega
        constraint renglon_entrega_nro_entrega_check
            check (nro_entrega IS NOT NULL),
    codigo_pelicula numeric(5)  not null
        constraint fk_re_pelicula
            references pelicula
        constraint renglon_entrega_codigo_pelicula_check
            check (codigo_pelicula IS NOT NULL),
    cantidad        numeric(5)
        constraint renglon_entrega_cantidad_check
            check (cantidad IS NOT NULL),
    constraint pk_renglon_entrega
        primary key (nro_entrega, codigo_pelicula)
)
    with (autovacuum_enabled = true);

alter table renglon_entrega
    owner to postgres;

create index fki_re_pelicula
    on renglon_entrega (codigo_pelicula);

grant references, select on renglon_entrega to public;

grant delete, insert, references, select, trigger, truncate, update on renglon_entrega to unc_staff;

grant references, select on video to public;

grant delete, insert, references, select, trigger, truncate, update on video to unc_staff;

create view productora_marketinera(codigo_productora, nombre_productora, id_ciudad) as
SELECT ep.codigo_productora,
       ep.nombre_productora,
       ep.id_ciudad
FROM unc_esq_peliculas.empresa_productora ep
         JOIN unc_esq_peliculas.pelicula p USING (codigo_productora)
         JOIN unc_esq_peliculas.renglon_entrega re USING (codigo_pelicula)
         JOIN unc_esq_peliculas.entrega e USING (nro_entrega)
WHERE NOT (EXISTS (SELECT 1
                   FROM unc_esq_peliculas.distribuidor
                   WHERE NOT (distribuidor.id_distribuidor IN (SELECT e2.id_distribuidor
                                                               FROM unc_esq_peliculas.entrega e2
                                                               WHERE e2.nro_entrega = e.nro_entrega))));

alter table productora_marketinera
    owner to unc_ifigini;

