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

library(rcompanion)
library(ggplot2)
library(car)
library(repr)

# Directorio donde se encuentra el archivo
setwd(this.path::here())

# Se leen los datos y se guardan en la variable Data
my_data <- read.csv("Datos tarea 1.csv")
Data = my_data

# Se eliminan los datos originales de memoria
rm(my_data) 

#Modificamos el nombre de la columna para que sea más sencillo trabajar
names(Data)[names(Data) == "Stpbnd.2400.2482..S21..1."] <- "Stpbnd"

headTail(Data)

#Informacion basica
Summarize(Stpbnd ~ Lot, data=Data, digits=4)

# Grafico de cajas y bigotes de los datos originales
boxplot(Stpbnd ~ Lot, data = Data)

#Lotes
control <- Data[Data$Lot == "Control",]
lot1 <- Data[Data$Lot == "Exp 1",]
lot2 <- Data[Data$Lot == "Exp 2",]
lot3 <- Data[Data$Lot == "Exp 3",]
lot4 <- Data[Data$Lot == "Exp 4",]
lot5 <- Data[Data$Lot == "Exp 5",]
lot6 <- Data[Data$Lot == "Exp 6",]

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

#Unir todos los datos pero sin outliers
data_no_outliers <- rbind(control_no_outliers, lot1_no_outliers, lot2_no_outliers, lot3_no_outliers, lot4_no_outliers, lot5_no_outliers)

#Visualizacion de los datos sin outliers
options(repr.plot.width=20, repr.plot.height=20)
par(mfrow=c(3,2))
boxplot(Stpbnd ~ Lot, data = control_no_outliers, main = "Control")
boxplot(Stpbnd ~ Lot, data = lot1_no_outliers, main = "Exp 1")
boxplot(Stpbnd ~ Lot, data = lot2_no_outliers, main = "Exp 2")
boxplot(Stpbnd ~ Lot, data = lot3_no_outliers, main = "Exp 3")
boxplot(Stpbnd ~ Lot, data = lot4_no_outliers, main = "Exp 4")
boxplot(Stpbnd ~ Lot, data = lot5_no_outliers, main = "Exp 5")


#Información sobre los datos sin outliers
Summarize(Stpbnd ~ Lot, data=data_no_outliers, digits=4)

boxplot(Stpbnd ~ Lot, data = data_no_outliers)

#Histograma de Stpbnd pero con los datos originales
#plotNormalHistogram(Data$Stpbnd, main = "Stpbnd", breaks = 300)


#Histograma de Stpbnd pero sin outliers
options(repr.plot.width=15, repr.plot.height=10)
ggplot(data_no_outliers, aes(x=Stpbnd, fill=Stpbnd)) + 
  geom_histogram(bins=200, alpha=0.1, position="dodge", colour = "black") + 
  NULL

#Colores diferentes para cada lot en el histograma
options(repr.plot.width=15, repr.plot.height=10)
ggplot(Data, aes(Stpbnd, fill = Lot)) +
  geom_histogram(binwidth = 0.15)

#Colores diferentes para cada lot en el histograma sin outliers
options(repr.plot.width=15, repr.plot.height=10)
ggplot(data_no_outliers, aes(Stpbnd, fill = Lot)) +
  geom_histogram(binwidth = 0.15)


#Histogramas en cascada
options(repr.plot.width=20, repr.plot.height=20)
par(mfrow=c(3,2))
plotNormalHistogram(control_no_outliers$Stpbnd, xlim = c(24,29), main = "Control")
plotNormalHistogram(lot1_no_outliers$Stpbnd, xlim = c(24,29), main = "Exp 1")
plotNormalHistogram(lot2_no_outliers$Stpbnd, xlim = c(24,29), main = "Exp 2")
plotNormalHistogram(lot3_no_outliers$Stpbnd, xlim = c(24,29), main = "Exp 3")
plotNormalHistogram(lot4_no_outliers$Stpbnd, xlim = c(24,29), main = "Exp 4")
plotNormalHistogram(lot5_no_outliers$Stpbnd, xlim = c(24,29), main = "Exp 5")


par(mfrow=c(1,2))
#Grafico de cajas y bigotes incluyendo outliers
boxplot(Stpbnd ~ Lot, data = Data)

#Ajustando el grafico para un min de 24 y max de 30
boxplot <- boxplot(Stpbnd ~ Lot, data = Data, ylim=c(24, 30))

