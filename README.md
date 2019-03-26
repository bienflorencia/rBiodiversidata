# rBiodiversidata
### Code for Biodiversidata Project.

This are useful scripts for biodiversity data cleaning, processing and quality controlling.

1. Retrieving Conservation Status and Population Trend (IUCN).
2. Checking Species Names.
3. Retrieving Taxonomic Information for a Species.


For each of the scripts, example runs have been provided.
**Example data:**
- [speciesList.csv](speciesList.csv)


## 1) Retrieving Conservation Status and Population Trend (IUCN)

The script contains a function that takes a species list as input and returns a dataframe with 3 columns containing Species Name, Conservation Status and Popultaion Trend, according to the IUCN Red List. The run will return the result of the search for each species in the list, printing the result also in the console screen and a 'CHECK' warning when the species name is not found in the Red List search. This may happen for two reasons, either the species has not been assessed by the IUCN or the species name needs to be checked. To check species name, see [Checking Species Names](#checking-species-names).

> [retrieve_IUCN_data.R](retrieve_IUCN_data.R)

<br>

*Note*
- This script uses the rl_search() from the [rredlist](https://CRAN.R-project.org/package=rredlist) package and works with the IUCN Red List API.
- To use the API:
  1. Create a token http://apiv3.iucnredlist.org/api/v3/token
  2. Once you receive the token create an environmental variable in your system. It should be named **IUCN_REDLIST_KEY**. See https://www.java.com/en/download/help/path.xml 


## 2) Checking Species Names 

The script contains a function that...

> [check_species_names.R](check_species_names.R)

This script uses the R package [taxize](https://github.com/ropensci/taxize).


## 3) Retrieving Taxonomic Information for a Species

The script contains a function that...

> [retrieve_taxonomy.R](retrieve_taxonomy.R)

This script uses the R package [taxize](https://github.com/ropensci/taxize).


