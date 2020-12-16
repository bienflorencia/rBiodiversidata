# -----------------------------------
# Author: Florencia Grattarola
# Date: 7 December 2020
# Contact: flograttarola@gmail.com
# -----------------------------------

# Hotspots congruence

### Description
# This is a script to analysed the congruence between hotspots of: **SR**: Species Richnes (Number of Species), **E**: Endemism (Range-size-weighted Species Richness) - Roll, et al. (2017), and **T**: Threat (Threatened Species Proportion with Global IUCN categories) - Böhm, et al. (2013).

# To analyse the extent of congruence between the biodiversity hotspots we varied both the **size of the sampling unit** (size of the grid-cell in km) and the **criterion to define a hotspots** (% of area/number of cells occupied by hotspots). The level of congruence was then addressed by calculating the number of overlapping grid-cells according to the  varying definition criterion. 


# ------------------------------------------------------------------------------

#############
# LIBRARIES #
#############

library(wesanderson)
library(sf)
library(tidyverse)

# ------------------------------------------------------------------------------

########
# DATA #
########

# These objects were created with previous scripts

Tetrapods
Grid_UY25 
Grid_UY50 
Grid_UY125

# Use the object 'Tetrapods' created in the first script (Biodiversity metrics calculation) and filter those records from the Amphibia 'class'

Amphibia_GIS <- Tetrapods %>% 
  filter(class=='Amphibia') %>% 
  as.data.frame %>% 
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude")) %>% 
  st_set_crs(4326) %>% st_transform(32721)

# ------------------------------------------------------------------------------

#############
# FUNCTIONS #
#############

# The function get_sharedArea sorts the grid-cells from high to low values of the hotspots (species richnes, endemism and threned species proportion) and at each definition criterion (from 0 to 100% by 0,5%), computes the percentage of congruence as the number of matching grid-cells over the total number of unique cells. The congruence percentage will be calculated as: matching-grid-cells * 100 / total-number-of-unique-cells. 

get_sharedArea <- function(dataset){
  sharedArea <- data.frame(gridPercentage = double(),
                           congruencePercentage= double(),
                           stringsAsFactors=FALSE)
  
  dataset <- dataset %>% filter(N!=0)
  hotspotAreaDefinition <- (nrow(dataset)*seq(0,100,0.5))/100
  
  for(i in hotspotAreaDefinition) {
    GridID_SR <- dataset %>% 
      arrange(desc(SR)) %>% 
      head(i) %>% 
      select(Id)
    GridID_E <- dataset %>% 
      arrange(desc(rswSR)) %>% 
      head(i) %>% 
      select(Id)
    GridID_TP <- dataset %>% 
      arrange(desc(threatenedProportion)) %>% 
      head(i) %>% 
      select(Id)
    
    cumulativeGrids <- nrow(unique(bind_rows(GridID_SR, 
                                             GridID_E,
                                             GridID_TP)))
    
    grid_sharedArea <- data.frame(gridPercentage = (i*100)/nrow(dataset),
                                  congruencePercentage= ifelse(floor(i)!=0, 
                                                               ((nrow(Reduce(intersect, 
                                                                             list(GridID_SR, 
                                                                                  GridID_E,
                                                                                  GridID_TP))))*100)/
                                                                 cumulativeGrids, 0), stringsAsFactors=FALSE)
    sharedArea <- rbind(sharedArea, grid_sharedArea)
  }
  return(sharedArea)
}


# ------------------------------------------------------------------------------

#######
# RUN # 
#######

# 1) Amphibia

# 1.1) First prepare the data for each grid-cell size (50x50, 25x25, and 12.5x12.5 km)

Grid_UY50_Amphibia <- st_join(x=Grid_UY50,
                              y= Amphibia_GIS %>%
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

st_write(Grid_UY50_Amphibia, 'data/Grid_UY50_Amphibia.csv', layer_options = "GEOMETRY=AS_XY")

py_run_file('data/rswSR.py') # File: data/Grid_UY50_Amphibia.csv

Grid_UY50_Amphibia <- left_join(Grid_UY50_Amphibia,
                                read_csv('data/Grid_UY50_Amphibia_rswSR_calculated.csv') %>% rename(Id=ID),
                                by='Id') 

##

Grid_UY25_Amphibia <- st_join(x=Grid_UY25,
                              y= Amphibia_GIS %>%
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

st_write(Grid_UY25_Amphibia, 'data/Grid_UY25_Amphibia.csv', layer_options = "GEOMETRY=AS_XY")

py_run_file('data/rswSR.py') # File: data/Grid_UY25_Amphibia.csv

Grid_UY25_Amphibia <- left_join(Grid_UY25_Amphibia,
                                read_csv('data/Grid_UY25_Amphibia_rswSR_calculated.csv') %>% rename(Id=ID),
                                by='Id') 

##

Grid_UY125_Amphibia <- st_join(x=Grid_UY125,
                               y= Amphibia_GIS %>%
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

st_write(Grid_UY125_Amphibia, 'data/Grid_UY125_Amphibia.csv', layer_options = "GEOMETRY=AS_XY")

py_run_file('data/rswSR.py') # File: data/Grid_UY125_Amphibia.csv

Grid_UY125_Amphibia <- left_join(Grid_UY125_Amphibia,
                                read_csv('data/Grid_UY125_Amphibia_rswSR_calculated.csv') %>% rename(Id=ID),
                                by='Id') 

# 1.2) Now, run the function to calculate the hotspot congruence for each grid-cell size (50x50, 25x25, and 12.5x12.5 km)

Amphibia_50_sharedArea <- get_sharedArea(Grid_UY50_Amphibia)
Amphibia_25_sharedArea <- get_sharedArea(Grid_UY25_Amphibia)
Amphibia_125_sharedArea <- get_sharedArea(Grid_UY125_Amphibia)


# ------------------------------------------------------------------------------

#########
# PLOTS # 
#########

pal <- wes_palette(n=3, name='Darjeeling1')

plot_congruence_Amphibia <- ggplot(Amphibia_50_sharedArea, aes(gridPercentage, congruencePercentage)) +
  geom_line(color=pal[1], size=1) +
  geom_line(data=Amphibia_25_sharedArea, aes(gridPercentage, congruencePercentage), color=pal[2], size=1) +
  geom_line(data=Amphibia_125_sharedArea, aes(gridPercentage, congruencePercentage), color=pal[3], size=1) +
  geom_vline(xintercept=2.5, linetype="dashed", color = "black",  alpha = .5) +
  geom_vline(xintercept=10, linetype="dashed", color = "black",  alpha = .5) +
  labs(x='Hotspots definition (% area occupied by hotspots)', y= 'Congruence (% of area shared by hotsposts)') +
  theme_bw() +
  theme(legend.position = c(0.06, 0.75))+
  guides(colour = "colorbar", size = "legend", shape = "legend") +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0))) 

ggsave('figures/plot_congruence_Amphibia.png', plot_congruence_Amphibia, width = 6, height = 6,  units = "in", dpi = 150)


# Extent of congruence between species richness hotspots, endemic richness hotspots and threat richness hotspots, for amphibian. Relationship between the criterion used to define hotspots and congruence for the three different grid-cells size 50x50km (red line), 25x25km (green line) and 12.5x12.5km (yellow line). Criteria are based on the percentage of land covered by hotspots. Congruence is the number of cells that are hotspots for all three diversity indices, as a percentage of the total hotspot area. Vertical dashed line shows 2.5% and 10% hotspot criterion.  
