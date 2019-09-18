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
                            if (IUCN_global == 'CR' | IUCN_global == 'EN'| IUCN_global == 'VU'| IUCN_global == 'DD'):
                                Threat_global+=1
                            if (IUCN_national == 'CR' | IUCN_national == 'EN'| IUCN_national == 'VU'| IUCN_national == 'DD'):
                                Threat_national+=1
            dic_all[gridID] = [Richness, Threat_global, Threat_national, (Threat_global/Richness), (Threat_national/Richness)]
        return(dic_all)


file_IUCN = 'species_Biodiversidata_1.0.0_IUCN_categories.csv'

dic_IUCN_global_status = create_IUCN_global_status_dic(file_IUCN)
dic_IUCN_national_status = create_IUCN_national_status_dic(file_IUCN)


file_tmp = '\Group Grids csvs\Amphibia_UY25.csv'

calculate_threatRichness(file_tmp, dic_IUCN_global_status, dic_IUCN_national_status)





