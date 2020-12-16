# -----------------------------------
# Author: Florencia Grattarola
# Date: 7 December 2020
# Contact: flograttarola@gmail.com
# -----------------------------------

# Spatial correlations

### Description
# To measure the association between the number of records (**N**) and the species-richness patterns (**SR**) per grid-cell, and each pair of hotspots metrics, we used corrected Pearson's correlation for spatial autocorrelation, from the package SpatialPack.

# ------------------------------------------------------------------------------

#############
# LIBRARIES #
#############

library(SpatialPack)
library(sf)
library(tidyverse)

# ------------------------------------------------------------------------------

########
# DATA #
########

Grid_UY50_Amphibia_NA <- Grid_UY50_Amphibia %>% filter(N!=0)
XY_50_Amphibia <- st_coordinates(st_centroid(Grid_UY50_Amphibia_NA))

# ------------------------------------------------------------------------------

#############
# FUNCTIONS #
#############

# 

# ------------------------------------------------------------------------------

#######
# RUN # 
#######

# 1) Amphibia (Tetrapods)

Am_25_N_SR <- modified.ttest(Grid_UY50_Amphibia_NA$N, Grid_UY50_Amphibia_NA$SR, XY_50_Amphibia, nclass = 10)
Am_25_N_E <- modified.ttest(Grid_UY50_Amphibia_NA$N, Grid_UY50_Amphibia_NA$rswSR, XY_50_Amphibia, nclass = 10)
Am_25_N_TN <- modified.ttest(Grid_UY50_Amphibia_NA$N, Grid_UY50_Amphibia_NA$threatenedNumber, XY_50_Amphibia, nclass = 10)
Am_25_N_TP <- modified.ttest(Grid_UY50_Amphibia_NA$N, Grid_UY50_Amphibia_NA$threatenedProportion, XY_50_Amphibia, nclass = 10)

Am_25_SR_E <- modified.ttest(Grid_UY50_Amphibia_NA$SR, Grid_UY50_Amphibia_NA$rswSR, XY_50_Amphibia, nclass = 10)
Am_25_SR_TN <- modified.ttest(Grid_UY50_Amphibia_NA$SR, Grid_UY50_Amphibia_NA$threatenedNumber, XY_50_Amphibia, nclass = 10)
Am_25_SR_TP <- modified.ttest(Grid_UY50_Amphibia_NA$SR, Grid_UY50_Amphibia_NA$threatenedProportion, XY_50_Amphibia, nclass = 10)

Am_25_E_TN <- modified.ttest(Grid_UY50_Amphibia_NA$rswSR, Grid_UY50_Amphibia_NA$threatenedNumber, XY_50_Amphibia, nclass = 10)
Am_25_E_TP <- modified.ttest(Grid_UY50_Amphibia_NA$rswSR, Grid_UY50_Amphibia_NA$threatenedProportion, XY_50_Amphibia, nclass = 10)

Am_CORR <- data.frame(Group = rep('Amphibia', 9),
                     Cor = c('N_SR', 'N_E', 'N_TN', 'N_TP',
                             'SR_E', 'SR_TN', 'SR_TP', 'E_TN', 'E_TP'),
                     R = c(Am_25_N_SR$corr, Am_25_N_E$corr, Am_25_N_TN$corr, Am_25_N_TP$corr,
                           Am_25_SR_E$corr, Am_25_SR_TN$corr, Am_25_SR_TP$corr,
                           Am_25_E_TN$corr, Am_25_E_TP$corr),
                     p.value = c(Am_25_N_SR$p.value, Am_25_N_E$p.value, Am_25_N_TN$p.value, Am_25_N_TP$p.value,
                                 Am_25_SR_E$p.value, Am_25_SR_TN$p.value, Am_25_SR_TP$p.value,
                                 Am_25_E_TN$p.value, Am_25_E_TP$p.value),
                     Fstat = c(Am_25_N_SR$Fstat, Am_25_N_E$Fstat, Am_25_N_TN$Fstat, Am_25_N_TP$Fstat,
                               Am_25_SR_E$Fstat, Am_25_SR_TN$Fstat, Am_25_SR_TP$Fstat,
                               Am_25_E_TN$Fstat, Am_25_E_TP$Fstat),
                     dof = c(Am_25_N_SR$dof, Am_25_N_E$dof, Am_25_N_TN$dof, Am_25_N_TP$dof,
                             Am_25_SR_E$dof, Am_25_SR_TN$dof, Am_25_SR_TP$dof,
                             Am_25_E_TN$dof, Am_25_E_TP$dof))


Am_CORR

# ------------------------------------------------------------------------------

#########
# PLOTS # 
#########

#