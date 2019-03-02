###########################################
# 1) IUCN category retrieving
###########################################

install.packages('rredlist')
library(rredlist)

# Species List
canids <- c('Cerdocyon thous', 'Lycalopex gymnocercus', 'Chrysocyon brachyurus')

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
      cat(sp,'Check species name\n')
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

# Run
retrieve_IUCN_status(canids)


