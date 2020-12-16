# -----------------------------------
# Author: Florencia Grattarola
# Date: 7 December 2020
# Contact: flograttarola@gmail.com
# -----------------------------------

# Biodiversity metrics calculation

### Description
# This is a script that calculates species-richness, endemism and threatened species number/proportion values for grid-cell. As input, a csv file with primary data is needed, along with a gridded map with the extension of Uruguay (we used three grid-cell unit resolutions 12.5x12.5km, 25x25km and 50x50km). 


# ------------------------------------------------------------------------------

#############
# LIBRARIES #
#############

library(reticulate)
library(sf)
library(tidyverse)

# ------------------------------------------------------------------------------

########
# DATA #
########

Tetrapods <- read_csv('data/Tetrapods.csv', guess_max = min(8000))

Grid_UY25 <- st_read('data/Grid_UY25.shp') 
Grid_UY50 <- st_read('data/Grid_UY50.shp') 
Grid_UY125 <- st_read('data/Grid_UY125.shp') 

Uruguay <- st_read('data/Uruguay.shp')

# ------------------------------------------------------------------------------

#############
# FUNCTIONS #
#############

# We will use the Python function rswSR.py 

# ------------------------------------------------------------------------------

#######
# RUN # 
#######

# 1) Tetrapods

Tetrapods_GIS <- Tetrapods %>% 
  as.data.frame %>% 
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude")) %>% 
  st_set_crs(4326) %>% st_transform(32721)

Grid_UY25_Tetrapods <- st_join(x=Grid_UY25,
                               y= Tetrapods_GIS %>%
                                 select(species, class, threatenedStatus), 
                               left=TRUE, join = st_contains) %>%
  group_by(Id) %>%
  summarise(N=ifelse(n_distinct(species, na.rm = TRUE)==0, 0, n()),
            SR=n_distinct(species, na.rm = TRUE),
            spsList = paste(species, collapse = ';'),
            threatCR=sum(threatenedStatus=='CR', na.rm = T),
            threatEN=sum(threatenedStatus=='EN', na.rm = T),
            threatVU=sum(threatenedStatus=='VU', na.rm = T), 
            .groups = 'drop') %>% 
  mutate(threatenedNumber=threatCR+threatEN+threatVU,
         threatenedProportion=ifelse(threatenedNumber==0, 0, threatenedNumber/N)) %>% 
  mutate(areaKM=st_area(.)) %>% 
  mutate(areaKM=units::set_units(areaKM, km^2)) 


st_write(Grid_UY25_Tetrapods, 'data/Grid_UY25_Tetrapods.csv', layer_options = "GEOMETRY=AS_XY")

py_run_file('data/rswSR.py') # File: data/Grid_UY25_Tetrapods.csv

Grid_UY25_Tetrapods <- left_join(Grid_UY25_Tetrapods, 
                                read_csv('data/Grid_UY25_Tetrapods_rswSR_calculated.csv') %>% rename(Id=ID), 
                                by='Id') 


# ------------------------------------------------------------------------------

#########
# PLOTS # 
#########

plot_SR_Tetrapods <- ggplot() + 
  geom_sf(data = Grid_UY25_Tetrapods, aes(fill=SR)) +
  scale_fill_distiller(palette ='Spectral')+
  geom_sf(data = Uruguay, color='black', fill=NA) +
  theme_bw() +
  labs(fill='Tetrapods\nSpecies Richness') 

ggsave('figures/plot_SR_Tetrapods_UY25.png', plot_SR_Tetrapods, width = 6, height = 7,  units = "in", dpi = 150)

plot_E_Tetrapods <- ggplot() + 
  geom_sf(data = Grid_UY25_Tetrapods, aes(fill=rswSR)) +
  scale_fill_distiller(palette ='Spectral')+
  geom_sf(data = Uruguay, color='black', fill=NA) +
  theme_bw() +
  labs(fill='Tetrapods\nEndemism') 

ggsave('figures/plot_E_Tetrapods_UY25.png', plot_E_Tetrapods, width = 6, height = 7,  units = "in", dpi = 150)

plot_TN_Tetrapods <- ggplot() + 
  geom_sf(data = Grid_UY25_Tetrapods, aes(fill=threatenedNumber)) +
  scale_fill_distiller(palette ='Spectral')+
  geom_sf(data = Uruguay, color='black', fill=NA) +
  theme_bw() +
  labs(fill='Tetrapods\nThreatened Number') 

ggsave('figures/plot_TN_Tetrapods_UY25.png', plot_TN_Tetrapods, width = 6, height = 7,  units = "in", dpi = 150)
