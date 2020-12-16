# -----------------------------------
# Author: Florencia Grattarola
# Date: 7 December 2020
# Contact: flograttarola@gmail.com
# -----------------------------------

# Identification of 'areas of ignorance'

### Description
# To identify the areas of ignorance we quantified the levels of inventory incompleteness for each group by using curvilinearity of smoothed species accumulation curves (SACs). This method assumes that SACs of poorly sampled grids tend towards a straight line, while those of better sampled ones have a higher degree of curvature. As a proxy for inventory incompleteness we calculated the degree of curvilinearity as the mean slope of the last 10% of SACs. 


# ------------------------------------------------------------------------------

#############
# LIBRARIES #
#############

library(sf)
library(vegan)
library(spaa)
library(tidyverse)

# ------------------------------------------------------------------------------

########
# DATA #
########

# These objects were created with previous scripts

Grid_UY25_Tetrapods
Grid_UY25 

# ------------------------------------------------------------------------------

#############
# FUNCTIONS #
#############

# The function ```get_gridsSlopes``` finds a species accumulation curve (SAC) for each grid-cell using the method ‘exact’ of the function ```specaccum``` of the vegan package and then calculates the degree of curvilinearity as the mean slope of the last 10% of the curve. 

get_gridsSlopes <- function(data_abundance){
  GridSlope <- data.frame(Grid=integer(), Slope=numeric(), stringsAsFactors=FALSE)
  data_abundance <- as.data.frame(data_abundance) 
  data_abundance$abundance <- as.integer(1)
  cells <- unique(data_abundance$GridID)
  splistT <- list()
  spaccum <- list()
  slope <- list()
  for (i in cells) {
    splist <- data_abundance[data_abundance$GridID == i,c(2:4)]
    splistT[[i]] = data2mat(splist) 
    spaccum[[i]] = specaccum(splistT[[i]], method = "exact")
    slope[[i]] = (spaccum[[i]][[4]][length(spaccum[[i]][[4]])]-
                    spaccum[[i]][[4]][ceiling(length(spaccum[[i]][[4]])*0.9)])/
      (length(spaccum[[i]][[4]])- ceiling(length(spaccum[[i]][[4]])*0.9))
    GridSlope_i <- data.frame(Grid=i, Slope=slope[[i]], stringsAsFactors=FALSE)
    GridSlope <- rbind(GridSlope, GridSlope_i)
  }  
  return(GridSlope)
}

# ------------------------------------------------------------------------------

#######
# RUN # 
#######

# 1) Amphibia (Tetrapods)

Amphibia_25.SACs <- Grid_UY25_Amphibia %>% as_tibble() %>% 
  mutate(Species=str_split(spsList, ';')) %>% 
  unnest(Species) %>% 
  group_by(spsList) %>% mutate(Sample = row_number()) %>% 
  ungroup() %>% 
  mutate(Sample=ifelse(is.na(Species), 0 , Sample)) %>% 
  select(GridID=Id, Sample, Species)

Amphibia_25.incompleteness <- get_gridsSlopes(Amphibia_25.SACs)

Grid_UY25_Amphibia.SACs <- left_join(Grid_UY25_Amphibia,
                                     Amphibia_25.incompleteness %>% rename(Id=Grid), by='Id') 

st_write(Grid_UY25_Amphibia.SACs, 'shp/Grid_UY25_Amphibia.SACs.shp', delete_layer = T)


# ------------------------------------------------------------------------------

#########
# PLOTS # 
#########

# We considered grids with slope values > 0.05 as under-sampled and those with slope values ≤ 0.05 as well sampled.
# The plot is made for an individual well-sampled grid-cell (Grid_UY25_Amphibia.SACs %>% filter(Slope<=0.05))


Amphibia_specaccum <- Amphibia_25.SACs %>% 
  filter(GridID=='Grid3') %>% 
  mutate(abundance=as.integer(1), observation = 1:n()) %>% 
  select(observation, species=Species, abundance)

Amphibia_rarefaction <- data2mat(as.data.frame(Amphibia_specaccum)) 
Amphibia_rarefaction_specaccum <- specaccum(Amphibia_rarefaction, method = "exact")

Amphibia_rarefaction_specaccum_GG <- tibble(sites=Amphibia_rarefaction_specaccum$sites,
                                            richness=Amphibia_rarefaction_specaccum$richness,
                                            sd=Amphibia_rarefaction_specaccum$sd)

plot_SAC_Amphibia <- ggplot(Amphibia_rarefaction_specaccum_GG, aes(x=sites, y=richness)) +
  geom_ribbon(aes(ymin=richness-sd, ymax=richness+sd), alpha =0.15, fill='#abdca3') +
  geom_line(linetype=1, size=1, color='#abdca3') +
  geom_vline(aes(xintercept=max(sites)), linetype=2, color = "black",  alpha = .5) +
  geom_vline(aes(xintercept=0.9*max(sites)), linetype=2, color = "black",  alpha = .5) +
  theme_bw() +
  labs(x='Number of Records', y= 'Number of Species', title = 'Grid3') +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0))) 

ggsave('figures/plot_SAC_Amphibia.png', plot_SAC_Amphibia, width = 6, height = 6,  units = "in", dpi = 150)

# Plot of the species accumulation curve (SAC) of the well sampled grid-cell for reptilians of Uruguay using the 25 × 25 km grid-cell resolution. Slope value <=0.05 was calculated given the degree of curvilinearity as the mean slope of the last 10% of the curve (shown between dashed vertical lines).
