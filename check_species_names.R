#####################################
#        Check Species Names        #
#####################################

library(taxize)
library(tidyverse)

#####################################

# TAXONOMIC DATA SOURCES
sources <- gnr_datasources()
itis <- sources$id[sources$title == 'ITIS']
iucn <- sources$id[sources$title == 'IUCN Red List of Threatened Species']

#####################################

# FUNCTION

check_name <- function(species){
  species_checked <- data.frame(Species = character(),
                                Observation = character(), 
                                stringsAsFactors=FALSE)
  for(sp in species) {
    sp_check_itis <- gnr_resolve(sp, data_source_ids=itis, with_canonical_ranks = TRUE)
    if (length(sp_check_itis)==0){
      sp_check_iucn <- gnr_resolve(sp, data_source_ids=iucn, with_canonical_ranks = TRUE)
      if (length(sp_check_iucn)==0){
        sp_checked <- data.frame(Species = sp,
                                 Observation = 'NOT FOUND in ITIS or IUCN', 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
      else if (length(sp_check_iucn)!=0 && sp!=sp_check_iucn$matched_name2){
        sp_checked <- data.frame(Species = sp_check_iucn$matched_name2,
                                 Observation = 'Checked IUCN', 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
      else{
        sp_checked <- data.frame(Species = sp,
                                 Observation = 'Ok IUCN', 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
    } 
    else if (length(sp_check_itis)!=0 && sp!=sp_check_itis$matched_name2){
      sp_checked <- data.frame(Species = sp_check_itis$matched_name2,
                               Observation = 'Checked ITIS', 
                               stringsAsFactors=FALSE)
      species_checked <- rbind(species_checked, sp_checked)
    } 
    else {
      sp_checked <- data.frame(Species = sp,
                               Observation = 'Ok ITIS', 
                               stringsAsFactors=FALSE)
      species_checked <- rbind(species_checked, sp_checked)
    }
  }
  return(species_checked)
}

#####################################
# RUN

# 1) Species List
canids <- c('Cerdocyon thous', 'Lycalopex gymnocercus', 'Chrysocyon brachyurus', 'Wrong species')
canids_species_check <- check_name(canids)

#                 Species               Observation
# 1       Cerdocyon thous                   Ok ITIS
# 2 Lycalopex gymnocercus                   Ok ITIS
# 3 Chrysocyon brachyurus                   Ok ITIS
# 4         Wrong species NOT FOUND in ITIS or IUCN

# 2) Data from table
mammals <- read_csv('speciesList.csv')
mammlas_species_check <- check_name(mammals$Species)

#                      Species               Observation
# 1         Mazama gouazoubira                   Ok ITIS
# 2                  Axis axis                   Ok ITIS
# 3                 Sus scrofa                   Ok ITIS
# 4            Cerdocyon thous                   Ok ITIS
# 5      Chrysocyon brachyurus                   Ok ITIS
# 6      Lycalopex gymnocercus                   Ok ITIS
# 7           Leopardus wiedii                   Ok ITIS
# 8        Leopardus braccatus                   Ok ITIS
# 9        Leopardus geoffroyi                   Ok ITIS
# 10         Puma yagouaroundi                   Ok ITIS
# 11        Lontra longicaudis                   Ok ITIS
# 12          Conepatus chinga                   Ok ITIS
# 13             Galictis cuja                   Ok ITIS
# 14       Procyon cancrivorus                   Ok ITIS
# 15      Dasypus novemcinctus                   Ok ITIS
# 16     Euphractus sexcinctus                   Ok ITIS
# 17         Cabassous tatouay                   Ok ITIS
# 18     Didelphis albiventris                   Ok ITIS
# 19           Lepus europaeus                   Ok ITIS
# 20            Cuniculus paca                   Ok ITIS
# 21                No species NOT FOUND in ITIS or IUCN
# 22 Hydrochoerus hydrochaeris                   Ok ITIS
# 23     Tamandua tetradactyla                   Ok ITIS
