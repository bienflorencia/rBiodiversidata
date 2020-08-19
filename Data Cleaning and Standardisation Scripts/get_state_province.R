##############################################
#    Get StateProvince for a record event    #
##############################################

library(geonames)
library(tidyverse)

#####################################

# FUNCTION

options(geonamesUsername="YOUR-USER-NAME") # A (free) username is required and rate limits exist

getStateProvince <- function(lat, lng){
  subdivision <- try(GNcountrySubdivision(lat, lng, radius = "1", maxRows = 1), silent = TRUE)
  if(class(subdivision)=='try-error'){
    subdivision$adminName1 <- NA
  }
  else if (length(subdivision$adminName1)==0){
    subdivision$adminName1 <- NA
  }
  return(subdivision$adminName1)
}

#####################################
# RUN

# 1) Data from table
plantSpeciesList <- read_csv('plantSpeciesList.csv')

plantSpeciesListStateProvince <- plantSpeciesList %>%
  mutate(stateProvince=map2_chr(latitude, longitude, getStateProvince))

#                              species  latitude longitude  stateProvince
# 1                     Myosotis verna -31.38928 -57.97683          Salto
# 2               Buddleja grandiflora -31.41905 -58.01685          Salto
# 3                Buddleja thyrsoides -31.56710 -57.98045       Paysandú
# 4             Rhipsalis lumbricoides -33.23373 -54.74095 Treinta y Tres
# 5              Acicarpha tribuloides -32.14516 -53.72715    Cerro Largo
# 6  Triodanis perfoliata var. biflora -32.14239 -54.08473    Cerro Largo
# 7           Wahlenbergia linarioides -33.45775 -53.59280          Rocha
# 8                       Canna glauca -33.23373 -54.74095 Treinta y Tres
# 9                  Tarenaya titubans -32.14239 -54.08473    Cerro Largo
# 10            Monteverdia ilicifolia -33.23373 -54.74095 Treinta y Tres
# 11         Schaefferia argentinensis -32.63210 -54.37416    Cerro Largo
# 12            Dysphania ambrosioides -32.63210 -54.37416    Cerro Largo
# 13                  Dysphania retusa -32.63210 -54.37416    Cerro Largo
# 14          Crocanthemum brasiliense -31.02921 -55.44948         Rivera
# 15              Terminalia australis -34.10121 -53.87237          Rocha
# 16                    Butia capitata -34.10121 -53.87237          Rocha
# 17             Lithraea brasiliensis -32.92000 -54.47000 Treinta y Tres
# 18 Schinus engleri var. uruguayensis -32.23799 -53.78088    Cerro Largo
# 19                  Berberis laurina -32.23398 -53.76951    Cerro Largo
# 20                Cereus uruguayanus -32.19820 -53.81476    Cerro Largo
# 21                     Parodia scopa -32.19938 -53.84135    Cerro Largo
# 22             Opuntia arechavaletae -32.18818 -53.83758    Cerro Largo
# 23                 Ephedra tweediana -32.17102 -53.83726    Cerro Largo
# 24          Tripodanthus acutifolius -32.18414 -53.87048    Cerro Largo
# 25                  Sida rhombifolia -32.18175 -53.85627    Cerro Largo
# 26                  Myrsine coriacea -32.23649 -53.68103    Cerro Largo
# 27               Myrsine laetevirens -32.16929 -53.86418    Cerro Largo
# 28          Myrrhinium atropurpureum -32.13886 -53.83785    Cerro Largo
# 29                 Colletia paradoxa -32.20208 -53.85813    Cerro Largo
# 30                  Scutia buxifolia -32.35171 -53.81435    Cerro Largo
# 31                 Allophylus edulis -32.35330 -53.70419    Cerro Largo
# 32                  Dodonaea viscosa -32.35330 -53.70419    Cerro Largo
# 33               Solanum mauritianum -32.27338 -53.69445    Cerro Largo
# 34               Daphnopsis racemosa -32.27398 -53.68016    Cerro Largo
# 35                       Celtis tala -32.27460 -53.71590    Cerro Largo
# 36                    Lantana camara -32.37475 -53.76767    Cerro Largo
# 37                Eryngium nudicaule -32.35258 -53.75176    Cerro Largo
# 38           Hydrocotyle bonariensis -32.33845 -53.73857    Cerro Largo
# 39                 Baccharis trimera -32.32144 -53.68658    Cerro Largo
# 40           Chaptalia piloselloides -32.31271 -53.70205    Cerro Largo
# 41             Chevreulia sarmentosa -32.30434 -53.72184    Cerro Largo
# 42                Conyza bonariensis -32.28107 -53.74259    Cerro Largo
# 43              Gamochaeta americana -32.28107 -53.74259    Cerro Largo
# 44                   Soliva sessilis -34.42644 -53.86558          Rocha
# 45                 Lobelia hederacea -34.40000 -53.76667          Rocha
# 46              Dichondra macrocalyx -34.40000 -53.76667          Rocha
# 47                Evolvulus sericeus -34.40000 -53.76667          Rocha
# 48               Equisetum giganteum -34.76786 -55.59992      Canelones
# 49             Trifolium polymorphum -34.78222 -54.52861          Rocha
# 50                   Herbertia lahue -34.42403 -53.86486          Rocha
