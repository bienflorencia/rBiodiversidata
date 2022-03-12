# Basic Metadata

**Title**: Es el título que va a aparecer en la web de GBIF
**Publishing organization**: Biodiversidata
**Type**: Occurrence
**Metadata Language**: Spanish
**Data Language**: Spanish
**Data Licence**: Creative Commons Attribution (CC-BY) 4.0

**Description**:
==*Una breve descripción del recurso con suficiente información para ayudar a los potenciales usuarios de los datos a comprender si pueden ser de su interés.*==

**Contacts**
La lista de personas y organizaciones que deben contactarse para obtener más información sobre el recurso
•	Name
•	Surname
•	Position ==*(ejemplos: Director, Asistente, Colaborador, Investigadora)*==
•	Organisation
•	City/Country
•	Email
•	Home Page
•	ORCID

Resource Creators
Las personas y organizaciones que crearon el recurso, en orden de prioridad. La lista se usará para generar automáticamente la cita de recursos

Metadata Providers
Las personas y organizaciones responsables de producir los metadatos del recurso.

Geographic Coverage

South/West & North/East: Las esquinas SW y NE del cuadro que delimitan el área cubierta por el recurso.

Description:
Una descripción textual de la cobertura geográfica.

Taxonomic Coverage

Description: Descripción textual del rango de taxones representados en el recurso.

Scientific Name |Common Name | Rank:
Tabla que se completa con el grupo de taxones cubiertos por el recurso.
Por ejemplo: Tracheophyta | Plantas Vasculares | Phylum

Temporal Coverage

Temporal Coverage Type: Date Range
Start Date: Fecha de inicio. Primer registro en el conjunto de datos.
End Date: Fecha final. Último registro en el conjunto de datos.


Keywords

Thesaurus/Vocabulary: Tesauro o vocabulario controlado del que se derivan las palabras clave. Si no hubiera uno se pone ‘N/A’
Keyword List: Lista de palabras clave separadas por coma


Associated Parties

Copy details from resource contact: Son los datos de las personas de contacto. Se pueden copiar de la sección básica de metadatos.
Role: Menú de selección que contiene una lista de posibles roles que la parte asociada podría tener en relación con el recurso.

Project Data

Title: El título del proyecto que da origen a los datos.
Identifier: Un identificador único para el proyecto.
Description: Un resumen sobre el proyecto de investigación.
Funding:
Study Area Description:
Design Description:
Project Personnel:
•	First Name:
•	Last Name:
•	Directory: ORCID, ResearchID, LinkedIn, o Google Scholar.
•	Identifier: Identificador para el ‘Directory’ elegido.
•	Role:

Sampling Methods

Study Extent: Una descripción de las condiciones físicas y temporales bajo las cuales ocurrió el muestreo. Ejemplo: 13 localidades a lo largo del departamento de Maldonado, en el período entre setiembre y octubre de 2013.

Sampling Description: Una descripción de los procedimientos de muestreo utilizados en el proyecto de investigación.
Quality Control: Chequeos que se realizaron.
Se chequearon errores en los nombres científicos, localización geográfica y fechas. Se agregaron datos sobre la autoría de los nombres científicos de las especies y se completaron los rangos taxonómicos desde Reino hasta el rango infraespecífico, se incluyó el término de rango taxonómico según el nivel de detalle de la especie. Se asignó a cada registro el nivel administrativo de Estado/Provincia y se incorporaron datos sobre la incertidumbre y precisión de la localización geográfica. El código de R utilizado para la limpieza de datos está disponible en nuestro repositorio de GitHub (https://github.com/bienflorencia/rBiodiversidata).

Step Description: Pasos detallados del proceso de chequeo de calidad
1.	Chequeo de nombres científicos. Verificación de errores ortográficos de nombres científicos usando los paquetes de R 'taxize' (Chamberlain et al. 2020) y 'WorldFlora' (Kindt 2020). Para verificar los nombres de especies, primero contrastamos la lista de nombres de especies con la referencia taxonómica de World Flora Online (WFO) (http://www.worldfloraonline.org/), si la especie o su sinónimo sugeridos por WFO fueron aceptados en Darwinion (http://www.darwin.edu.ar) (Zuloaga et al. 2019), conservamos el nombre y la identificación de taxón de WFO, de lo contrario, utilizamos el nombre de Darwinion y buscamos una identificación en Tropicos (https://www.tropicos.org/). El nombre original de la especie se mantuvo bajo el término "previousIdentifications". La lista final de nombres científicos fue verificada por los expertos en plantas de Biodiversidata.
2.	Recuperación completa de rangos taxonómicos superiores, inclusión del término de rango infraespecífico y la autoridad taxonómica para los nombres científicos
3.	Incorporación del término "establishmentMeans", que clasifica las especies como nativas o introducidas (Groom et al. 2019).
4.	Verificación de errores o valores atípicos o inexactos en la localización geográfica. Incorporación de los campos de incertidumbre y precisión para los valores de latitud y longitud proporcionados.
5.	Identificación del estado/provincia geográfica a través de la base de datos del GeoNames Gazetteer utilizando el paquete R 'geonames' (Rowlingson 2019). Inclusión de términos estándares para los rangos geográficos más altos que el nivel de localidad (continente y país).
6.	Incorporación del estado de conservación de las especies de acuerdo con la evaluación global de la Lista Roja de la UICN, utilizando el paquete R 'rredlist' (Chamberlain 2020).

Citations

Resource Citation
La dejamos en autogenerada. Va a tomar los/as autores de la sección ‘Resource Creators’.

Bibliographic Citations
•	Bibliographic Citation: Cita usada como referencia a lo largo del texto de metadatos.
•	Bibliographic Citation Identifier: DOI, URI u otro identificador persistente que direcciona al recurso externo en línea.

Collection Data
Si hubiera datos depositados en colecciones, se mencionan aquí.

Collection Name: Ejemplo: Colección Zoología Vertebrados de la Facultad de Ciencias.

Collection Identifier: Código que identifica a la colección. Ejemplo: ZVCB

Parent Collection Identifier: Ejemplo: FCIEN

External Links

Resource Homepage: https://biodiversidata.org/

Additional Metadata

Additional Information
Este recurso fue creado en el marco de la iniciativa Biodiversidata (Consorcio de Datos de Biodiversidad del Uruguay). Biodiversidata es una asociación colaborativa de expertos con el objetivo de reunir una base de datos en constante crecimiento para la biodiversidad de Uruguay. Fue creado en 2018 por Florencia Grattarola como parte de su proyecto de doctorado. Su plataforma de acceso abierto (https://biodiversidata.org/) tiene como objetivo poner a disposición los datos de biodiversidad de Uruguay mediante la integración de una amplia gama de recursos que incluyen bases de datos, publicaciones, mapas, informes e infografías, derivados del trabajo de los miembros del equipo.
