###########################################################
#   Get higher rank taxonomic information for a species   #
###########################################################

library(taxize)
library(tidyverse)

#####################################

# TAXONOMIC DATA SOURCES
sources <- gnr_datasources()
gbif <- sources$id[sources$title == 'GBIF Backbone Taxonomy']

#####################################
# FUNCTION

getHigherclassification <- function(scientificName){
  species_classif <- data.frame(scientificName = character(),
                                kingdom = character(),
                                phylum = character(),
                                class = character(),
                                order = character(), stringsAsFactors=FALSE)
  for(sp in scientificName) {
    sp_classif <- classification(get_gbifid(sp, rows=1), db='gbif', start=1)
    if (length(sp_classif[[1]])!=3){
      species_classif_sp <- data.frame(scientificName = sp,
                                       kingdom = 'NA',
                                       phylum = 'NA',
                                       class = 'NA',
                                       order = 'NA', stringsAsFactors=FALSE)
      species_classif <- rbind(species_classif, species_classif_sp)
      cat(sp, ': NOT FOUND \n')
    } 
    else {
      species_classif_sp <- data.frame(scientificName = sp,
                                       kingdom = sp_classif[[1]]$name[sp_classif[[1]]$rank=='kingdom'],
                                       phylum = sp_classif[[1]]$name[sp_classif[[1]]$rank=='phylum'],
                                       class = sp_classif[[1]]$name[sp_classif[[1]]$rank=='class'],
                                       order = sp_classif[[1]]$name[sp_classif[[1]]$rank=='order'],
                                       stringsAsFactors=FALSE)
      species_classif <- rbind(species_classif, species_classif_sp)
    }
  }
  return(species_classif)
}

#####################################
# RUN

# 1) Species List
plants <- c('Erithrina cristagalli', 'Ludwigia peploides subsp. montevidensis', 'Dychondra microcalix', 'Wrong species')

plantsHigherclassification <- getHigherclassification(plants)

#                            scientificName kingdom       phylum         class     order
# 1                   Erithrina cristagalli Plantae Tracheophyta Magnoliopsida   Fabales
# 2 Ludwigia peploides subsp. montevidensis Plantae Tracheophyta Magnoliopsida  Myrtales
# 3                    Dychondra microcalix Plantae Tracheophyta Magnoliopsida Solanales
# 4                           Wrong species      NA           NA            NA        NA



# 2) Data from table
plantSpeciesList <- read_csv('plantSpeciesList.csv')

plantSpeciesListHigherclassification <- getHigherclassification(plantSpeciesList$species)

#                       scientificName kingdom       phylum          class          order
# 1                     Myosotis verna Plantae Tracheophyta  Magnoliopsida    Boraginales
# 2               Buddleja grandiflora Plantae Tracheophyta  Magnoliopsida       Lamiales
# 3                Buddleja thyrsoides Plantae Tracheophyta  Magnoliopsida       Lamiales
# 4             Rhipsalis lumbricoides Plantae Tracheophyta  Magnoliopsida Caryophyllales
# 5              Acicarpha tribuloides Plantae Tracheophyta  Magnoliopsida      Asterales
# 6  Triodanis perfoliata var. biflora Plantae Tracheophyta  Magnoliopsida      Asterales
# 7           Wahlenbergia linarioides Plantae Tracheophyta  Magnoliopsida      Asterales
# 8                       Canna glauca Plantae Tracheophyta     Liliopsida   Zingiberales
# 9                  Tarenaya titubans Plantae Tracheophyta  Magnoliopsida    Brassicales
# 10            Monteverdia ilicifolia Plantae Tracheophyta  Magnoliopsida    Celastrales
# 11         Schaefferia argentinensis Plantae Tracheophyta  Magnoliopsida    Celastrales
# 12            Dysphania ambrosioides Plantae Tracheophyta  Magnoliopsida Caryophyllales
# 13                  Dysphania retusa Plantae Tracheophyta  Magnoliopsida Caryophyllales
# 14          Crocanthemum brasiliense Plantae Tracheophyta  Magnoliopsida       Malvales
# 15              Terminalia australis Plantae Tracheophyta  Magnoliopsida       Myrtales
# 16                    Butia capitata Plantae Tracheophyta     Liliopsida       Arecales
# 17             Lithraea brasiliensis Plantae Tracheophyta  Magnoliopsida     Sapindales
# 18 Schinus engleri var. uruguayensis Plantae Tracheophyta  Magnoliopsida     Sapindales
# 19                  Berberis laurina Plantae Tracheophyta  Magnoliopsida   Ranunculales
# 20                Cereus uruguayanus Plantae Tracheophyta  Magnoliopsida Caryophyllales
# 21                     Parodia scopa Plantae Tracheophyta  Magnoliopsida Caryophyllales
# 22             Opuntia arechavaletae Plantae Tracheophyta  Magnoliopsida Caryophyllales
# 23                 Ephedra tweediana Plantae Tracheophyta     Gnetopsida     Ephedrales
# 24          Tripodanthus acutifolius Plantae Tracheophyta  Magnoliopsida     Santalales
# 25                  Sida rhombifolia Plantae Tracheophyta  Magnoliopsida       Malvales
# 26                  Myrsine coriacea Plantae Tracheophyta  Magnoliopsida       Ericales
# 27               Myrsine laetevirens Plantae Tracheophyta  Magnoliopsida       Ericales
# 28          Myrrhinium atropurpureum Plantae Tracheophyta  Magnoliopsida       Myrtales
# 29                 Colletia paradoxa Plantae Tracheophyta  Magnoliopsida        Rosales
# 30                  Scutia buxifolia Plantae Tracheophyta  Magnoliopsida        Rosales
# 31                 Allophylus edulis Plantae Tracheophyta  Magnoliopsida     Sapindales
# 32                  Dodonaea viscosa Plantae Tracheophyta  Magnoliopsida     Sapindales
# 33               Solanum mauritianum Plantae Tracheophyta  Magnoliopsida      Solanales
# 34               Daphnopsis racemosa Plantae Tracheophyta  Magnoliopsida       Malvales
# 35                       Celtis tala Plantae Tracheophyta  Magnoliopsida        Rosales
# 36                    Lantana camara Plantae Tracheophyta  Magnoliopsida       Lamiales
# 37                Eryngium nudicaule Plantae Tracheophyta  Magnoliopsida        Apiales
# 38           Hydrocotyle bonariensis Plantae Tracheophyta  Magnoliopsida        Apiales
# 39                 Baccharis trimera Plantae Tracheophyta  Magnoliopsida      Asterales
# 40           Chaptalia piloselloides Plantae Tracheophyta  Magnoliopsida      Asterales
# 41             Chevreulia sarmentosa Plantae Tracheophyta  Magnoliopsida      Asterales
# 42                Conyza bonariensis Plantae Tracheophyta  Magnoliopsida      Asterales
# 43              Gamochaeta americana Plantae Tracheophyta  Magnoliopsida      Asterales
# 44                   Soliva sessilis Plantae Tracheophyta  Magnoliopsida      Asterales
# 45                 Lobelia hederacea Plantae Tracheophyta  Magnoliopsida      Asterales
# 46              Dichondra macrocalyx Plantae Tracheophyta  Magnoliopsida      Solanales
# 47                Evolvulus sericeus Plantae Tracheophyta  Magnoliopsida      Solanales
# 48               Equisetum giganteum Plantae Tracheophyta Polypodiopsida    Equisetales
# 49             Trifolium polymorphum Plantae Tracheophyta  Magnoliopsida        Fabales
# 50                   Herbertia lahue Plantae Tracheophyta     Liliopsida    Asparagales
