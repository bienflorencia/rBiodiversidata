# -*- coding: utf-8 -*-
"""
Created on Wed Jun 19 16:43:48 2019

@author: Florencia
"""

import csv
            

# FUNCTIONS  

def dic_species_fraction_per_grid(arch):
    dic_species_fraction = {}
    with open(archivo) as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        for row in reader:
            especie = row[sp_row].split(';')
            sp_count = row[join_count]
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
            sp_count = row[join_count]
            id_row = row[0]
            if sp_count == '0':
                dic_rswSR_calculation[id_row]=0
            else:
                rswSR = 0
                for sp in especie:
                    if sp in dic_freq:
                        rswSR = rswSR + (1/dic_freq[sp])
                        dic_rswSR_calculation[id_row]=rswSR
    return dic_rswSR_calculation

  
#################################################################

# FILES     
    
archivo = 'Tetrapods_UY125.csv'
name_archivo = archivo.split('.')[0]
new_archivo = name_archivo+'_rswSR_calculated.csv'

sp_row=4
join_count=1
        
# RUN   

dic= dic_species_fraction_per_grid(archivo)
rswSR= rswSR_calculation(archivo, dic)
       
with open(new_archivo, 'w', newline='', encoding="utf8") as ofile:
    writer = csv.writer(ofile, delimiter=',')
    writer.writerow(['ID', 'rswSR'])
    for key in rswSR.keys():
        writer.writerow([key, rswSR[key]])
        
        