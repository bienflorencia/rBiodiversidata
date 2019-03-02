# rBiodiversidata
Code for Biodiversidata Project.
Useful scripts for biodiversity data cleaning.

**Example data** [speciesList.csv](speciesList.csv)

## Retrieving Conservation Status and Population Trend (IUCN)

The script contains a function that takes a species list as input and returns a dataframe with 3 columns, Species Name, Conservation Status and Popultaion Trend, according to the IUCN Red List. The run will return the result of the search for each species in the list, printing the result also in the console screen and a 'CHECK' warning when the species name is not found in the Red List search. This may happen for two reasons, either the species has not been assessed by the IUCN or the species name needs to be checked. To check species name, see the next function.

- [retrieve_IUCN_data.R](retrieve_IUCN_data.R)

This script uses the rl_search() from the [rredlist](https://CRAN.R-project.org/package=rredlist) package and works with the IUCN Red List API.

*Note*
To use the API:
1. Create a token http://apiv3.iucnredlist.org/api/v3/token
2. Once you receive the token create an environmental variable in your system. It should be named IUCN_REDLIST_KEY. See https://www.java.com/en/download/help/path.xml 


## Checking Species Names and Retrieving Taxonomic Information

The script contains a function that...

- [update_taxonomy.R](update_taxonomy.R)

This script uses the R package [taxize](https://github.com/ropensci/taxize).



