-- tablas que cargo en duckdb desde los dataframes limpios
create or replace table paro (
    cod_mes integer,
    cod_municipio varchar,
    municipio varchar,
    provincia varchar,
    ccaa varchar,
    paro_total integer,
    h_menor25 integer, h_25_45 integer, h_mayor45 integer,
    m_menor25 integer, m_25_45 integer, m_mayor45 integer,
    agricultura integer, industria integer, construccion integer,
    servicios integer, sin_empleo_ant integer
);

create or replace table poblacion (
    cod_municipio varchar,
    municipio varchar,
    poblacion double
);
