# -*- coding: utf-8 -*-
"""
Created on Wed Sep 18 11:17:56 2019

@author: Florencia
"""


import csv

def create_IUCN_global_status_dic(file):
    with open(file, encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        dic_IUCN_global_status = {}
        for row in reader:        
            species = row[0]
            global_category= row[2]
            if species not in dic_IUCN_global_status:
                dic_IUCN_global_status[species] = global_category
        return(dic_IUCN_global_status)

def create_IUCN_national_status_dic(file):
    with open(file, encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        dic_IUCN_national_status = {}
        for row in reader:        
            species = row[0]
            national_category= row[3]
            if species not in dic_IUCN_national_status:
                dic_IUCN_national_status[species] = national_category
        return(dic_IUCN_national_status)


def calculate_threatRichness(file, dic1, dic2):
    with open(file, encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        dic_all = {}
        for row in reader:
            list_Species = []
            gridID = row[0]
            numRecords = row[1]
            species= row[4].split(';')
            Richness = 0
            Threat_global = 0
            Threat_national = 0
            if numRecords != '0':
                for sp in species:
                    if (sp not in list_Species and sp in dic1.keys()):
                        list_Species.append(sp)
                        Richness+=1
                        if sp in dic1.keys():
                            IUCN_global = dic1[sp]
                            IUCN_national = dic2[sp]
                           # print(activity)
                            if (IUCN_global == 'CR' or IUCN_global == 'EN' or IUCN_global == 'VU' or IUCN_global == 'DD'):
                                Threat_global+=1
                            if (IUCN_national == 'CR' or IUCN_national == 'EN' or IUCN_national == 'VU' or IUCN_national == 'DD'):
                                Threat_national+=1
            if Richness == 0:
                Threat_global_proportion = 0
                Threat_national_proportion = 0
            else:
                Threat_global_proportion = Threat_global/Richness
                Threat_national_proportion = Threat_national/Richness
            dic_all[gridID] = [Richness, Threat_global_proportion, Threat_national_proportion, Threat_global, Threat_national]
        return(dic_all)


file_IUCN = 'species_Biodiversidata_1.0.0_IUCN_categories.csv'
dic_IUCN_global_status = create_IUCN_global_status_dic(file_IUCN)
dic_IUCN_national_status = create_IUCN_national_status_dic(file_IUCN)

################
# RUN 

file_tmp = 'Reptilia_UY125.csv' # change accordingly
dic_tmp = calculate_threatRichness(file_tmp, dic_IUCN_global_status, dic_IUCN_national_status)
new_file_tmp = file_tmp.split('.')[0]+'_ThreatRichnessProportion.csv'

with open(new_file_tmp, 'w', newline='', encoding="utf8") as ofile:
    writer = csv.writer(ofile, delimiter=',')
    writer.writerow(['gridID', 'speciesRichness', 'ThreatProportionGlobal', 
                     'ThreatProportionNational', 'ThreatRichnessGlobal', 
                     'ThreatRichnessNational'])
    for gridID, value in dic_tmp.items():
        writer.writerow([gridID, value[0], value[1], value[2], value[3], value[4]])


