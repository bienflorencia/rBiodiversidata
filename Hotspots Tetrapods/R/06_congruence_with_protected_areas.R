# -----------------------------------
# Author: Florencia Grattarola
# Date: 7 December 2020
# Contact: flograttarola@gmail.com
# -----------------------------------

# Congruence with protected areas

### Description
# This is a script that calculates species-richness, endemism and threatened species number/proportion values for grid-cell. As input, a csv file with primary data is needed, along with a gridded map with the extension of Uruguay (we used three grid-cell unit resolutions 12.5x12.5km, 25x25km and 50x50km). 


# ------------------------------------------------------------------------------

#############
# LIBRARIES #
#############

library(sf)
library(tidyverse)

# ------------------------------------------------------------------------------

########
# DATA #
########

AP_UTM <- st_read('data/areas_snap_ingresadas_29042020_utm.shp')
AP_Grid_UY25 <- st_read('data/AP_Grid_UY25.shp') 
AP_Grid_UY125 <- st_read('data/AP_Grid_UY125.shp') 

Grid_UY25_Amphibia

# ------------------------------------------------------------------------------

#############
# FUNCTIONS #
#############

get_overlappingArea <- function(dataset, protectedArea, percentage){
  
  dataset <- dataset %>% filter(N!=0)
  overlapAreaDefinition <-  nrow(dataset)*percentage/100
  
  GridID_PA <- protectedArea %>% 
    filter(N==1) %>% 
    select(GridId)
  
  GridID_SR <- dataset %>%
    arrange(desc(SR)) %>%
    head(overlapAreaDefinition) %>% 
    select(Id)
  
  GridID_E <- dataset %>%
    arrange(desc(rswSR)) %>%
    head(overlapAreaDefinition) %>% 
    select(Id)
  
  GridID_TSN <- dataset %>%
    arrange(desc(threatenedNumber)) %>%
    head(overlapAreaDefinition) %>%
    select(Id)
  
  GridID_TSP <- dataset %>%
    arrange(desc(threatenedProportion)) %>%
    head(overlapAreaDefinition) %>%
    select(Id)
  
  
  overlappingArea <- data.frame(overlap_SR=nrow(intersect(GridID_SR,
                                                          GridID_PA %>% 
                                                            rename(Id=GridId)))*100/nrow(GridID_SR),
                                overlap_E=nrow(intersect(GridID_E,
                                                         GridID_PA %>% 
                                                           rename(Id=GridId)))*100/nrow(GridID_E),
                                overlap_TSN=nrow(intersect(GridID_TSN,
                                                           GridID_PA %>% 
                                                             rename(Id=GridId)))*100/nrow(GridID_TSN),
                                overlap_TSP =nrow(intersect(GridID_TSP,
                                                            GridID_PA %>% 
                                                              rename(Id=GridId)))*100/nrow(GridID_TSP),
                                stringsAsFactors=FALSE)
  return(overlappingArea)
}

# ------------------------------------------------------------------------------

#######
# RUN # 
#######

# 1) Amphibia (Tetrapods)


Amphibia_overlapping_PA_UY25_2.5 <- cbind(data.frame(group='Amphibia UY25 2.5%'), get_overlappingArea(Grid_UY25_Amphibia, AP_Grid_UY25, 2.5))
Amphibia_overlapping_PA_UY25_5 <- cbind(data.frame(group='Amphibia UY25 5%'), get_overlappingArea(Grid_UY25_Amphibia, AP_Grid_UY25, 5))

Amphibia_overlapping_PA_UY125_2.5 <- cbind(data.frame(group='Amphibia UY125 2.5%'), get_overlappingArea(Grid_UY125_Amphibia, AP_Grid_UY125, 2.5))
Amphibia_overlapping_PA_UY125_5 <- cbind(data.frame(group='Amphibia UY125 5%'), get_overlappingArea(Grid_UY125_Amphibia, AP_Grid_UY125, 5))


bind_rows(Amphibia_overlapping_PA_UY25_2.5, Amphibia_overlapping_PA_UY25_5,
          Amphibia_overlapping_PA_UY125_2.5, Amphibia_overlapping_PA_UY125_5)


# ------------------------------------------------------------------------------

#########
# PLOTS # 
#########

plot_congruence_Amphibia_SR_and_PA <- ggplot() + 
  geom_sf(data = Grid_UY25_Amphibia, aes(fill=SR)) +
  scale_fill_distiller(palette = "Spectral")+
  geom_sf(data = Uruguay, color='black', fill=NA) +
  geom_sf(data = AP_UTM, fill='green', alpha=0.5) +
  theme_bw() +
  labs(fill='Amphibia\nSpecies Richness')


ggsave('figures/plot_congruence_Amphibia_SR_and_PA.png', plot_congruence_Amphibia_SR_and_PA, width = 6, height = 6,  units = "in", dpi = 150)
