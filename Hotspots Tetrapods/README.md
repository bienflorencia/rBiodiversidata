The following scripts are being used for a paper in prep  with the 
running title: “Large-scale patterns of vertebrate biodiversity of 
Uruguay: are biodiversity hotspots real or fabricated?”.


Analyses
--------

1.  [Hotspots congruence](#1-hotspots-congruence)  
2.  [Identification of ‘areas of ignorance’](#2-areas-of-ignorance)
3.  [Spatial correlations](#3-spatial-correlations)

To run this code you will need the following R packages:

    library(vegan)
    library(spaa)
    library(wesanderson)
    library(extrafont)
    library(lctools)
    library(SpatialPack)
    library(tidyverse)

## 1) Hotspots congruence

To analyse the extent of congruence between the biodiversity hotspots
(*SR*: species richnes, *ER*:endemic richness and *TP*: threat
proportion ) we varied both the size of the sampling unit (size of the
grid-cell in km) and the criterion to define a hotspots (% of
area/number of cells occupied by hotspots). The level of congruence was
then addressed by calculating the number of overlapping grid-cells
according to the varying definition criterion.

### Function

The function `get_sharedArea` sorts the grid-cells from high to low
values of richness and at each definition criterion (from 0 to 100% by
0,5%), computes the percentage of congruence as the number of matching
grid-cells over the total number of unique cells. The congruence
percentage will be calculated as
$matching-grid-cells \* 100 \\over total-number-of-unique-cells$

    get_sharedArea <- function(dataset){
      sharedArea <- data.frame(gridPercentage = double(),
                               congruencePercentage= double(),
                               stringsAsFactors=FALSE)
      
      hotspotAreaDefinition <- (nrow(dataset)*seq(1,100,0.5))/100
      
      for(i in hotspotAreaDefinition) {
        GridID_SR <- dataset %>% 
          arrange(desc(SR)) %>% 
          head(i) %>% 
          select(GridID)
        GridID_TP <- dataset %>% 
          arrange(desc(TP)) %>% 
          head(i) %>% 
          select(GridID)
        GridID_ER <- dataset %>% 
          arrange(desc(ER)) %>% 
          head(i) %>% 
          select(GridID)
        
        cumulativeGrids <- nrow(unique(bind_rows(GridID_SR, 
                                                GridID_TP, 
                                                GridID_ER)))
        
        grid_sharedArea <- data.frame(gridPercentage = (i*100)/nrow(dataset),
                                 congruencePercentage= ifelse(floor(i)!=0, 
                                                              ((nrow(Reduce(intersect, 
                                                                            list(GridID_SR, 
                                                                                 GridID_TP, 
                                                                                 GridID_ER))))*100)/
                                                                cumulativeGrids, 0), stringsAsFactors=FALSE)
        sharedArea <- rbind(sharedArea, grid_sharedArea)
      }
      return(sharedArea)
    }

### Working example

Let's calculate the hotspots congruence using the data of amphibians of
Uruguay, for three different grid-cell sizes: 12.5x12.5km, 25x25km and
50x50km.

    Amphibia_125.GRIDs <- read_csv('Amphibia_UY125.csv')
    Amphibia_25.GRIDs <- read_csv('Amphibia_UY25.csv')
    Amphibia_50.GRIDs <- read_csv('Amphibia_UY50.csv')

Each table has a GridID and the values for the 4 variables NR, SR, TP
and ER for each grid. For instance, the table for Amphibia at 50x50km
scale looks like this:

    ## # A tibble: 93 x 5
    ##    GridID    NR    SR      TP    ER
    ##     <dbl> <dbl> <dbl>   <dbl> <dbl>
    ##  1      1     6     4 0       0.107
    ##  2      2   188    19 0.0372  7.24 
    ##  3      3    45    19 0.0222  1.46 
    ##  4      4    70    22 0.114   2.74 
    ##  5      5     9     8 0       0.241
    ##  6      6    12     8 0       0.250
    ##  7      7    20    14 0.05    0.944
    ##  8      8   105    24 0.00952 3.94 
    ##  9      9    75    20 0       2.21 
    ## 10     10   131    22 0.0305  5.27 
    ## # ... with 83 more rows

Now we run the function `get_sharedArea` for each grid-cell size dataset

    Amphibia_50_sharedArea <- get_sharedArea(Amphibia_50.GRIDs)
    Amphibia_25_sharedArea <- get_sharedArea(Amphibia_25.GRIDs)
    Amphibia_125_sharedArea <- get_sharedArea(Amphibia_125.GRIDs)

And to finish, we plot

    pal <- wes_palette(n=3, name='Darjeeling1')
    ggplot(Amphibia_50_sharedArea, aes(gridPercentage, congruencePercentage)) +
      geom_line(color=pal[1], size=1) +
      geom_line(data=Amphibia_25_sharedArea, aes(gridPercentage, congruencePercentage), color=pal[2], size=1) +
      geom_line(data=Amphibia_125_sharedArea, aes(gridPercentage, congruencePercentage), color=pal[3], size=1) +
      geom_vline(xintercept=2.5, linetype="dashed", color = "black",  alpha = .5) +
      geom_vline(xintercept=10, linetype="dashed", color = "black",  alpha = .5) +
      labs(x='Hotspots definition (% area occupied by hotspots)', y= 'Congruence (% of area shared by hotsposts)') +
      theme_bw() +
      theme(legend.position = c(0.06, 0.75))+
      theme(text=element_text(family='Calibri', size = 12)) +
      guides(colour = "colorbar", size = "legend", shape = "legend") +
      theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
            axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0))) 

![](Hotspots_Tetrapods_files/figure-markdown_strict/unnamed-chunk-5-1.png)

> Extent of congruence between species richness hotspots, endemic
> richness hotspots and threat richness hotspots, for amphibian.
> Relationship between the criterion used to define hotspots and
> congruence for the three different grid-cells size 50x50km (red line),
> 25x25km (green line) and 12.5x12.5km (yellow line). Criteria are based
> on the percentage of land covered by hotspots. Congruence is the
> number of cells that are hotspots for all three diversity indices, as
> a percentage of the total hotspot area. Vertical dashed line shows
> 2.5% and 10% hotspot criterion.

------------------------------------------------------------------------

<br>

## 2) Areas of ignorance

To identify the areas of ignorance we quantified the levels of inventory
incompleteness for each group by using curvilinearity of smoothed
species accumulation curves (SACs). This method assumes that SACs of
poorly sampled grids tend towards a straight line, while those of better
sampled ones have a higher degree of curvature. As a proxy for inventory
incompleteness we calculated the degree of curvilinearity as the mean
slope of the last 10% of SACs.

### Function

The function `get_gridsSlopes` finds a species accumulation curve (SAC)
for each grid-cell using the method ‘exact’ of the function `specaccum`
of the vegan package and then calculates the degree of curvilinearity as
the mean slope of the last 10% of the curve. We considered grids with
slope values &gt; 0.05 as under-sampled and those with slope values ≤
0.05 as well sampled.

    get_gridsSlopes <- function(data_abundance){
      GridSlope <- data.frame(Grid=integer(), Slope=numeric(), stringsAsFactors=FALSE)
      data_abundance <- as.data.frame(data_abundance) #if it is a tibble
      data_abundance$abundance <- as.integer(1)
      cells <- unique(data_abundance$cell_id)
      splistT <- list()
      spaccum <- list()
      slope <- list()
      for (i in cells) {
        splist <- data_abundance[data_abundance$cell_id == i,c(2:4)]
        splistT[[i]] = data2mat(splist) 
        spaccum[[i]] = specaccum(splistT[[i]], method = "exact")
        slope[[i]] = (spaccum[[i]][[4]][length(spaccum[[i]][[4]])]-
                        spaccum[[i]][[4]][ceiling(length(spaccum[[i]][[4]])*0.9)])/
          (length(spaccum[[i]][[4]])-
             ceiling(length(spaccum[[i]][[4]])*0.9))
        GridSlope_i <- data.frame(Grid=i, Slope=slope[[i]], stringsAsFactors=FALSE)
        GridSlope <- rbind(GridSlope, GridSlope_i)
      }  
      return(GridSlope)
    }

### Working example

Let's calculate the SACs using the data of birds of Uruguay, for the
grid-cell size of 25x25km. To run the function we need to have a list of
grid-cells, sample numbers and species. This is, a list of species
recorded for each grid-cell. I have created a function in Python to
extract this list of samples/species per grid cell, check it here:
![abundances.py](abundances.py)()

    Reptilia_25.SACs <- read_tsv('Reptilia_UY25_abundance.txt', col_names = FALSE) %>% 
      rename(cell_id=X1, sample=X2, species=X3)

The data looks like this:

    ## # A tibble: 2,381 x 3
    ##    cell_id sample species                
    ##      <dbl>  <dbl> <chr>                  
    ##  1       1      1 Hydromedusa tectifera  
    ##  2       1      2 Liolaemus wiegmannii   
    ##  3       1      3 Liolaemus wiegmannii   
    ##  4       1      4 Liolaemus wiegmannii   
    ##  5       1      5 Cercosaura schreibersii
    ##  6       1      6 Cercosaura schreibersii
    ##  7       1      7 Chelonia mydas         
    ##  8       1      8 Hydromedusa tectifera  
    ##  9       1      9 Liolaemus wiegmannii   
    ## 10       1     10 Lygophis anomalus      
    ## # ... with 2,371 more rows

Now we run the function `get_gridsSlopes` for the data at 25x25
resolution scale

    Reptilia_25.incompleteness <- get_gridsSlopes(Reptilia_25.SACs)

Let's check which grid-cells are well sampled and plot the accumulation
curve

    Reptilia_25.incompleteness %>% 
      filter(Slope<=0.05)

    ##   Grid      Slope
    ## 1    2 0.04363527

To plot the SAC of the well sampled grid-cell we extract the data for
that grid-cell and run the SAC for the subset.

    Reptilia_25.wellsampled <- Reptilia_25.SACs %>% 
      filter(cell_id==2) %>% 
      mutate(abundance=as.integer(1), observation = 1:n()) %>% 
      select(observation, species, abundance)

    Reptilia_25.specaccum <- data2mat(as.data.frame(Reptilia_25.wellsampled)) 
    Reptilia_25.specaccum <- specaccum(Reptilia_25.specaccum, method = "exact")

    Reptilia_25.specaccum_plot <- tibble(sites=Reptilia_25.specaccum$sites, 
                                       richness=Reptilia_25.specaccum$richness,
                                       sd=Reptilia_25.specaccum$sd)

    ggplot(Reptilia_25.specaccum_plot, aes(x=sites, y=richness)) +
      geom_ribbon(aes(ymin=richness-sd, ymax=richness+sd), alpha =0.15) +
      geom_line(linetype=1, size=1) +
      geom_vline(aes(xintercept=max(sites)), linetype=2, color = "black",  alpha = .5) +
      geom_vline(aes(xintercept=0.9*max(sites)), linetype=2, color = "black",  alpha = .5) +
      theme_bw() +
      theme(axis.text=element_text(color='black', size=11, face='bold'),
            text=element_text(family='Calibri')) +
      labs(x='', y= '')

![](Hotspots_Tetrapods_files/figure-markdown_strict/unnamed-chunk-11-1.png)

> Plot of the species accumulation curve (SAC) of the well sampled
> grid-cell for reptilians of Uruguay using the 25 × 25 km grid-cell
> resolution. Slope value &lt;=0.05 was calculated given the degree of
> curvilinearity as the mean slope of the last 10% of the curve (shown
> between dashed vertical lines).

------------------------------------------------------------------------

<br>

## 3) Spatial correlations

To measure the association between the number of records (**NR**) and
the species-richness patterns (**SR**) per grid-cell, we need to test
each variable for spatial autocorrelation using Moran’s I and then, if
the are autocorrelated, conduct spatially corrected correlations.

### Working example

First we need the spatial data (coordinates) of the grid-cells. Next
step is to filter cells without records (to remove double zeros).
Finally, we test autocorrelation for each of the variables, number of
records and species-richness.

    Amphibia_25.nonzero <- Amphibia_25.GRIDs %>% 
      bind_cols(., read_csv('Grid_UY_25_XY.csv')) %>%  
      filter(NR !=0)

    XY <- Amphibia_25.nonzero %>% select(X, Y)

    Amphibia_25.autocorrelation.NR <- moransI(XY, Bandwidth=6, Amphibia_25.nonzero$NR)
    Amphibia_25.autocorrelation.SR <- moransI(XY, Bandwidth=6, Amphibia_25.nonzero$SR)

A positive, statistically significant value, indicates a positive
spatial autocorrelation

    ## # A tibble: 2 x 5
    ##   Variable Morans.I Expected.I     z   pvalue
    ##   <chr>       <dbl>      <dbl> <dbl>    <dbl>
    ## 1 NR          0.244   -0.00508  6.40 1.55e-10
    ## 2 SR          0.257   -0.00508  6.73 1.66e-11

Given we found positive autocorrelation for our data, the correlations
need to be conducted using a corrected Pearson’s correlation for spatial
autocorrelation, correcting the degrees of freedom of the analyses

    modified.ttest(Amphibia_25.nonzero$NR, Amphibia_25.nonzero$SR, XY, nclass = 10)

    ## 
    ## Corrected Pearson's correlation for spatial autocorrelation
    ## 
    ## data: x and y ; coordinates: X and Y 
    ## F-statistic: 205.5696 on 1 and 94.2604 DF, p-value: 0 
    ## alternative hypothesis: true autocorrelation is not equal to 0
    ## sample correlation: 0.828

Now let's plot both variables

    ggplot(Amphibia_25.nonzero, aes(x=NR, y=SR)) + 
      geom_point(size=4) +
      theme_bw() +
      theme(text=element_text(family='Calibri', size=12)) +
      labs(x='Number of Records', y= 'Species Richness') +
      geom_text(x=90, y=5, label="r=0.828", family='Calibri',  size=10)

![](Hotspots_Tetrapods_files/figure-markdown_strict/unnamed-chunk-15-1.png)

> Relationship between sampling effort (number of records per grid-cell)
> and the species-richnes for amphibians, showing the spatial
> correlation coefficient r.

------------------------------------------------------------------------

<br>

And that's all !
----------------
