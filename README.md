# Del dato crudo a la decisión

Proyecto para clase: coger datos públicos, limpiarlos, consultarlos con SQL, analizarlos con Python, hacer gráficos y sacar una conclusión. El análisis completo está en `entregable.ipynb`.

## Cómo ejecutarlo

```bash
git clone https://github.com/renzorico/del-dato-crudo-a-la-decision.git
cd del-dato-crudo-a-la-decision
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
jupyter notebook entregable.ipynb
```

Hace falta Python 3.12. No hay variables de entorno.

## Estructura

| Ruta | Contenido |
|---|---|
| `entregable.ipynb` | Todo el análisis |
| `data/raw/` | Datos originales sin tocar |
| `data/processed/` | Datos ya limpios y unidos |
| `sql/` | Esquema y consultas |
| `img/` | Gráficos |

## Los datos

Son dos ficheros de 2025, descargados el 11 de octubre de 2026 y guardados tal cual en `data/raw/`.

**Paro registrado por municipios** (SEPE, `Paro_por_municipios_2025_csv.csv`). 97.620 filas y 20 columnas: 12 meses por 8.135 municipios. Cada fila es un municipio en un mes. Columnas: mes, comunidad, provincia, municipio (con códigos), total de parados y el paro separado por sexo y tramo de edad (<25, 25-45, >=45) y por sector (agricultura, industria, construcción, servicios, sin empleo anterior). Los valores menores de 5 vienen como `<5`.

**Población por municipios** (INE, `ine_29005_poblacion_municipios_2025.csv`). 8.138 filas, una por municipio, con la población de 2025. La descarga completa del INE tenía todos los años (26 MB), así que dejo solo la copia recortada a 2025.

Licencia: son datos públicos de organismos del Estado. La reutilización está permitida citando la fuente (Ley 37/2007 de reutilización de la información del sector público; el INE pide citar "Elaboración propia con datos extraídos del sitio web del INE"). Fuentes: SEPE (Servicio Público de Empleo Estatal) e INE, en su portal de datos abiertos.

La unidad de análisis es el municipio. Se unen por el código de municipio y el resultado está en `data/processed/paro_poblacion_2025.csv`.

## Preguntas

Principal: qué comunidades y municipios tienen más paro registrado en relación con su población.

Secundarias:
1. Cómo evoluciona el paro durante 2025
2. Hay diferencia entre hombres y mujeres
3. Influye el tamaño del municipio

## Limpieza

- Había espacios sueltos en los nombres de columnas.
- El SEPE pone `<5` cuando hay muy pocos parados, así que esas columnas se leían como texto. Lo cambié por 2.
- En el INE el código y el nombre vienen juntos (`44001 Ababuj`), los separé.
- Seis municipios del INE sin población, rellenados con la mediana. No cruzan con el paro.
- No hay duplicados y los 8.135 municipios del SEPE cruzan con el INE.
- Antes y después: el paro pasa de 97.620 x 20 a 97.620 x 19, y entre el 20% y el 31% de las celdas de paro eran `<5` (ahora todo es numérico). No quité outliers, son pueblos pequeños reales.
- Lo que se pierde: el valor real de los `<5` (es una aproximación) y los municipios pequeños salen más ruidosos.

## SQL

Uso duckdb. El esquema de las tablas está en `sql/esquema.sql` y hay cinco consultas en `sql/`, cada una con una frase en el notebook que explica qué responde y qué se ve:

1. `q1_ccaa.sql`: tasa de paro por comunidad (group by).
2. `q2_municipios.sql`: municipios grandes con más paro (where, order by, limit).
3. `q3_mensual.sql`: evolución mensual por sexo.
4. `q4_provincias_join.sql`: provincias grandes con más paro, cruzando las tablas `paro` y `poblacion` (join, having).
5. `q5_mujeres_ccaa.sql`: % de mujeres en el paro por comunidad.

La primera la comprobé también con pandas.

## Resultados

En diciembre de 2025 hay 2,41 millones de parados registrados, 4,9 por 100 habitantes, un 7% menos que en enero. Lo más alto está en Ceuta, Melilla, Andalucía y Canarias, y entre los municipios grandes en Cádiz y Sevilla. Las mujeres son el 60% del paro. Comparando pueblos de menos de 5.000 habitantes con ciudades de 20.000 o más, la mediana es 3,4 contra 4,9, pero eso no quiere decir que el tamaño cause el paro. Las conclusiones, la recomendación y las limitaciones están en el notebook.

![tasa por comunidad](img/tasa_ccaa.png)

## Guía didáctica

**Qué hace el código, paso a paso.** Carga los dos CSV, los limpia (espacios, `<5`, código y nombre del INE), los une por código de municipio, calcula parados por 100 habitantes, hace cinco consultas SQL en duckdb, hace un análisis con pandas (descripción, outliers, comparación de grupos con Mann-Whitney) y dibuja los gráficos.

**Qué aprendería la persona estudiante.** Que los datos reales vienen sucios y hay que decidir qué hacer con los huecos (el `<5`, los NaN) y que esa decisión cambia el resultado. Que una tasa depende de entre qué divides. Que SQL y pandas dan lo mismo. Y a no confundir una diferencia significativa con una diferencia importante, ni correlación con causa.

**Cómo usarlo en clase.** Una sesión de unos 90 minutos:
1. 10 min: mirar los CSV en bruto y preguntar qué problemas ven antes de ejecutar nada.
2. 25 min: limpieza en parejas, sobre todo decidir qué hacer con `<5`.
3. 25 min: SQL, que escriban ellos al menos una consulta con group by y otra con join.
4. 20 min: gráficos y la comparación de grupos, con discusión de si la diferencia importa.
5. 10 min: cada grupo dice una conclusión y una recomendación y hablamos de sesgos y ética.

**Qué puede salir mal y cómo solucionarlo.**
- Rutas: el notebook asume que se abre desde la carpeta del repo (`data/raw/...`). Si da `FileNotFoundError`, abrirlo desde ahí.
- Versiones: usar Python 3.12 y las versiones de `requirements.txt`. Con otras versiones de pandas puede cambiar el comportamiento.
- Error al leer el CSV del SEPE: usar `encoding='latin-1'`, y saltar la primera fila (`skiprows=1`) porque tiene un título.
- Se pierde el cero de los códigos (`04001` pasa a `4001`): leer con `dtype={'Codigo Municipio': str}`.
- Los números del INE llevan punto de miles: `thousands='.'`.
- Si el cruce da NaN, mirar que los códigos sean texto en los dos lados.
- En SQL: columnas que se leen como texto por el `<5` y no se pueden sumar; hay que convertirlas antes de cargarlas. Y si el CSV no tuviera cabecera, hay que pasar `header=None` y poner los nombres a mano.

**Adaptaciones por nivel y ritmo.** Sin experiencia: empezar directamente con `data/processed/`, leer los gráficos y hacer solo las consultas Q1 y Q2. Ritmo lento: dividirlo en dos sesiones, limpieza + SQL y luego análisis + conclusiones. Nivel alto: pedirles que calculen la tasa sobre población en edad de trabajar, que traten los `<5` de otra forma (0, 4, aleatorio) y comparen, o que repitan el análisis con otros años.
