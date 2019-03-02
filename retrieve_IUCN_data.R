#############################################
# IUCN Status Category and Population Trend #
#############################################

library(rredlist)
library(tidyverse)

# Fuction
retrieve_IUCN_status <- function(speciesList){
  IUCN_status <- data.frame(Species = character(), Status = character(), 
                            Trend = character(), stringsAsFactors=FALSE)
  for(sp in speciesList){
    UICN_search <- rl_search(name = sp)
    if (length(UICN_search$result) == 0){
      IUCN_status_sp <- data.frame(Species = sp, 
                                   Status = 'NA', 
                                   Trend = 'NA', stringsAsFactors=FALSE)
      IUCN_status <- rbind(IUCN_status, IUCN_status_sp)
      cat(sp,'----- CHECK\n')
    }
    else {
      IUCN_status_sp <- data.frame(Species = UICN_search$result$scientific_name, 
                                   Status = UICN_search$result$category, 
                                   Trend = UICN_search$result$population_trend, stringsAsFactors=FALSE)
      IUCN_status <- rbind(IUCN_status, IUCN_status_sp)
      cat(sp, UICN_search$result$category, 
          UICN_search$result$population_trend, '\n')
    }
  }
  return(IUCN_status)
}

# 1) Species List
canids <- c('Cerdocyon thous', 'Lycalopex gymnocercus', 'Chrysocyon brachyurus')
# Run
retrieve_IUCN_status(canids)

# 2) Data from table
mammals <- read_csv('speciesList.csv')
# Run
retrieve_IUCN_status(mammals$Species)
