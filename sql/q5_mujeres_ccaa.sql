-- % de mujeres dentro del paro por comunidad, de mayor a menor
select ccaa,
       sum(paro_total) as paro,
       round(sum(m_menor25 + m_25_45 + m_mayor45) * 100.0 /
             sum(h_menor25 + h_25_45 + h_mayor45 + m_menor25 + m_25_45 + m_mayor45), 1) as pct_mujeres
from paro
where cod_mes = 202512
group by ccaa
order by pct_mujeres desc
