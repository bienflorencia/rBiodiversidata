# -*- coding: utf-8 -*-
"""
Created on Wed Jun 19 16:43:48 2019

@author: Florencia
"""

import sys
import csv
            
# FUNCTIONS  

def dic_species_fraction_per_grid(archivo):
    dic_species_fraction = {}
    with open(archivo) as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        for row in reader:
            especie = row[sp_row].split(';')
            sp_count = row[N_row]
            lista_especies_por_celda = []
            if sp_count != '0':
                for sp in especie:
                    if sp in dic_species_fraction:
                        if sp not in lista_especies_por_celda:
                            dic_species_fraction[sp] += 1
                            lista_especies_por_celda.append(sp)
                    else:
                        dic_species_fraction[sp] = 1
                        lista_especies_por_celda.append(sp)
    return dic_species_fraction


def rswSR_calculation(archivo, dic_freq):
    dic_rswSR_calculation = {}    
    with open(archivo) as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        for row in reader:
            rswSR = 0
            especie = row[sp_row].split(';')
            sp_count = row[N_row]
            id_row = row[grid_row]
            if sp_count == '0':
                dic_rswSR_calculation[id_row]=0
            else:
                rswSR = 0
                lista_especies_por_celda = []
                for sp in especie:
                    if sp in dic_freq:
                        if sp not in lista_especies_por_celda:
                            rswSR = rswSR + (1/dic_freq[sp])
                            dic_rswSR_calculation[id_row]=rswSR
                            lista_especies_por_celda.append(sp)
    return dic_rswSR_calculation

  
#################################################################

# FILES     
    
filename = input('File: \n')
name_filename = filename.split('.')[0]
new_filename = name_filename+'_rswSR_calculated.csv'

grid_row=0
sp_row=3
N_row=1
        
# RUN   

dic= dic_species_fraction_per_grid(filename)
rswSR= rswSR_calculation(filename, dic)
       
with open(new_filename, 'w', newline='', encoding="utf8") as ofile:
    writer = csv.writer(ofile, delimiter=',')
    writer.writerow(['ID', 'rswSR'])
    for key in rswSR.keys():
        writer.writerow([key, rswSR[key]])
        