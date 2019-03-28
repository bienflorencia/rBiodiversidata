#############################################
# IUCN Status Category and Population Trend #
#############################################

library(rredlist)
library(tidyverse)

#####################################
# FUNCTION

retrieve_IUCN_data <- function(speciesList){
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
    }
  }
  return(IUCN_status)
}

#####################################
# RUN

# 1) Species List
canids <- c('Cerdocyon thous', 'Lycalopex gymnocercus', 'Chrysocyon brachyurus', 'AnyWrong species')
canids_IUCN_data <- retrieve_IUCN_data(canids)

## The fuction will print in console
# AnyWrong species ----- CHECK

canids_IUCN_data
#                 Species Status   Trend
# 1       Cerdocyon thous     LC  Stable
# 2 Lycalopex gymnocercus     LC  Stable
# 3 Chrysocyon brachyurus     NT Unknown
# 4      AnyWrong species     NA      NA


# 2) Data from table
mammals <- read_csv('speciesList.csv')
mammlas_IUCN_data <- retrieve_IUCN_data(mammals$Species)

## The fuction will print in console
# Leopardus braccatus ----- CHECK
# Puma yagouaroundi ----- CHECK
# No species ----- CHECK

mammlas_IUCN_data
#                      Species Status      Trend
# 1         Mazama gouazoubira     LC Decreasing
# 2                  Axis axis     LC    Unknown
# 3                 Sus scrofa     LC    Unknown
# 4            Cerdocyon thous     LC     Stable
# 5      Chrysocyon brachyurus     NT    Unknown
# 6      Lycalopex gymnocercus     LC     Stable
# 7           Leopardus wiedii     NT Decreasing
# 8        Leopardus braccatus     NA         NA
# 9        Leopardus geoffroyi     LC     Stable
# 10         Puma yagouaroundi     NA         NA
# 11        Lontra longicaudis     NT Decreasing
# 12          Conepatus chinga     LC Decreasing
# 13             Galictis cuja     LC    Unknown
# 14       Procyon cancrivorus     LC Decreasing
# 15      Dasypus novemcinctus     LC     Stable
# 16     Euphractus sexcinctus     LC     Stable
# 17         Cabassous tatouay     LC    Unknown
# 18     Didelphis albiventris     LC     Stable
# 19           Lepus europaeus     LC Decreasing
# 20            Cuniculus paca     LC     Stable
# 21                No species     NA         NA
# 22 Hydrochoerus hydrochaeris     LC     Stable
# 23     Tamandua tetradactyla     LC    Unknown
