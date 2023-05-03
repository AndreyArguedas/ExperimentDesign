# Andrey Arguedas Espinoza
# Diseno de Experimentos - Tarea 2

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(ggplot2)){install.packages("ggplot2")}
if(!require(rcompanion)){install.packages("rcompanion")}
if(!require(car)){install.packages("car")}
if(!require(multcompView)){install.packages("multcompView")}
if(!require(multcomp)){install.packages("multcomp")}
if(!require(lsmeans)){install.packages("lsmeans")}
if(!require(phia)){install.packages("phia")}
if(!require(stringr)){install.packages("stringr")}

library(rcompanion)
library(ggplot2)
library(car)
library(repr)
library(dplyr)
library(stringr)


# Directorio donde se encuentra el archivo
setwd(this.path::here())

# Leemos los datos sin pre-procesar
original_data <- readLines("Datos_tarea_2.txt")

filtered_data = original_data

#Preprocesamiento de los datos

#Eliminando datos no necesarios
filtered_data = str_remove_all(filtered_data, "user.*$")
filtered_data = str_remove_all(filtered_data, "sys.*$")
filtered_data = str_remove_all(filtered_data, regex(".*(?=image written).*$"))

filtered_data 