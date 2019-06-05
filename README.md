

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3093998.svg)](https://doi.org/10.5281/zenodo.3093998)



# rBiodiversidata
### Code used for the [Biodiversidata](biodiversidata.org) Project.

This are useful scripts for biodiversity data cleaning, processing and quality controlling.

1. Retrieving Conservation Status and Population Trend (IUCN).
2. Checking Species Names.
3. Retrieving Taxonomic Information for a Species.
4. Get Scientific Name Authorship for a Species


For each of the scripts, example runs have been provided.
**Example data:**
- [speciesList.csv](speciesList.csv)


## 1) Retrieving Conservation Status and Population Trend (IUCN)

The script contains a function that takes a species list as input and returns a dataframe with 3 columns containing Species Name, Conservation Status and Popultaion Trend, according to the IUCN Red List. The run will return the result of the search for each species in the list, printing in the console screen a 'CHECK' warning when the species name is not found in the Red List search. This may happen for two reasons, either the species has not been assessed by the IUCN or the species name needs to be checked. To check species name, see [Checking Species Names](#2-checking-species-names).

> [retrieve_IUCN_data.R](retrieve_IUCN_data.R)

This script uses the rl_search() function from the [rredlist](https://CRAN.R-project.org/package=rredlist) package and works with the IUCN Red List API.

- To use the API:
  1. Create a token http://apiv3.iucnredlist.org/api/v3/token
  2. Once you receive the token create an environmental variable in your system. It should be named **IUCN_REDLIST_KEY**. See https://www.java.com/en/download/help/path.xml for more information. 


## 2) Checking Species Names 

The script contains a function that takes a species list as input and returns a dataframe with two columns: Species Name and Observation. The run will return the result of the check for each species in the list, doing it first with ITIS database (Integrated Taxonomic Information System) and then with IUCN database (IUCN Red List of Threatened Species) case the species is not found in ITIS. If the species has a match in any of the databases, it will return the same Species Name and 'Ok ITIS' or 'Ok IUCN' as Observation. If the species has a match with any error of spelling, it will return the matched correct name in Species Name and 'Checked ITIS' or 'Checked IUCN' as Observation. If the species is not found in any of the databases, it will return 'NOT FOUND in ITIS or IUCN' as Observation.

> [check_species_names.R](check_species_names.R)

This script uses the function gnr_resolve() from the R package [taxize](https://github.com/ropensci/taxize).


## 3) Retrieving Taxonomic Information for a Species

The script contains a function that takes a species list as input and returns a dataframe with 6 columns: Species, Kingdom, Phylum, Class, Order and Family. The run will retrieve the taxonomic hierarchy for each species in the list, queried in ITIS database. If the species is not found in the database a 'NOT FOUND' warning will be printed in the console.

> [retrieve_taxonomy.R](retrieve_taxonomy.R)

This script uses the function classification() from the R package [taxize](https://github.com/ropensci/taxize).


## 4) Get Scientific Name Authorship for a Species

The script contains a function that takes a species list as input and returns a dataframe with 2 columns: Species and Authorship. The run will retrieve the scientific name authorship for each species in the list by querying the scientific name in the ITIS database. If the species name is not found in the database a 'NOT FOUND' will be retrieved as Authorship. As well, if the species name has a low match in the search (i.e.: only the genus authorship is found but not the genus and specific epithet), 'NOT FOUND' will be retrieved as Authorship.

> [get_scientificNameAuthorship.R](get_scientificNameAuthorship.R)

This script uses the function gnr_resolve() from the R package [taxize](https://github.com/ropensci/taxize).

<br>

### For more information about Biodiversidata, contact [Florencia Grattarola](mailto:flograttarola@gmail.com)
