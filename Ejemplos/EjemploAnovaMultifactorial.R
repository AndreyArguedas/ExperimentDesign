# Andrey Arguedas Espinoza
# Diseno de Experimentos - Ejemplo Anova Multifactorial

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(ggplot2)){install.packages("ggplot2")}
if(!require(rcompanion)){install.packages("rcompanion")}
if(!require(car)){install.packages("car")}
if(!require(multcompView)){install.packages("multcompView")}
if(!require(multcomp)){install.packages("multcomp")}
if(!require(lsmeans)){install.packages("lsmeans")}
if(!require(phia)){install.packages("phia")}

library(rcompanion)
library(ggplot2)
library(car)
library(repr)

# Directorio donde se encuentra el archivo
setwd(this.path::here())

# Se leen los datos y se guardan en la variable Data
my_data <- read.table("datos-anova_multifactorial_S10.txt", header=TRUE)
Data = my_data

# Se eliminan los datos originales de memoria
rm(my_data) 

headTail(Data)
str(Data)
summary(Data)


Data$Entrenamiento = factor(Data$Entrenamiento, levels = unique(Data$Entrenamiento))

#Grafico simple de interaccion, se hace antes de analisis de varianzas y modelos

interaction.plot(x.factor= Data$Entrenamiento,
                 trace.factor= Data$Algoritmo,
                 response = Data$Rendimiento,
                 fun=mean, type="b", col=c("black", "red", "green"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")


#Esto es lo mismo que la linea 50
model = lm(Rendimiento ~ Entrenamiento + Algoritmo
           + Entrenamiento:Algoritmo, data=Data)

#Esto es lo mismo que la linea 46
#model = lm(Rendimiento ~ Algoritmo * Entrenamiento, data=Data)

Anova(model, type="II")

#Evaluamos los supuestos del modelo lineal
x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron
plot(fitted(model), residuals(model))

marginal = lsmeans(model, pairwise ~ Algoritmo,
                   adjust = "tukey")

#Con el ajuste de tukey se minimiza el error tipo 1
pairs(marginal, adjust="tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD

#Ahora debemos estudiar el otro factor
marginal = lsmeans(model, pairwise ~ Entrenamiento,
                   adjust = "tukey")

#Con el ajuste de tukey se minimiza el error tipo 1
pairs(marginal, adjust="tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD

#Como podemos saber cual es el mejor?
Sum = Summarize(Rendimiento ~ Entrenamiento + Algoritmo,
                data=Data, digits=3)

#Obtener error estandar
Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

Sum$Entrenamiento = factor(Sum$Entrenamiento, levels = unique(Sum$Entrenamiento))

pd = position_dodge(.2)

ggplot(Sum, aes(x = Entrenamiento, y = mean, color = Algoritmo)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
  ylab("Rendimiento")
