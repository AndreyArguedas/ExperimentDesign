# Andrey Arguedas Espinoza
# Diseno de Experimentos
# T-test

#Factores : Algoritmo A y Algoritmo B

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(lattice)){install.packages("lattice")}
if(!require(lsr)){install.packages("lsr")}
if(!require(rcompanion)){install.packages("rcompanion")}

setwd("C:/Users/Andrey/Desktop/ExperimentDesign/Ejemplos")

library(rcompanion)

# # Read a txt file, named "Datos_t-test.txt"
my_data <- readLines("Datos_t-test.txt")


Data = read.table(textConnection(my_data), header=TRUE)
rm(my_data) # Remove original data from memory


headTail(Data) # Sort
str(Data) #Compact display
summary(Data)

#Analysis

Summarize(Tiempo ~ Algoritmo, Data, digits = 4)

A <- Data$Tiempo[Data$Algoritmo == "Algorimo A"]
B <- Data$Tiempo[Data$Algoritmo == "Algorimo B"]

plotNormalHistogram(A)
plotNormalHistogram(B)