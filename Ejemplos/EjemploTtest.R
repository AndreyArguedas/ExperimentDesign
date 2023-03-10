# Andrey Arguedas Espinoza
# Diseño de Experimentos
# T-test

#Factores : Algoritmo A y Algoritmo B

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(lattice)){install.packages("lattice")}
if(!require(lsr)){install.packages("lsr")}
if(!require(rcompanion)){install.packages("rcompanion")}

library(rcompanion)



# Directorio donde se encuentra el archivo
setwd(this.path::here())

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

# Diagrama de cajas
M = tapply(Data$Tiempo, INDEX = Data$Algoritmo, FUN = mean)

boxplot(Tiempo ~ Algoritmo, data = Data)

points(M, col="red", pch="+", cex=2)

#Debemos aplicar la prueba t para ver si son estadisticamente distintos

t.test(Tiempo ~ Algoritmo, data=Data)


#Distribucion normal y residuos y graficos Q-Q

