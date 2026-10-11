-- tasa de paro por comunidad en diciembre
select ccaa,
       sum(paro_total) as paro,
       sum(poblacion) as poblacion,
       round(sum(paro_total) * 100.0 / sum(poblacion), 2) as paro_por_100_hab
from datos
where cod_mes = 202512
group by ccaa
order by paro_por_100_hab desc
