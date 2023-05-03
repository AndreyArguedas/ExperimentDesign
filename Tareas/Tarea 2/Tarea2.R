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
library(data.table)

# Directorio donde se encuentra el archivo
setwd(this.path::here())

# Leemos los datos sin pre-procesar
original_data <- readLines("Datos_tarea_2.txt")

filtered_data = original_data

#Preprocesamiento de los datos

#Eliminando datos no necesarios
filtered_data = str_replace_all(filtered_data, "user.*$", "")
filtered_data = str_replace_all(filtered_data, "sys.*$", "")
filtered_data = str_replace_all(filtered_data, "real ", "")
filtered_data = str_replace_all(filtered_data, regex(".*(?=image written).*$"), "")
filtered_data = str_remove_all(filtered_data, regex(".*(?=_)"))

#Eliminando todos las lineas que quedaron en blanco
empty_lines = grepl('^\\s*$', filtered_data)
filtered_data = filtered_data[! empty_lines]

filtered_data

#Datos filtrados para obtener solo el tiempo de ejecucion

only_time_data = str_remove_all(filtered_data, regex("(?=_).*"))
only_time_data = str_replace_all(only_time_data, ",", ".")
#Eliminando todos las lineas que quedaron en blanco
empty_lines = grepl('^\\s*$', only_time_data)
only_time_data = only_time_data[! empty_lines]

only_time_data

#Datos filtrados para obtener solo la columna de mas informacion
only_technical_data = str_remove_all(filtered_data, regex("^[0-9].*(?=.).*"))
#Eliminando todos las lineas que quedaron en blanco
empty_lines = grepl('^\\s*$', only_technical_data)
only_technical_data = only_technical_data[! empty_lines]

only_technical_data


#Convirtiendo las lineas de tipo  _(cantidad de objetos)(arquitectura)(efectos en la escena)-(resolución de la escena) en datos separados

#Obteniendo la resolucion
resolucion = str_remove_all(only_technical_data, regex(".*(?=-)"))
resolucion = str_replace_all(resolucion, "-", "")

resolucion


#Obteniendo los efectos de la escena
efectos = str_remove_all(only_technical_data, regex("(?=-).*"))
efectos = str_remove_all(efectos, regex(".*GPU"))
efectos = str_remove_all(efectos, regex(".*APU"))
efectos = str_remove_all(efectos, regex(".*CPU"))

efectos

#Obteniendo los ARQUITECTURA de la escena
arquitectura = str_remove_all(only_technical_data, regex(".*(?=GPU)"))
arquitectura = str_remove_all(arquitectura, regex("(?<=GPU).*"))
arquitectura = str_remove_all(arquitectura, regex(".*(?=APU)"))
arquitectura = str_remove_all(arquitectura, regex("(?<=APU).*"))
arquitectura = str_remove_all(arquitectura, regex(".*(?=CPU)"))
arquitectura = str_remove_all(arquitectura, regex("(?<=CPU).*"))

arquitectura

#Obteniendo la cantidad de objetos de la escena
objetos = str_remove_all(only_technical_data, regex("(?=GPU).*"))
objetos = str_remove_all(objetos, regex("(?=CPU).*"))
objetos = str_remove_all(objetos, regex("(?=APU).*"))
objetos = str_replace_all(objetos, "_", "")

objetos

# create a data table from a data frame
data_frame <- data.frame(RunningTime=rep(c(only_time_data)),
                            Objetos=rep(c(objetos)),
                            Architecture=rep(c(arquitectura)),
                            Effects=rep(c(efectos)),
                            Resolution=rep(c(resolucion)))

data_frame

write.table(data_frame, "Datos2kTabla.txt", quote = FALSE, row.names=FALSE)


# Se leen los datos y se guardan en la variable Data
my_data <- read.table("Datos2kTabla.txt", header=TRUE, colClasses = c("numeric", "factor", "factor", "factor", "factor"))
Data = my_data

# Se eliminan los datos originales de memoria
rm(my_data) 
rm(data_frame)
rm(objetos)
rm(arquitectura)
rm(efectos)
rm(resolucion)
rm(only_technical_data)
rm(filtered_data)
rm(original_data)

headTail(Data)
str(Data)
summary(Data)

