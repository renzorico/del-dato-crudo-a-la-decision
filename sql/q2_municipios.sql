-- municipios grandes (>= 20000 hab) con mas paro por habitante
select municipio, provincia, poblacion, paro_total,
       round(paro_total * 100.0 / poblacion, 2) as paro_por_100_hab
from datos
where cod_mes = 202512 and poblacion >= 20000
order by paro_por_100_hab desc
limit 10
