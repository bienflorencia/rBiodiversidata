################################################
#             Check Species Names              #
#   Get taxonomic information for a species    #
################################################

library(WorldFlora)
library(tidyverse)

#####################################

# TAXONOMIC DATA SOURCES
WFO.file.RK <- file.choose() # file='classification.txt'

#####################################
# RUN

# 1) Species List
plants <- c('Erithrina cristagalli', 'Ludwigia peploides subsp. montevidensis', 'Dychondra microcalix', 'Wrong species')

plantsCheck <- WFO.match(spec.data=plants,
                         WFO.file=WFO.file.RK,
                         exclude.infraspecific=TRUE,
                         infraspecific.excluded = c("cultivar.", "sect.", "subf.",
                                                    "subg.", "subvar."),
                         Fuzzy.max = 15, Fuzzy.shortest = TRUE, counter = 1, verbose=TRUE)

# Reading WFO data
# |--------------------------------------------------|
# |==================================================|
# |--------------------------------------------------|
# |==================================================|
#
# Reached record # 1
# Fuzzy matches for  Erithrina cristagalli were:  Erythrina crista-galli var. hasskarlii, Erythrina crista-galli var. leucochlora, Erythrina crista-galli var. inermis, Erythrina crista-galli, Erythrina crista-galli var. crista-galli
# Best fuzzy matches for  Erithrina cristagalli were:  Erythrina crista-galli
# Reached record # 2
# Reached record # 3
# Fuzzy matches for  Dychondra microcalix were:  Dichondra microcalyx
# Reached record # 4
# Fuzzy matches for Wrong species were only found for first term
# Too many (482) fuzzy matches for Wrong species, including Crepis tsarongensis
# 
# Checking new accepted IDs
# Reached record # 1
# Reached record # 2
# Reached record # 3
# Reached record # 4
#
# Warning message:
# In data.table::fread(WFO.file, encoding = "UTF-8") :
# Found and resolved improper quoting out-of-sample. First healed line 118: <<wfo-0000000117		Hieracium onosmoides subsp. sphaerianthum	SUBSPECIES	wfo-0000034880	(Arv.-Touv.) Zahn	Asteraceae	Hieracium	onosmoides	sphaerianthum	subsp.		"Zahn, in Engler, Pflanzenr. 82. 1923." 1676 1923	Accepted			2012-02-11	2012-02-11	http://www.theplantlist.org/tpl1.1/record/gcc-10011>>. If the fields are not quoted (e.g. field separator does not appear within any field), try quote="" to avoid this warning.

WFO.one(plantsCheck) %>%
  select(spec.name.ORIG, scientificName, scientificNameAuthorship,
         family, genus, specificEpithet, infraspecificEpithet,
         taxonRank, taxonID) %>% 
  rename(previousIdentification=spec.name.ORIG)

#                    previousIdentification                          scientificName scientificNameAuthorship
# 1                   Erithrina cristagalli                  Erythrina crista-galli                       L.
# 2 Ludwigia peploides subsp. montevidensis Ludwigia peploides subsp. montevidensis      (Spreng.) P.H.Raven
# 3                    Dychondra microcalix                    Dichondra microcalyx      (Hallier f.) Fabris
# 4                           Wrong species                                                                 
#
#           family     genus specificEpithet infraspecificEpithet  taxonRank        taxonID
# 1       Fabaceae Erythrina    crista-galli                         SPECIES wfo-0000180641
# 2     Onagraceae  Ludwigia       peploides        montevidensis SUBSPECIES wfo-0000445448
# 3 Convolvulaceae Dichondra      microcalyx                         SPECIES wfo-0001298629
# 4                                                                                        


# 2) Data from table
plantSpeciesList <- read_csv('plantSpeciesList.csv') %>% data.frame() # needs to be a data.frame

plantSpeciesListCheck <- WFO.match(spec.data=plantSpeciesList,
                                   spec.name = 'species', # the name of the column with taxonomic names
                                   WFO.file=WFO.file.RK,
                                   exclude.infraspecific=TRUE,
                                   infraspecific.excluded = c("cultivar.", "sect.", "subf.",
                                                              "subg.", "subvar."),
                                   Fuzzy.max = 15, Fuzzy.shortest = TRUE, counter = 1, verbose=TRUE)

# Reading WFO data
# |--------------------------------------------------|
# |==================================================|
# |--------------------------------------------------|
# |==================================================|
# Reached record # 1
# Reached record # 2
# Reached record # 3
# Reached record # 4
# Reached record # 5
# Reached record # 6
# Reached record # 7
# Reached record # 8
# Reached record # 9
# Fuzzy matches for Tarenaya titubans were only found for first term
# Fuzzy matches for  Tarenaya titubans were:  Tarenaya hassleriana, Tarenaya virens, Tarenaya parviflora, Tarenaya longipes, Tarenaya costaricensis, Tarenaya spinosa
# Best fuzzy matches for  Tarenaya titubans were:  Tarenaya virens
# Reached record # 10
# Fuzzy matches for Monteverdia ilicifolia were only found for first term
# Fuzzy matches for  Monteverdia ilicifolia were:  Dendrophylax monteverdi, Piper monteverdeanum, Ardisia monteverdeana, Campylocentrum monteverdi, Aeranthes monteverdi, Harrisella monteverdi, Monteverdia buxifolia, Icacorea monteverdeana
# Best fuzzy matches for  Monteverdia ilicifolia were:  Monteverdia buxifolia
# Reached record # 11
# Reached record # 12
# Reached record # 13
# Reached record # 14
# Fuzzy matches for  Crocanthemum brasiliense were:  Crocanthemum brasiliensis
# Reached record # 15
# Reached record # 16
# Reached record # 17
# Reached record # 18
# Fuzzy matches for Schinus engleri var. uruguayensis were only found for first 2 terms
# Fuzzy matches for  Schinus engleri var. uruguayensis were:  Sarcochilus englerianus, Anisochilus engleri, Schinus engleri, Schinus engleri var. engleri
# Best fuzzy matches for  Schinus engleri var. uruguayensis were:  Schinus engleri var. engleri
# Reached record # 19
# Reached record # 20
# Reached record # 21
# Reached record # 22
# Fuzzy matches for  Opuntia arechavaletae were:  Opuntia arechavaletai
# Reached record # 23
# Fuzzy matches for  Ephedra tweediana were:  Ephedra tweedieana
# Reached record # 24
# Reached record # 25
# Reached record # 26
# Reached record # 27
# Reached record # 28
# Reached record # 29
# Reached record # 30
# Reached record # 31
# Reached record # 32
# Reached record # 33
# Reached record # 34
# Reached record # 35
# Reached record # 36
# Reached record # 37
# Reached record # 38
# Reached record # 39
# Reached record # 40
# Reached record # 41
# Reached record # 42
# Reached record # 43
# Reached record # 44
# Reached record # 45
# Reached record # 46
# Reached record # 47
# Reached record # 48
# Reached record # 49
# Reached record # 50
# 
# Checking new accepted IDs
# Reached record # 1
# Reached record # 2
# Reached record # 3
# Reached record # 4
# Reached record # 5
# Reached record # 6
# Reached record # 7
# Reached record # 8
# Reached record # 9
# Reached record # 10
# Reached record # 11
# Reached record # 12
# Reached record # 13
# Reached record # 14
# Reached record # 15
# Reached record # 16
# Reached record # 17
# Reached record # 18
# Reached record # 19
# Reached record # 20
# Reached record # 21
# Reached record # 22
# Reached record # 23
# Reached record # 24
# Reached record # 25
# Reached record # 26
# Reached record # 27
# Reached record # 28
# Reached record # 29
# Reached record # 30
# Reached record # 31
# Reached record # 32
# Reached record # 33
# Reached record # 34
# Reached record # 35
# Reached record # 36
# Reached record # 37
# Reached record # 38
# Reached record # 39
# Reached record # 40
# Reached record # 41
# Reached record # 42
# Reached record # 43
# Reached record # 44
# Reached record # 45
# Reached record # 46
# Reached record # 47
# Reached record # 48
# Reached record # 49
# Reached record # 50
# Reached record # 51
# Reached record # 52
# Reached record # 53
# Reached record # 54
# Reached record # 55
# Warning message:
# In data.table::fread(WFO.file, encoding = "UTF-8") :
# Found and resolved improper quoting out-of-sample. First healed line 118: <<wfo-0000000117		Hieracium onosmoides subsp. sphaerianthum	SUBSPECIES	wfo-0000034880	(Arv.-Touv.) Zahn	Asteraceae	Hieracium	onosmoides	sphaerianthum	subsp.		"Zahn, in Engler, Pflanzenr. 82. 1923." 1676 1923	Accepted			2012-02-11	2012-02-11	http://www.theplantlist.org/tpl1.1/record/gcc-10011>>. If the fields are not quoted (e.g. field separator does not appear within any field), try quote="" to avoid this warning.

WFO.one(plantSpeciesListCheck) %>%
  select(previousIdentification=species.ORIG, scientificName, scientificNameAuthorship,
         family, genus, specificEpithet, infraspecificEpithet,
         taxonRank, taxonID)


# You could explore which species name are different

WFO.one(plantSpeciesListCheck) %>%
  select(previousIdentification=species.ORIG, scientificName, scientificNameAuthorship,
         family, genus, specificEpithet, infraspecificEpithet,
         taxonRank, taxonID) %>% 
  mutate(nameCheck=ifelse(previousIdentification==scientificName, 'Same', 'Different')) %>% 
  filter(nameCheck=='Different') %>% select(previousIdentification, scientificName)

#               previousIdentification                      scientificName
# 1             Rhipsalis lumbricoides              Lepismium lumbricoides
# 2  Triodanis perfoliata var. biflora Triodanis perfoliata subsp. biflora
# 3                  Tarenaya titubans                       Cleome virens
# 4             Monteverdia ilicifolia                  Maytenus buxifolia
# 5                   Dysphania retusa                 Chenopodium retusum
# 6           Crocanthemum brasiliense           Crocanthemum brasiliensis
# 7  Schinus engleri var. uruguayensis                     Schinus engleri
# 8              Opuntia arechavaletae               Opuntia arechavaletai
# 9                  Ephedra tweediana                  Ephedra tweedieana
# 10                Conyza bonariensis                Erigeron bonariensis
# 11              Gamochaeta americana               Gnaphalium americanum
