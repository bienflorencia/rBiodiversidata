# rBiodiversidata
Code for Biodiversidata Project.
Useful scripts for biodiversity data cleaning.

**Example data** [speciesList.csv](speciesList.csv)

## Retrieving Conservation Status and Population Trend (IUCN)

- [retrieve_IUCN_data.R](retrieve_IUCN_data.R)

The script contains a function that takes a species list as input and returns a dataframe with 3 columns: Species Name, Conservation Status and Popultaion Trend according to the IUCN Red List. During the run the code will show the result of the search for each species in the list, returning a 'CHECK' warning when the species name is not found in the Red List search. This may happen for two reasons, either the species has not been assessed by the IUCN or the species name needs to be checked. 

This scripts uses the R package [rredlist](https://CRAN.R-project.org/package=rredlist) and works with the IUCN Red List API.

*Note*
To use the API:
- Create a token http://apiv3.iucnredlist.org/api/v3/token
- Once you receive the token create an environmental variable in your system. It should be named IUCN_REDLIST_KEY. See https://www.java.com/en/download/help/path.xml 


## Checking Species Names and Retrieving Taxonomic Information

- [update_taxonomy.R](update_taxonomy.R)

The script contains a function that...

This scripts uses the R package [taxize](https://github.com/ropensci/taxize).



