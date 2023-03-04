# Andrey Arguedas Espinoza
# Diseno de Experimentos
# Anova Monofactorial

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(Rmisc)){install.packages("Rmisc")}
if(!require(ggplot2)){install.packages("ggplot2")}
if(!require(rcompanion)){install.packages("rcompanion")}
if(!require(car)){install.packages("car")}
if(!require(multcompView)){install.packages("multcompView")}
if(!require(multcomp)){install.packages("multcomp")}
if(!require(lsmeans)){install.packages("lsmeans")}

setwd("C:/Users/Andrey/Desktop/ExperimentDesign/Ejemplos")

library(rcompanion)
library(ggplot2)
library(car)

# Tres factores: Algoritmo A, B y C

# # Read a txt file, named "Datos_monofactorial.txt"
my_data <- readLines("Datos_monofactorial.txt")


Data = read.table(textConnection(my_data), header=TRUE)
rm(my_data) # Remove original data from memory
Data

# Sort alphabetically
Data$Algoritmo = factor(Data$Algoritmo, levels = unique(Data$Algoritmo)) 

rm(my_data) # Remove original data from memory


headTail(Data) # Sort
str(Data) #Compact display
summary(Data)

#Analysis

Summarize(Tiempo ~ Algoritmo, Data, digits = 3)

A <- Data$Tiempo[Data$Algoritmo == "Algoritmo A"]
B <- Data$Tiempo[Data$Algoritmo == "Algoritmo B"]
C <- Data$Tiempo[Data$Algoritmo == "Algoritmo C"]

plotNormalHistogram(A)
plotNormalHistogram(B)
plotNormalHistogram(C)

# Diagrama de cajas - Recordar que los bigotes es el rango
M = tapply(Data$Tiempo, INDEX = Data$Algoritmo, FUN = mean)

boxplot(Tiempo ~ Algoritmo, data = Data)

points(M, col="red", pch="+", cex=2)


# Grafico de promedios e intervalos de confianza
Sum = groupwiseMean(Tiempo ~ Algoritmo, Data, conf = 0.95, digits = 3, traditional = FALSE, percentile = TRUE)

#Mostrar promedios e intervalos de confianza
Sum

#Grafico promedios e intervalos de confianza

ggplot(Sum ,aes(x=Algoritmo, y=Mean))+
  geom_errorbar(aes(ymin=Percentile.lower, ymax=Percentile.upper), width=0.05, size=0.5)+
  geom_point(shape=15, size=4)+
  theme_bw()+
  theme(axis.title = element_text(face='bold'))+
  ylab("Tiempo promedio, s")


#Si no se traslapan no son estadisticamente iguales, si lo hacen hay que hacer la prueba


# Modelo Lineal, lo utilizamos para encontrar diferencias entre grupos

model = lm(Tiempo~Algoritmo, Data)
summary(model)

#En el model ya tenemos el R-squared y el p-value

#Ya que tenemos el modelo lineal podemos hacer el anova
Anova(model, type="II") #Suma de cuadrados

#Con el resultado obtenido sabemos que hay diferencias en al menos 1 de los grupos


#Histograma de residuos
x = residuals(model)
plotNormalHistogram(x)