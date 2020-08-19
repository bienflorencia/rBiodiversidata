#####################################
#   Get scientificNameAuthorship    #
#####################################

library(taxize)
library(tidyverse)

sources <- gnr_datasources()
itis <- sources$id[sources$title == 'ITIS']
col <- sources$id[sources$title == 'Catalogue of Life']


#####################################

# FUNCTION

get_scientificNameAuthorship <- function(species){
  species_scientificNameAuthorship <- data.frame(Species = character(),
                                                 Authorship = character(),
                                                 stringsAsFactors=FALSE)
  for(sp in species) {
    sp_search <- gnr_resolve(sp, data_source_ids=itis, best_match_only=TRUE)
    if (length(sp_search)==0){
      sp_Authorship <- data.frame(Species = sp,
                                  Authorship = 'NOT FOUND',
                                  stringsAsFactors=FALSE)
      species_scientificNameAuthorship <- rbind(species_scientificNameAuthorship, sp_Authorship)
    }
    else if (sp_search$score <= 0.9){
      sp_Authorship <- data.frame(Species = sp,
                                  Authorship = 'NOT FOUND',
                                  stringsAsFactors=FALSE)
      species_scientificNameAuthorship <- rbind(species_scientificNameAuthorship, sp_Authorship)
    }
    else {
      sp_Authorship <- data.frame(Species = sp,
                                  Authorship = sp_search$matched_name,
                                  stringsAsFactors=FALSE)
      species_scientificNameAuthorship <- rbind(species_scientificNameAuthorship, sp_Authorship)
    }
    
  }
  return(species_scientificNameAuthorship)
}


#####################################
# RUN

# 1) Species List
canids <- c('Cerdocyon thous', 'Lycalopex gymnocercus', 'Chrysocyon brachyurus', 'Wrong species')
get_scientificNameAuthorship(canids)

#                 Species                               Authorship
# 1       Cerdocyon thous         Cerdocyon thous (Linnaeus, 1766)
# 2 Lycalopex gymnocercus Lycalopex gymnocercus (G. Fischer, 1814)
# 3 Chrysocyon brachyurus    Chrysocyon brachyurus (Illiger, 1815)
# 4         Wrong species                                NOT FOUND

# 2) Data from table
mammals <- read_csv('speciesList.csv')
get_scientificNameAuthorship(mammals$Species)

#                      Species                                           Authorship
# 1         Mazama gouazoubira Mazama gouazoubira (G. Fischer [von Waldheim], 1814)
# 2                  Axis axis                           Axis axis (Erxleben, 1777)
# 3                 Sus scrofa                            Sus scrofa Linnaeus, 1758
# 4            Cerdocyon thous                     Cerdocyon thous (Linnaeus, 1766)
# 5      Chrysocyon brachyurus                Chrysocyon brachyurus (Illiger, 1815)
# 6      Lycalopex gymnocercus             Lycalopex gymnocercus (G. Fischer, 1814)
# 7           Leopardus wiedii                      Leopardus wiedii (Schinz, 1821)
# 8        Leopardus braccatus                     Leopardus braccatus (Cope, 1889)
# 9        Leopardus geoffroyi    Leopardus geoffroyi (d'Orbigny and Gervais, 1844)
# 10         Puma yagouaroundi  Puma yagouaroundi (É. Geoffroy Saint-Hilaire, 1803)
# 11        Lontra longicaudis                    Lontra longicaudis (Olfers, 1818)
# 12          Conepatus chinga                      Conepatus chinga (Molina, 1782)
# 13             Galictis cuja                         Galictis cuja (Molina, 1782)
# 14       Procyon cancrivorus         Procyon cancrivorus (G.[Baron] Cuvier, 1798)
# 15      Dasypus novemcinctus                  Dasypus novemcinctus Linnaeus, 1758
# 16     Euphractus sexcinctus               Euphractus sexcinctus (Linnaeus, 1758)
# 17         Cabassous tatouay                  Cabassous tatouay (Desmarest, 1804)
# 18     Didelphis albiventris                     Didelphis albiventris Lund, 1840
# 19           Lepus europaeus                         Lepus europaeus Pallas, 1778
# 20            Cuniculus paca                      Cuniculus paca (Linnaeus, 1766)
# 21                No species                                            NOT FOUND
# 22 Hydrochoerus hydrochaeris           Hydrochoerus hydrochaeris (Linnaeus, 1766)
# 23     Tamandua tetradactyla               Tamandua tetradactyla (Linnaeus, 1758)
