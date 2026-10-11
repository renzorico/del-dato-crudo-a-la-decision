-- evolucion mensual del paro total, hombres vs mujeres
select cod_mes,
       sum(paro_total) as paro,
       sum(h_menor25 + h_25_45 + h_mayor45) as hombres,
       sum(m_menor25 + m_25_45 + m_mayor45) as mujeres
from datos
group by cod_mes
order by cod_mes
