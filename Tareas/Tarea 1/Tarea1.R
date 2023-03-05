# Andrey Arguedas Espinoza
# Diseno de Experimentos - Tarea 1

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(Rmisc)){install.packages("Rmisc")}
if(!require(ggplot2)){install.packages("ggplot2")}
if(!require(rcompanion)){install.packages("rcompanion")}
if(!require(car)){install.packages("car")}
if(!require(multcompView)){install.packages("multcompView")}
if(!require(multcomp)){install.packages("multcomp")}
if(!require(lsmeans)){install.packages("lsmeans")}

setwd("C:/Users/Andrey/Desktop/ExperimentDesign/Tareas/Tarea 1")

library(rcompanion)
library(ggplot2)
library(car)

# Tarea 1

# # Read a txt file, named "Datos tarea 1.txt"
my_data <- read.csv("Datos tarea 1.csv")
Data = my_data
rm(my_data) # Remove original data from memory

names(Data)[names(Data) == "Stpbnd.2400.2482..S21..1."] <- "Stpbnd" #Por alguna razon el nombre original no se puede filtrar en R

headTail(Data)

#Informacion basica
Summarize(Stpbnd ~ Lot, data=Data, digits=4)

#Lotes
control <- Data[Data$Lot == "Control",]
lot1 <- Data[Data$Lot == "Exp 1",]
lot2 <- Data[Data$Lot == "Exp 2",]
lot3 <- Data[Data$Lot == "Exp 3",]
lot4 <- Data[Data$Lot == "Exp 4",]
lot5 <- Data[Data$Lot == "Exp 5",]
lot6 <- Data[Data$Lot == "Exp 6",]

boxplot(Stpbnd ~ Lot, data = Data)

#Histogramas por lote

plotNormalHistogram(control$Stpbnd)
plotNormalHistogram(lot1$Stpbnd)
plotNormalHistogram(lot2$Stpbnd)
plotNormalHistogram(lot3$Stpbnd)
plotNormalHistogram(lot4$Stpbnd)
plotNormalHistogram(lot5$Stpbnd)

#Encontrar los outliers
outliers_control <- boxplot(control$Stpbnd,plot=FALSE)$out
outliers_lot1 <- boxplot(lot1$Stpbnd,plot=FALSE)$out
outliers_lot2 <- boxplot(lot2$Stpbnd,plot=FALSE)$out
outliers_lot3 <- boxplot(lot3$Stpbnd,plot=FALSE)$out
outliers_lot4 <- boxplot(lot4$Stpbnd,plot=FALSE)$out
outliers_lot5 <- boxplot(lot5$Stpbnd,plot=FALSE)$out

#Eliminando los outliers

control_no_outliers <- control[-which(control$Stpbnd %in% outliers_control),]
lot1_no_outliers <- lot1[-which(lot1$Stpbnd %in% outliers_lot1),]
lot2_no_outliers <- lot2[-which(lot2$Stpbnd %in% outliers_lot2),]
lot3_no_outliers <- lot3[-which(lot3$Stpbnd %in% outliers_lot3),]
lot4_no_outliers <- lot4[-which(lot4$Stpbnd %in% outliers_lot4),]
lot5_no_outliers <- lot5[-which(lot5$Stpbnd %in% outliers_lot5),]

#Visualizacion de los datos sin outliers
boxplot(Stpbnd ~ Lot, data = control_no_outliers)
boxplot(Stpbnd ~ Lot, data = lot1_no_outliers)
boxplot(Stpbnd ~ Lot, data = lot2_no_outliers)
boxplot(Stpbnd ~ Lot, data = lot3_no_outliers)
boxplot(Stpbnd ~ Lot, data = lot4_no_outliers)
boxplot(Stpbnd ~ Lot, data = lot5_no_outliers)
