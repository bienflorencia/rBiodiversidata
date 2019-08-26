# -*- coding: utf-8 -*-
"""
Created on Tue Jul  9 17:36:46 2019

@author: Florencia
"""

import csv

# FUNCTIONS  

#Function to create a list of species for each grid
#Takes a grid (csv) and returns a list (csv)
def list_of_sp_per_grid(file_to_extract):
    with open(file_to_extract, encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        dic_species_list = {}
        for row in reader:
            nrow = row[gridid]
            sp_count = row[sp_number]
            especie = row[species_row].split(';')
            if sp_count != '0':
                for sp in especie:
                    if nrow not in dic_species_list:
                        dic_species_list[nrow] = []
                    lista_sp_per_grid = dic_species_list[nrow]
                    lista_sp_per_grid.append(sp)
                    dic_species_list[nrow] = lista_sp_per_grid
       
            else:
                 dic_species_list[nrow] = 0
        return(dic_species_list)
    
#################################################################

# FILES         
file = 'Reptilia_UY25.csv'
file_to_save = file.split('.')[0]+'_abundance.txt'

gridid=0
join_count=1
species_row=4
sp_number=8

# RUN  
#Create a file with samples divided for each grid
dic = list_of_sp_per_grid(file)

file_abundances = open(file_to_save, 'w')
for k,v in dic.items():
    if v != 0:
        for i in range(len(v)):
            file_abundances.write(k+'\t'+str(i+1)+'\t'+ v[i]+'\n')
    else:
        file_abundances.write(k+'\t'+str(v)+'\t'+'NA'+'\n')               
file_abundances.close()
