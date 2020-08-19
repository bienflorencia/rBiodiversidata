##############################################
#    Get getEventDate for a record event     #
##############################################

library(lubridate)
library(tidyverse)

#####################################

# FUNCTION

getEventDate <- function(year, month, day) {
  eventDate <- ifelse(!is.na(year)&!is.na(month)&is.na(day),
                      str_sub(ymd(paste(year, month, sep='-'), truncated = 1), 1, 7),
                      ifelse(!is.na(year)&is.na(month)&is.na(day), 
                             as.character(year), as.character(make_date(year, month, day))))
  return(eventDate)
}

#####################################
# RUN

# 1) Data from table

plantSpeciesList <- read_csv('plantSpeciesList.csv')

plantSpeciesEventDate <-  plantSpeciesList %>% 
  mutate(eventDate=getEventDate(year, month, day))

#                              species  latitude longitude day month year  eventDate
# 1                     Myosotis verna -31.38928 -57.97683   2     3 1987 1987-03-02
# 2               Buddleja grandiflora -31.41905 -58.01685   5     9 1999 1999-09-05
# 3                Buddleja thyrsoides -31.56710 -57.98045  NA     1 2011    2011-01
# 4             Rhipsalis lumbricoides -33.23373 -54.74095   3     2 2014 2014-02-03
# 5              Acicarpha tribuloides -32.14516 -53.72715   2     2 2000 2000-02-02
# 6  Triodanis perfoliata var. biflora -32.14239 -54.08473   5     5 1945 1945-05-05
# 7           Wahlenbergia linarioides -33.45775 -53.59280  12     3 1972 1972-03-12
# 8                       Canna glauca -33.23373 -54.74095   5    12 1987 1987-12-05
# 9                  Tarenaya titubans -32.14239 -54.08473  NA    NA   NA       <NA>
# 10            Monteverdia ilicifolia -33.23373 -54.74095  25    11 2003 2003-11-25
# 11         Schaefferia argentinensis -32.63210 -54.37416   6     7 1970 1970-07-06
# 12            Dysphania ambrosioides -32.63210 -54.37416  NA    10 1964    1964-10
# 13                  Dysphania retusa -32.63210 -54.37416  11     1 1978 1978-01-11
# 14          Crocanthemum brasiliense -31.02921 -55.44948  12     4 2019 2019-04-12
# 15              Terminalia australis -34.10121 -53.87237  NA    NA 2005       2005
# 16                    Butia capitata -34.10121 -53.87237  10     6 1950 1950-06-10
# 17             Lithraea brasiliensis -32.92000 -54.47000   9     7 1977 1977-07-09
# 18 Schinus engleri var. uruguayensis -32.23799 -53.78088  18     8 1992 1992-08-18
# 19                  Berberis laurina -32.23398 -53.76951  12     9 1892 1892-09-12
# 20                Cereus uruguayanus -32.19820 -53.81476  15     5 2008 2008-05-15
# 21                     Parodia scopa -32.19938 -53.84135  NA    NA 1975       1975
# 22             Opuntia arechavaletae -32.18818 -53.83758   2    12 1969 1969-12-02
# 23                 Ephedra tweediana -32.17102 -53.83726   3     6 1983 1983-06-03
# 24          Tripodanthus acutifolius -32.18414 -53.87048   1    11 2004 2004-11-01
# 25                  Sida rhombifolia -32.18175 -53.85627   5     7 1990 1990-07-05
# 26                  Myrsine coriacea -32.23649 -53.68103  18    10 1935 1935-10-18
# 27               Myrsine laetevirens -32.16929 -53.86418  22     1 1962 1962-01-22
# 28          Myrrhinium atropurpureum -32.13886 -53.83785  NA     4 1977    1977-04
# 29                 Colletia paradoxa -32.20208 -53.85813  28     5 1877 1877-05-28
# 30                  Scutia buxifolia -32.35171 -53.81435   6    11 1993 1993-11-06
# 31                 Allophylus edulis -32.35330 -53.70419   9     7 1960 1960-07-09
# 32                  Dodonaea viscosa -32.35330 -53.70419  15    10 1954 1954-10-15
# 33               Solanum mauritianum -32.27338 -53.69445  12     1 1968 1968-01-12
# 34               Daphnopsis racemosa -32.27398 -53.68016   5     4 1948 1948-04-05
# 35                       Celtis tala -32.27460 -53.71590  30     5 1975 1975-05-30
# 36                    Lantana camara -32.37475 -53.76767  25     6 1990 1990-06-25
# 37                Eryngium nudicaule -32.35258 -53.75176  NA     7 1890    1890-07
# 38           Hydrocotyle bonariensis -32.33845 -53.73857   3     8 2006 2006-08-03
# 39                 Baccharis trimera -32.32144 -53.68658  11     9 1973 1973-09-11
# 40           Chaptalia piloselloides -32.31271 -53.70205  12     5 1967 1967-05-12
# 41             Chevreulia sarmentosa -32.30434 -53.72184  NA    NA 1981       1981
# 42                Conyza bonariensis -32.28107 -53.74259   9    12 2022 2022-12-09
# 43              Gamochaeta americana -32.28107 -53.74259  18     6 2008 2008-06-18
# 44                   Soliva sessilis -34.42644 -53.86558  12    11 1953 1953-11-12
# 45                 Lobelia hederacea -34.40000 -53.76667  15     5 1980 1980-05-15
# 46              Dichondra macrocalyx -34.40000 -53.76667   4     3 1995 1995-03-04
# 47                Evolvulus sericeus -34.40000 -53.76667  NA    12 1895    1895-12
# 48               Equisetum giganteum -34.76786 -55.59992   3     6 2011 2011-06-03
# 49             Trifolium polymorphum -34.78222 -54.52861   1    11 1978 1978-11-01
# 50                   Herbertia lahue -34.42403 -53.86486  31    12 1972 1972-12-31
