#####################################
# Retrieve Taxonomic Classification #
#####################################

library(taxize)
library(tidyverse)

#####################################
# FUNCTION

get_classification <- function(species){
  species_classif <- data.frame(Species = character(),
                                Kingdom = character(),
                                Phylum = character(),
                                Class = character(),
                                Order = character(),
                                Family = character(), stringsAsFactors=FALSE)
  for(sp in species) {
    sp_classif <- classification(get_tsn(sp, rows=1), db='itis', start=1)
    if (length(sp_classif[[1]])!=3){
      species_classif_sp <- data.frame(Species = sp,
                                       Kingdom = 'NA',
                                       Phylum = 'NA',
                                       Class = 'NA',
                                       Order = 'NA',
                                       Family = 'NA', stringsAsFactors=FALSE)
      species_classif <- rbind(species_classif, species_classif_sp)
      cat(sp, ': NOT FOUND \n')
    } 
    else {
      species_classif_sp <- data.frame(Species = sp_classif[[1]]$name[sp_classif[[1]]$rank=='species'],
                                       Kingdom = sp_classif[[1]]$name[sp_classif[[1]]$rank=='kingdom'],
                                       Phylum = sp_classif[[1]]$name[sp_classif[[1]]$rank=='phylum'],
                                       Class = sp_classif[[1]]$name[sp_classif[[1]]$rank=='class'],
                                       Order = sp_classif[[1]]$name[sp_classif[[1]]$rank=='order'],
                                       Family = sp_classif[[1]]$name[sp_classif[[1]]$rank=='family'],
                                       stringsAsFactors=FALSE)
      species_classif <- rbind(species_classif, species_classif_sp)
    }
  }
  return(species_classif)
}

#####################################
# RUN

canids <- c('Cerdocyon thous', 'Lycalopex gymnocercus', 'Chrysocyon brachyurus', 'Wrong species')
canids_classification <- get_classification(canids)

## The fuction will print in console
# Retrieving data for taxon 
# (...)
# Wrong species : NOT FOUND 

#                 Species  Kingdom   Phylum    Class     Order Familiy
# 1       Cerdocyon thous Animalia Chordata Mammalia Carnivora Canidae
# 2 Lycalopex gymnocercus Animalia Chordata Mammalia Carnivora Canidae
# 3 Chrysocyon brachyurus Animalia Chordata Mammalia Carnivora Canidae
# 4         Wrong species       NA       NA       NA        NA      NA


# 2) Data from table
mammals <- read_csv('speciesList.csv')
mammlas_classification <- get_classification(mammals$Species)

## The fuction will print in console
# Retrieving data for taxon 
# (...)
# No species : NOT FOUND

#                      Species  Kingdom   Phylum    Class           Order         Familiy
# 1         Mazama gouazoubira Animalia Chordata Mammalia    Artiodactyla        Cervidae
# 2                  Axis axis Animalia Chordata Mammalia    Artiodactyla        Cervidae
# 3                 Sus scrofa Animalia Chordata Mammalia    Artiodactyla          Suidae
# 4            Cerdocyon thous Animalia Chordata Mammalia       Carnivora         Canidae
# 5      Chrysocyon brachyurus Animalia Chordata Mammalia       Carnivora         Canidae
# 6      Lycalopex gymnocercus Animalia Chordata Mammalia       Carnivora         Canidae
# 7        Leopardus braccatus Animalia Chordata Mammalia       Carnivora         Felidae
# 8        Leopardus geoffroyi Animalia Chordata Mammalia       Carnivora         Felidae
# 9          Puma yagouaroundi Animalia Chordata Mammalia       Carnivora         Felidae
# 10        Lontra longicaudis Animalia Chordata Mammalia       Carnivora      Mustelidae
# 11          Conepatus chinga Animalia Chordata Mammalia       Carnivora      Mephitidae
# 12             Galictis cuja Animalia Chordata Mammalia       Carnivora      Mustelidae
# 13       Procyon cancrivorus Animalia Chordata Mammalia       Carnivora     Procyonidae
# 14      Dasypus novemcinctus Animalia Chordata Mammalia       Cingulata     Dasypodidae
# 15     Euphractus sexcinctus Animalia Chordata Mammalia       Cingulata     Dasypodidae
# 16         Cabassous tatouay Animalia Chordata Mammalia       Cingulata     Dasypodidae
# 17     Didelphis albiventris Animalia Chordata Mammalia Didelphimorphia     Didelphidae
# 18           Lepus europaeus Animalia Chordata Mammalia      Lagomorpha       Leporidae
# 19            Cuniculus paca Animalia Chordata Mammalia        Rodentia     Cuniculidae
# 20                No species       NA       NA       NA              NA              NA
# 21 Hydrochoerus hydrochaeris Animalia Chordata Mammalia        Rodentia        Caviidae
# 22     Tamandua tetradactyla Animalia Chordata Mammalia          Pilosa Myrmecophagidae

