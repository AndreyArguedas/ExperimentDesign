# Andrey Arguedas Espinoza
# Diseno de Experimentos - Tarea Anova con Bloques Solo Computadora 2

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(ggplot2)){install.packages("ggplot2")}
if(!require(rcompanion)){install.packages("rcompanion")}
if(!require(car)){install.packages("car")}
if(!require(multcompView)){install.packages("multcompView")}
if(!require(multcomp)){install.packages("multcomp")}
if(!require(lsmeans)){install.packages("lsmeans")}

library(rcompanion)
library(ggplot2)
library(car)
library(repr)

# Directorio donde se encuentra el archivo
setwd(this.path::here())

# Se leen los datos y se guardan en la variable Data
my_data <- read.table("Datos_monofactorial_bloques.txt", header=TRUE)
Data = my_data

# Se eliminan los datos originales de memoria
rm(my_data) 

filteredData <- Data[Data$Computadora == "Computadora 2",]

headTail(filteredData)
str(filteredData)
summary(filteredData)

Summarize(Tiempo ~ Algoritmo, filteredData, digits = 3)

# Diagrama de cajas - Recordar que los bigotes es el rango
M = tapply(filteredData$Tiempo, INDEX = filteredData$Algoritmo, FUN = mean)

boxplot(Tiempo ~ Algoritmo, data = filteredData)

points(M, col="red", pch="+", cex=2)

# Grafico de promedios e intervalos de confianza
Sum = groupwiseMean(Tiempo ~ Algoritmo, filteredData, conf = 0.95, digits = 3, traditional = FALSE, percentile = TRUE)

#Mostrar promedios e intervalos de confianza
Sum

#Grafico promedios e intervalos de confianza

ggplot(Sum ,aes(x=Algoritmo, y=Mean))+
  geom_errorbar(aes(ymin=Percentile.lower, ymax=Percentile.upper), width=0.05, size=0.5)+
  geom_point(shape=15, size=4)+
  theme_bw()+
  theme(axis.title = element_text(face='bold'))+
  ylab("Tiempo promedio, s")


#Modelo Lineal
model = lm(Tiempo ~ Algoritmo, filteredData)

summary(model) 

#En el model ya tenemos el R-squared y el p-value

#Ya que tenemos el modelo lineal podemos hacer el anova
Anova(model, type="II") #Anova mediante Suma de cuadrados

#Continuacion del analisis

x = residuals(model)
plotNormalHistogram(x)
plot(fitted(model), residuals(model))
plot(model)

#==========================================
#Analisis post-hoc para saber cuales son los grupos distintos
#==========================================

marginal = lsmeans(model, ~Algoritmo)

#Ejecuta todas las comparaciones para la variable Algoritmo

#Con el ajuste de tukey se minimiza el error tipo 1
pairs(marginal, adjust="tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD

#Grafico de promedios con intervalos de confianza y letras de separacion

CLD$Algoritmo = factor(CLD$Algoritmo, levels=c("Algoritmo A", "Algoritmo B", "Algoritmo C"))
#Eliminar espacios en blanco
CLD$.group=gsub(' ', '', CLD$.group)

ggplot(CLD, aes(x = Algoritmo, y = lsmean, label=.group)) +
  geom_point(shape = 15, size = 4) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), width = 0.2, size = 0.7) +
  theme_bw() + theme(axis.title = element_text(face="bold"),
                     axis.text = element_text(face = "bold"),
                     plot.caption = element_text(vjust  = 0)) + 
  ylab("Promedio del minimo cuadrado \n Tiempo de ejecucion") +
  geom_text(nudge_x = c(0,0,0), nudge_y = c(1100, 1100, 1100), color="black")

#Los grupos que no comparten letra en el grafico son estadisticamente distintos a un 95%