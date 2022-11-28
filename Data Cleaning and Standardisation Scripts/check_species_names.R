#####################################
#        Check Species Names        #
#####################################

library(taxize)
library(tidyverse)

#####################################

# TAXONOMIC DATA SOURCES
sources <- gnr_datasources()
itis <- sources$id[sources$title == 'Integrated Taxonomic Information SystemITIS']
iucn <- sources$id[sources$title == 'IUCN Red List of Threatened Species']

#####################################

# FUNCTION

check_name <- function(species){
  species_checked <- data.frame(previousIdentification = character(),
                                scientificName = character(),
                                observation = character(), 
                                stringsAsFactors=FALSE)
  for(sp in species) {
    sp_check_itis <- gnr_resolve(sp, data_source_ids=itis, with_canonical_ranks = TRUE)
    if (nrow(sp_check_itis)==0){
      sp_check_iucn <- gnr_resolve(sp, data_source_ids=iucn, with_canonical_ranks = TRUE)
      if (nrow(sp_check_iucn)==0){
        sp_checked <- data.frame(previousIdentification = sp,
                                 scientificName = NA,
                                 observation = 'NOT FOUND in ITIS or IUCN', 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
      else if (nrow(sp_check_iucn)!=0 && sp!=sp_check_iucn$matched_name2){
        sp_checked <- data.frame(previousIdentification = sp,
                                 scientificName = sp_check_iucn$matched_name2,
                                 observation = 'Checked IUCN', 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
      else{
        sp_checked <- data.frame(previousIdentification = sp,
                                 scientificName = sp,
                                 observation = 'Ok IUCN', 
                                 stringsAsFactors=FALSE)
        species_checked <- rbind(species_checked, sp_checked)
      }
    } 
    else if (nrow(sp_check_itis)!=0 && sp!=sp_check_itis$matched_name2){
      sp_checked <- data.frame(previousIdentification = sp,
                               scientificName = sp_check_itis$matched_name2,
                               observation = 'Checked ITIS', 
                               stringsAsFactors=FALSE)
      species_checked <- rbind(species_checked, sp_checked)
    } 
    else {
      sp_checked <- data.frame(previousIdentification = sp,
                               scientificName = sp,
                               observation = 'Ok ITIS', 
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
canids_species_check <- check_name(canids)
canids_species_check

#   previousIdentification  scientificName  observation
# 1        Cerdocyon thous Cerdocyon thous      Ok ITIS
# 2         Cerdocyon thou Cerdocyon thous Checked ITIS
# 3         Aerdocyon thou Cerdocyon thous Checked ITIS

# 2) Data from table
mammals <- read_csv('tetrapodsSpeciesList.csv')
mammlas_species_check <- check_name(mammals$Species)
mammlas_species_check

#       previousIdentification            scientificName               observation
# 1         Mazama gouazoubira        Mazama gouazoubira                   Ok ITIS
# 2                  Axis axis                 Axis axis                   Ok ITIS
# 3                 Sus scrofa                Sus scrofa                   Ok ITIS
# 4            Cerdocyon thous           Cerdocyon thous                   Ok ITIS
# 5      Chrysocyon brachyurus     Chrysocyon brachyurus                   Ok ITIS
# 6      Lycalopex gymnocercus     Lycalopex gymnocercus                   Ok ITIS
# 7           Leopardus wiedii          Leopardus wiedii                   Ok ITIS
# 8        Leopardus braccatus       Leopardus braccatus                   Ok ITIS
# 9        Leopardus geoffroyi       Leopardus geoffroyi                   Ok ITIS
# 10         Puma yagouaroundi         Puma yagouaroundi                   Ok ITIS
# 11        Lontra longicaudis        Lontra longicaudis                   Ok ITIS
# 12          Conepatus chinga          Conepatus chinga                   Ok ITIS
# 13             Galictis cuja             Galictis cuja                   Ok ITIS
# 14       Procyon cancrivorus       Procyon cancrivorus                   Ok ITIS
# 15      Dasypus novemcinctus      Dasypus novemcinctus                   Ok ITIS
# 16     Euphractus sexcinctus     Euphractus sexcinctus                   Ok ITIS
# 17         Cabassous tatouay         Cabassous tatouay                   Ok ITIS
# 18     Didelphis albiventris     Didelphis albiventris                   Ok ITIS
# 19           Lepus europaeus           Lepus europaeus                   Ok ITIS
# 20            Cuniculus paca            Cuniculus paca                   Ok ITIS
# 21                No species                      <NA> NOT FOUND in ITIS or IUCN
# 22 Hydrochoerus hydrochaeris Hydrochoerus hydrochaeris                   Ok ITIS
# 23     Tamandua tetradactyla     Tamandua tetradactyla                   Ok ITIS
