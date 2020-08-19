
# rBiodiversidata

These are useful scripts for biodiversity data cleaning, processing and quality controlling.


## Tetrapod vertebrates

1.  [Check species names](#check-species-names). (DwC term: **scientificName**).
2.  [Get taxonomic information for a species](#get-taxonomic-information-for-a-species). (DwC terms: **kingdom**, **phylum**, **class**, **order**, **familiy**).
3.  [Get scientific name authorship for a species](#get-scientific-name-authorship-for-a-species). (DwC term: **scientificNameAuthorship**).
4.  [Get conservation status and population trend (IUCN)](#getting-conservation-status-and-population-trend-iucn).


## Plants

5.  [Check species names and get taxonomic information for a species](#check-species-names-and-get-taxonomic-information-for-a-species). (DwC term: **scientificName**, **genus**, **specificEpithet**, **infraspecificEpithet**, **scientificNameAuthorship**, **taxonRank**, **taxonID**).
6.  [Get higher rank taxonomic information for a     species](#get-higher-rank-taxonomic-information-for-a-species) (DwC terms: **kingdom**, **phylum**, **class**, **order**).
7.  [Get the state or province of the geographic location of a record](#get-the-state-or-province-of-the-geographic-location-of-a-record) (DwC term: **stateProvince**).
8.  [Update de event date of a record](#update-de-event-date-of-a-record) (DwC term: **eventDate**)


### Example data

- [tetrapodsSpeciesList.csv](tetrapodsSpeciesList.csv)  
- [plantSpeciesList.csv](plantSpeciesList.csv)  


---

## 1) Check species names

The script contains a function that takes a species list as input and returns a dataframe with two columns: Species Name and Observation. The run will return the result of the check for each species in the list, doing it first with ITIS database (Integrated Taxonomic Information System) and then with IUCN database (IUCN Red List of Threatened Species) case the species is not found in ITIS. If the species has a match in any of the databases, it will return the same Species Name and 'Ok ITIS' or 'Ok IUCN' as Observation. If the species has a match with any error of spelling, it will return the matched correct name in Species Name and 'Checked ITIS' or 'Checked IUCN' as Observation. If the species is not found in any of the databases, it will return 'NOT FOUND in ITIS or IUCN' as Observation.

> [check_species_names.R](check_species_names.R)

This script uses the function `gnr_resolve()` from the R package [**taxize**](https://github.com/ropensci/taxize).


## 2) Get taxonomic information for a species

The script contains a function that takes a species list as input and returns a dataframe with 6 columns: Species, Kingdom, Phylum, Class, Order and Family. The run will retrieve the taxonomic hierarchy for each species in the list, queried in ITIS database. If the species is not found in the database a 'NOT FOUND' warning will be printed in the console.

> [retrieve_taxonomy.R](retrieve_taxonomy.R)

This script uses the function `classification()` from the R package [**taxize**](https://github.com/ropensci/taxize).


## 3) Get scientific name authorship for a species

The script contains a function that takes a species list as input and returns a dataframe with 2 columns: Species and Authorship. The run will retrieve the scientific name authorship for each species in the list by querying the scientific name in the ITIS database. If the species name is not found in the database a 'NOT FOUND' will be retrieved as Authorship. As well, if the species name has a low match in the search (i.e.: only the genus authorship is found but not the genus and specific epithet), 'NOT FOUND' will be retrieved as Authorship.

> [get_scientificNameAuthorship.R](get_scientificNameAuthorship.R)

This script uses the function `gnr_resolve()` from the R package [**taxize**](https://github.com/ropensci/taxize).


## 4) Getting conservation status and population trend (IUCN)

The script contains a function that takes a species list as input and returns a dataframe with 3 columns containing Species Name, Conservation Status and Popultaion Trend, according to the IUCN Red List. The run will return the result of the search for each species in the list, printing in the console screen a 'CHECK' warning when the species name is not found in the Red List search. This may happen for two reasons, either the species has not been assessed by the IUCN or the species name needs to be checked. To check species name, see [Checking Species Names](#2-checking-species-names).

> [retrieve_IUCN_data.R](retrieve_IUCN_data.R)

This script uses the `rl_search()` function from the [**rredlist**](https://CRAN.R-project.org/package=rredlist) package and works with the IUCN Red List API.

- To use the API:
  1. Create a token http://apiv3.iucnredlist.org/api/v3/token
  2. Once you receive the token create an environmental variable in your system. It should be named **IUCN_REDLIST_KEY**. See https://www.java.com/en/download/help/path.xml for more information. 

---

## 5) Check species names and get taxonomic information for a species

The script checks a list of species against the World Flora Online (WFO) taxonomic backbone and returns a dataframe with the columns: previousIdentification, scientificName, scientificNameAuthorship, family, genus, specificEpithet, infraspecificEpithet, taxonRank, and taxonID. As parameters it uses a maximum number of fuzzy matches of 15, limits the matching of names to those with the most similar length of characters (to eliminate matches at infraspecific levels), and excludes infraespecific levels of: cultivars, sect., subf., subg. and subvar. 

> [check_species_names_and_get_taxonomic_info.R](check_species_names_and_get_taxonomic_info.R)

This script uses the function `WFO.match()` and `WFO.one` from the R package [**WorldFlora**](https://cran.r-project.org/package=WorldFlora). The user needs to first download a static copy of the Taxonomic Backbone data from http://www.worldfloraonline.org/downloadData.


## 6) Get higher rank taxonomic information for a species  

This script has the same basis of [Get taxonomic information for a species](#get-taxonomic-information-for-a-species). 
The script contains a function that takes a species list as input and returns a dataframe with 6 columns: scientificName, kingdom, phylum, class and order. The run will retrieve the taxonomic hierarchy for each species in the list, queried in ITIS database. If the species is not found in the database a 'NOT FOUND' warning will be printed in the console and all values for the species will be *NA*.

> [get_plant_taxonomic_info.R](get_plant_taxonomic_info.R)

This script uses the function `classification()` from the R package [**taxize**](https://github.com/ropensci/taxize).


## 7) Get the state or province of the geographic location of a record  

The script contains a function that takes latitude and longitude geographic coordinates and returns a stateProvince column with the country administrative subdivision.  As parameters it uses a maximum search radius of 1km and returns only the first match. 

> [get_state_province.R](get_state_province.R)

This script uses the function `GNcountrySubdivision()` from the R package [**geonames**](https://cran.r-project.org/web/packages/geonames/).

- To use the API:
  1. Create a user at https://www.geonames.org/login
  2. Use it options(geonamesUsername="YOUR-USER-NAME")


## 8) Update de event date of a record  

The script contains a function that takes day, month and year fields and returns an eventDate column with the format YYYY-MM-DD. If only the year is known eventDate will be represented as YYYY, and if only the year and month are known, as YYYY-MM.

> [get_event_date.R](get_event_date.R)

<br>

#### Code used for the [Biodiversidata](https://biodiversidata.org) Project. For more information about Biodiversidata, contact [Florencia Grattarola](mailto:flograttarola@gmail.com)
