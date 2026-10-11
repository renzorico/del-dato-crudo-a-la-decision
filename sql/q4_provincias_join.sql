-- provincias grandes (> 500000 hab) con mas paro por habitante, cruzando paro y poblacion con un join
select p.provincia,
       sum(p.paro_total) as paro,
       sum(i.poblacion) as poblacion,
       round(sum(p.paro_total) * 100.0 / sum(i.poblacion), 2) as paro_por_100_hab
from paro p
join poblacion i on p.cod_municipio = i.cod_municipio
where p.cod_mes = 202512
group by p.provincia
having sum(i.poblacion) > 500000
order by paro_por_100_hab desc
limit 10
