#####################################
# Code to Check species names. (DwC term: scientificName).
# Author: Florencia Grattarola
# Date (updated): 2022-12-07

# Description: The script contains a function that takes a species list as input and returns a dataframe with two columns: Species Name and Observation. The run will return the result of the check for each species in the list, doing it first with ITIS database (Integrated Taxonomic Information System) and then with IUCN database (IUCN Red List of Threatened Species) case the species is not found in ITIS. If the species has a match in any of the databases, it will return the same Species Name and 'Ok ITIS' or 'Ok IUCN' as Observation. If the species has a match with any error of spelling, it will return the matched correct name in Species Name and 'Checked ITIS' or 'Checked IUCN' as Observation. If the species is not found in any of the databases, it will return 'NOT FOUND in ITIS or IUCN' as Observation.

#####################################
# LIBRARIES

library(taxize)
library(tidyverse)

#####################################
# TAXONOMIC DATA SOURCES

gnrsources <- gnr_datasources()

name_source_1 <-'Integrated Taxonomic Information SystemITIS'
id_source_1 <- gnrsources$id[gnrsources$title == name_source_1]

name_source_2 <-'IUCN Red List of Threatened Species'
id_source_2 <- gnrsources$id[gnrsources$title == name_source_2]

sources <- data.frame(source= c(1,2), 
                      name=c(name_source_1, name_source_2), 
                      id=c(id_source_1, id_source_2))

#####################################
# FUNCTION

check_name <- function(species, sources){
  species_checked <- data.frame(previousIdentification = character(),
                                scientificName = character(),
                                observation = character(), 
                                stringsAsFactors=FALSE)
  for(sp in species) {
    cat(sp, '\n')
    sp_check_1 <- gnr_resolve(sp, data_source_ids=sources$id[1], with_canonical_ranks = TRUE)
    if (nrow(sp_check_1)==0){
      sp_check_2 <- gnr_resolve(sp, data_source_ids=sources$id[2], with_canonical_ranks = TRUE)
      if (nrow(sp_check_2)==0){
        sp_checked <- data.frame(previousIdentification = sp,
                                 scientificName = NA,
                                 observation = str_glue('NOT FOUND in {sources$name[1]} or {sources$name[2]}'), 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
      else if (nrow(sp_check_2)!=0 && sp!=sp_check_2$matched_name2[1]){
        sp_checked <- data.frame(previousIdentification = sp,
                                 scientificName = sp_check_2$matched_name2[1],
                                 observation = str_glue('Updated according to {sources$name[2]}'), 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
      else{
        sp_checked <- data.frame(previousIdentification = sp,
                                 scientificName = sp,
                                 observation = str_glue('Ok ({sources$name[2]})'), 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
    } 
    else if (nrow(sp_check_1)!=0 && sp!=sp_check_1$matched_name2[1]){
      sp_checked <- data.frame(previousIdentification = sp,
                               scientificName = sp_check_1$matched_name2[1],
                               observation = str_glue('Updated according to {sources$name[1]}'), 
                               stringsAsFactors=FALSE)
      species_checked <- rbind(species_checked, sp_checked)
    } 
    else {
      sp_checked <- data.frame(previousIdentification = sp,
                               scientificName = sp,
                               observation = str_glue('Ok ({sources$name[1]})'), 
                               stringsAsFactors=FALSE)
      species_checked <- rbind(species_checked, sp_checked)
    }
  }
  return(species_checked)
}

#####################################
# RUN

# 1) Species List
canids <- c('Cerdocyon thous', 'Cerdocyon thou', 'Aerdocyon thou')
canids_species_check <- check_name(canids, sources)
canids_species_check

#   previousIdentification  scientificName                                                      observation
# 1        Cerdocyon thous Cerdocyon thous                 Ok (Integrated Taxonomic Information SystemITIS)
# 2         Cerdocyon thou Cerdocyon thous Updated according to Integrated Taxonomic Information SystemITIS
# 3         Aerdocyon thou Cerdocyon thous Updated according to Integrated Taxonomic Information SystemITIS

# 2) Data from table
mammals <- read_csv('tetrapodsSpeciesList.csv')
mammlas_species_check <- check_name(mammals$Species)
mammlas_species_check


#       previousIdentification            scientificName                                                                                     observation
# 1         Mazama gouazoubira        Mazama gouazoubira                                                Ok (Integrated Taxonomic Information SystemITIS)
# 2                  Axis axis                 Axis axis                                                Ok (Integrated Taxonomic Information SystemITIS)
# 3                 Sus scrofa                Sus scrofa                                                Ok (Integrated Taxonomic Information SystemITIS)
# 4            Cerdocyon thous           Cerdocyon thous                                                Ok (Integrated Taxonomic Information SystemITIS)
# 5      Chrysocyon brachyurus     Chrysocyon brachyurus                                                Ok (Integrated Taxonomic Information SystemITIS)
# 6      Lycalopex gymnocercus     Lycalopex gymnocercus                                                Ok (Integrated Taxonomic Information SystemITIS)
# 7           Leopardus wiedii          Leopardus wiedii                                                Ok (Integrated Taxonomic Information SystemITIS)
# 8        Leopardus braccatus       Leopardus braccatus                                                Ok (Integrated Taxonomic Information SystemITIS)
# 9        Leopardus geoffroyi       Leopardus geoffroyi                                                Ok (Integrated Taxonomic Information SystemITIS)
# 10         Puma yagouaroundi         Puma yagouaroundi                                                Ok (Integrated Taxonomic Information SystemITIS)
# 11        Lontra longicaudis        Lontra longicaudis                                                Ok (Integrated Taxonomic Information SystemITIS)
# 12          Conepatus chinga          Conepatus chinga                                                Ok (Integrated Taxonomic Information SystemITIS)
# 13             Galictis cuja             Galictis cuja                                                Ok (Integrated Taxonomic Information SystemITIS)
# 14       Procyon cancrivorus       Procyon cancrivorus                                                Ok (Integrated Taxonomic Information SystemITIS)
# 15      Dasypus novemcinctus      Dasypus novemcinctus                                                Ok (Integrated Taxonomic Information SystemITIS)
# 16     Euphractus sexcinctus     Euphractus sexcinctus                                                Ok (Integrated Taxonomic Information SystemITIS)
# 17         Cabassous tatouay         Cabassous tatouay                                                Ok (Integrated Taxonomic Information SystemITIS)
# 18     Didelphis albiventris     Didelphis albiventris                                                Ok (Integrated Taxonomic Information SystemITIS)
# 19           Lepus europaeus           Lepus europaeus                                                Ok (Integrated Taxonomic Information SystemITIS)
# 20            Cuniculus paca            Cuniculus paca                                                Ok (Integrated Taxonomic Information SystemITIS)
# 21                No species                      <NA> NOT FOUND in Integrated Taxonomic Information SystemITIS or IUCN Red List of Threatened Species
# 22 Hydrochoerus hydrochaeris Hydrochoerus hydrochaeris                                                Ok (Integrated Taxonomic Information SystemITIS)
# 23     Tamandua tetradactyla     Tamandua tetradactyla                                                Ok (Integrated Taxonomic Information SystemITIS)
