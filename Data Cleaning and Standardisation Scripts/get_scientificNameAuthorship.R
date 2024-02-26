#####################################
#   Get scientificNameAuthorship    #
#####################################

library(taxize)
library(tidyverse)

sources <- gnr_datasources()
itis <- sources %>% filter(grepl('ITIS', title)) %>% pull(id)
col <- sources %>% filter(grepl('Catalogue of Life', title)) %>% pull(id)

#####################################

# FUNCTION

get_scientificNameAuthorship <- function(species, data_source){
  species_scientificNameAuthorship <- tibble(scientificName = character(),
                                             scientificNameAuthorship = character(),
                                             authorship = character())
  for(sp in species) {
    sp_search <- gnr_resolve(sci=sp, data_source_ids=data_source, best_match_only=TRUE)
    if (nrow(sp_search)==0){
      sp_Authorship <- tibble(scientificName = sp,
                              scientificNameAuthorship = NA, 
                              authorship = NA)
      species_scientificNameAuthorship <- rbind(species_scientificNameAuthorship, sp_Authorship)
    }
    else if (sp_search$score <= 0.9){
      sp_Authorship <- tibble(scientificName = sp,
                              scientificNameAuthorship = NA, 
                              authorship = NA)
      species_scientificNameAuthorship <- rbind(species_scientificNameAuthorship, sp_Authorship)
    }
    else {
      sp_Authorship <- tibble(scientificName = sp,
                              scientificNameAuthorship = sp_search$matched_name,
                              authorship = str_trim(str_remove(sp_search$matched_name, sp)))
      species_scientificNameAuthorship <- rbind(species_scientificNameAuthorship, sp_Authorship)
    }
  }
  return(species_scientificNameAuthorship)
}

#####################################
# RUN

# 1) Species List
canids <- c('Cerdocyon thous', 'Lycalopex gymnocercus', 'Chrysocyon brachyurus', 'Wrong species')
get_scientificNameAuthorship(canids, itis)

# # A tibble: 4 × 3
#   scientificName          scientificNameAuthorship                 authorship        
#   <chr>                   <chr>                                    <chr>             
#   1 Cerdocyon thous       Cerdocyon thous (Linnaeus, 1766)         (Linnaeus, 1766)  
#   2 Lycalopex gymnocercus Lycalopex gymnocercus (G. Fischer, 1814) (G. Fischer, 1814)
#   3 Chrysocyon brachyurus Chrysocyon brachyurus (Illiger, 1815)    (Illiger, 1815)   
#   4 Wrong species         NA                                       NA    

# 2) Data from table
mammals <- read_csv('tetrapodsSpeciesList.csv')
get_scientificNameAuthorship(mammals$Species, itis)

# # A tibble: 23 × 3
#   scientificName              scientificNameAuthorship                             authorship                       
#   <chr>                       <chr>                                                <chr>                            
#   1 Mazama gouazoubira        Mazama gouazoubira (G. Fischer [von Waldheim], 1814) (G. Fischer [von Waldheim], 1814)
#   2 Axis axis                 Axis axis (Erxleben, 1777)                           (Erxleben, 1777)                 
#   3 Sus scrofa                Sus scrofa Linnaeus, 1758                            Linnaeus, 1758                   
#   4 Cerdocyon thous           Cerdocyon thous (Linnaeus, 1766)                     (Linnaeus, 1766)                 
#   5 Chrysocyon brachyurus     Chrysocyon brachyurus (Illiger, 1815)                (Illiger, 1815)                  
#   6 Lycalopex gymnocercus     Lycalopex gymnocercus (G. Fischer, 1814)             (G. Fischer, 1814)               
#   7 Leopardus wiedii          Leopardus wiedii (Schinz, 1821)                      (Schinz, 1821)                   
#   8 Leopardus braccatus       Leopardus braccatus (Cope, 1889)                     (Cope, 1889)                     
#   9 Leopardus geoffroyi       Leopardus geoffroyi (d'Orbigny and Gervais, 1844)    (d'Orbigny and Gervais, 1844)    
#   10 Puma yagouaroundi         Puma yagouaroundi (É. Geoffroy Saint-Hilaire, 1803)  (É. Geoffroy Saint-Hilaire, 1803)
#   11 Lontra longicaudis        Lontra longicaudis (Olfers, 1818)                    (Olfers, 1818)                   
#   12 Conepatus chinga          Conepatus chinga (Molina, 1782)                      (Molina, 1782)                   
#   13 Galictis cuja             Galictis cuja (Molina, 1782)                         (Molina, 1782)                   
#   14 Procyon cancrivorus       Procyon cancrivorus (G.[Baron] Cuvier, 1798)         (G.[Baron] Cuvier, 1798)         
#   15 Dasypus novemcinctus      Dasypus novemcinctus Linnaeus, 1758                  Linnaeus, 1758                   
#   16 Euphractus sexcinctus     Euphractus sexcinctus (Linnaeus, 1758)               (Linnaeus, 1758)                 
#   17 Cabassous tatouay         Cabassous tatouay (Desmarest, 1804)                  (Desmarest, 1804)                
#   18 Didelphis albiventris     Didelphis albiventris Lund, 1840                     Lund, 1840                       
#   19 Lepus europaeus           Lepus europaeus Pallas, 1778                         Pallas, 1778                     
#   20 Cuniculus paca            Cuniculus paca (Linnaeus, 1766)                      (Linnaeus, 1766)                 
#   21 No species                NA                                                   NA                               
#   22 Hydrochoerus hydrochaeris Hydrochoerus hydrochaeris (Linnaeus, 1766)           (Linnaeus, 1766)                 
#   23 Tamandua tetradactyla     Tamandua tetradactyla (Linnaeus, 1758)               (Linnaeus, 1758) 
