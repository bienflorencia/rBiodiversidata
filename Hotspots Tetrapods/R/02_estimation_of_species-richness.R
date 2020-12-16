# -----------------------------------
# Author: Florencia Grattarola
# Date: 7 December 2020
# Contact: flograttarola@gmail.com
# -----------------------------------

# Estimation of species-richness

### Description
# This is a script that calculates estimated values of species-richness per grid-cell. The functions uses the package iNEXT.

# ------------------------------------------------------------------------------

#############
# LIBRARIES #
#############

library(iNEXT)
library(sf)
library(tidyverse)

# ------------------------------------------------------------------------------

########
# DATA #
########

# These objects were created with the previous script (Biodiversity metrics calculation)

Tetrapods_GIS
Grid_UY25_Tetrapods
Grid_UY25

# ------------------------------------------------------------------------------

#############
# FUNCTIONS #
#############

# Function to calculate the frequency of species incidence data per grid-cell (incidence matrix)
# Each grid-cell is further divided into sub-grids of 1x1 km to create a species incidence dataset at the grid-cell level by counting the number of sub-gridded cells that contained occurrence records for individual species

getSpeciesSampledGrids <- function(grid_plygons, data_points) {
  
  dataSpeciesSampledGrids <- data.frame(Id=character(),
                                        sampleGridId=character(),
                                        speciesName = character(),
                                        abundance= numeric(),
                                        stringsAsFactors=FALSE)
  
  for(Grid_i in unique(grid_plygons$Id)){ 
    data_points_i <- st_crop(data_points, st_bbox(grid_plygons %>% filter(Id==Grid_i))) %>% select(species)
    isEmpty <- st_intersection(st_geometry(grid_plygons[grid_plygons$Id==Grid_i,]), 
                               st_geometry(data_points_i))
    
    if(length(isEmpty)!=0) {
      
      boxSubGridGrid <- st_bbox(grid_plygons %>% filter(Id==Grid_i))
      subGrid <- st_make_grid(st_as_sfc(boxSubGridGrid), 
                              cellsize = 1000, what='polygons', square = TRUE)
      subGrid <- st_sf(index = 1:length(lengths(subGrid)), subGrid)
      
      for(subGrid_i in unique(subGrid$index)){
        isEmpty <- st_intersection(st_geometry(subGrid[subGrid_i,]), st_geometry(data_points_i))
        if(length(isEmpty)!=0){
          dataSubGrid <- st_join(x= subGrid[subGrid_i,],
                                 y=data_points_i,
                                 left=TRUE, join = st_contains)
          speciesAbundance <- dataSubGrid %>% as.data.frame() %>% group_by(index, species) %>% count()
          for(i in 1:nrow(speciesAbundance)){
            dataSpeciesSampledGrids_i <- data.frame(Id=Grid_i,
                                                    sampleGridId = speciesAbundance$index[[i]],
                                                    speciesName = speciesAbundance$species[[i]],
                                                    abundance=speciesAbundance$n[[i]], 
                                                    stringsAsFactors=FALSE)
            dataSpeciesSampledGrids <- rbind(dataSpeciesSampledGrids, dataSpeciesSampledGrids_i)
          }
        }
      }
    }
    cat(str_c(Grid_i, ': done ', '\n'))
  }
  return(dataSpeciesSampledGrids)
}

# Function to split groups and name them
named_group_split <- function(.tbl, ...) {
  grouped <- group_by(.tbl, ...)
  names <- rlang::eval_bare(rlang::expr(paste(!!!group_keys(grouped), sep = " / ")))
  
  grouped %>% 
    group_split() %>% 
    rlang::set_names(names)
}
# This function will be used to return a named list will use it inside our `createDataForiNEXT`was created by [romainfrancois](https://github.com/romainfrancois) and can be found here: https://gist.github.com/romainfrancois/75df56ef682efaff5eee118450fb7a8c

# Function to split groups and name them
createDataForiNEXT <- function(data, gridsToInclude) {
  as_tibble(data) %>% 
    filter(Id %in% gridsToInclude) %>% 
    mutate(abundance=ifelse(abundance==0, 0, 1)) %>% 
    mutate(sampleGridId= str_c('X', sampleGridId, sep='')) %>%
    mutate(speciesName=str_replace(speciesName, ' ', '_')) %>% 
    group_by(Id,  add = TRUE) %>%
    pivot_wider(names_from = sampleGridId, 
                values_from = abundance,
                values_fill = list(abundance = 0)) %>% 
    select_if(~ !is.numeric(.) || sum(.) != 0) %>%
    named_group_split(Id) %>% 
    map(select_if, (~!is.numeric(.) || sum(.) != 0)) %>% 
    map(select, -Id) %>% 
    map(column_to_rownames, var='speciesName')
}

# Function to get the Cmax value.
# To determine Cmax, each sample within the grid unit was first extrapolated to double the reference sample size, then Cmax was calculated as the minimum among the coverage values obtained from those extrapolated samples

getCmax <- function(data_iNEXT) {
  Cmax = 1 
  for (grid in data_iNEXT$iNextEst){
    doubleSampleReference = max(grid$t)
    sampleCoverage = unique(grid$SC[grid$t==doubleSampleReference])
    Cmax = ifelse(sampleCoverage<Cmax, sampleCoverage, Cmax)
  }
  return(Cmax)
}

# Function to get the sampling coverage at C5% (5% percentile of sampling coverage at doubled sample sizes).
getPercentileSC <- function(data_iNEXT, i) {
  n <- nrow(data_iNEXT$DataInfo)
  x = (n*i)/ 100
  index = floor(x+1)
  SC_doubleSampleReference <- c()
  for (grid in data_iNEXT$iNextEst){
    doubleSampleReference = max(grid$t)
    sampleCoverage = unique(grid$SC[grid$t==doubleSampleReference])
    SC_doubleSampleReference <- c(SC_doubleSampleReference, sampleCoverage)
  }
  SC <- as_tibble(SC_doubleSampleReference) %>%
    arrange(value) %>% slice(index) %>% pull(value)
  return(SC)
}

# ------------------------------------------------------------------------------

#######
# RUN # 
#######

##### Tetrapods

Tetrapods_dataSpeciesSampledGrids <- getSpeciesSampledGrids(Grid_UY25, Tetrapods_GIS)

# 1) First we include all grids for analysis
Tetrapods_allGrids <- Tetrapods_dataSpeciesSampledGrids %>% distinct(Id) %>% pull
Tetrapods_allGrids_listByGrid <- createDataForiNEXT(Tetrapods_dataSpeciesSampledGrids,
                                                    Tetrapods_allGrids)

# 2) We then check using the function DataInfo from iNEXT those grids for which S.obs>6 & 'T'>6 & 'T'!= Q1 and run the function createDataForiNEXT again excluding the grid-cells that not match with our criteria (U = sum of species  incidences, T = number of sub-grids where at least one incidence was found, Q2 = number of duplicates, Q1 = number of uniques, Sobs = observed number of species

Tetrapods_gridsToInclude <- DataInfo(Tetrapods_allGrids_listByGrid, datatype = "incidence_raw") %>% 
  filter(S.obs>6 & `T`>6 & U!= Q1) %>% filter(SC>=0.1) %>% 
  pull((site))

# 3) Now we create a new list of grids, only including those that match our criteria
Tetrapods_listByGrid <- createDataForiNEXT(Tetrapods_dataSpeciesSampledGrids, Tetrapods_gridsToInclude)

# 4) run iNEXT
Tetrapods_iNEXT <-iNEXT(Tetrapods_listByGrid, q=c(0,1,2), datatype="incidence_raw")

# 5) calculate Cmax and C5% coverage 
Tetrapods_Cmax <- getCmax(Tetrapods_iNEXT)
Tetrapods_Richness_Cmax <- estimateD(Tetrapods_listByGrid, "incidence_raw", 
                                     base="coverage", level=Tetrapods_Cmax)

Tetrapods_C5 <- getPercentileSC(Tetrapods_iNEXT, 5)
Tetrapods_Richness_C5 <- estimateD(Tetrapods_listByGrid, "incidence_raw",
                                    base="coverage", level=Tetrapods_C5)


# 6) Join the data generated to the spatial data
Grid_UY25_Tetrapods <- left_join(x= left_join(x=Grid_UY25,
                                              y=Tetrapods_iNEXT$DataInfo %>%
                                                rename(Id=site), by='Id'),
                                 y=bind_cols(Tetrapods_Richness_Cmax,
                                             Tetrapods_Richness_C5 %>% rename_all(paste0, "1")) %>%
                                   filter(order==0 & order1==0) %>%
                                   rename(Id=site), by='Id')

# ------------------------------------------------------------------------------

#########
# PLOTS # 
#########

plot_iNext_Tetrapods_Sobs <- ggplot() + 
  geom_sf(data = Grid_UY25_Tetrapods, aes(fill=S.obs)) +
  scale_fill_distiller(palette = "Spectral", na.value="#ede8e8") +
  geom_sf(data = Uruguay, color='black', fill=NA) +
  labs(fill = 'Tetrapods\nObserved\nSpecies\nRichness') +
  theme_bw() 

plot_iNext_Tetrapods_SCmax <- ggplot() + 
  geom_sf(data = Grid_UY25_Tetrapods, aes(fill=qD)) +
  scale_fill_distiller(palette = "Spectral", na.value="#ede8e8") +
  geom_sf(data = Uruguay, color='black', fill=NA) +
  labs(fill = 'Tetrapods\nSpecies\nRichness\nat Cmax') +
  theme_bw() 

plot_iNext_Tetrapods <- grid.arrange(plot_iNext_Tetrapods_Sobs, plot_iNext_Tetrapods_SCmax, ncol=2)

ggsave('figures/plot_iNext_Tetrapods_UY25.png', plot_iNext_Tetrapods, width = 12, height = 7,  units = "in", dpi = 150)
