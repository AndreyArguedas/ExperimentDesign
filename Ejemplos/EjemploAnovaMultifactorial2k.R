# Andrey Arguedas Espinoza
# Diseno de Experimentos - Ejemplo Anova Multifactorial 2K

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
my_data <- read.table("datos-anova_multifactorial_2k.txt", header=TRUE)
Data = my_data

# Se eliminan los datos originales de memoria
rm(my_data) 

headTail(Data)
str(Data)
summary(Data)

#Grafico simple de interaccion, se hace antes de analisis de varianzas y modelos

interaction.plot(x.factor= Data$Entrenamiento,
                 trace.factor= Data$Algoritmo,
                 response = Data$Rendimiento,
                 fun=mean, type="b", col=c("black", "red", "green"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")


#Realizamos cambio para tomar en cuenta el acelerador

interaction.plot(x.factor= Data$Acelerador,
                 trace.factor= Data$Algoritmo,
                 response = Data$Rendimiento,
                 fun=mean, type="b", col=c("black", "red", "green"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")


#Definimos Modelo Lineal y Anova


model = lm(Rendimiento ~ Entrenamiento * Algoritmo * Acelerador
           , data=Data)

Anova(model, type="II")

#Evaluacion de los supuestos
x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))

#TRANSFORMACION DE DATOS - POR RAIZ CUADRADA

#La transformacion se aplica sobre la variable dependiente
T.sqrt = sqrt(Data$Rendimiento)

model = lm(T.sqrt ~ Entrenamiento * Algoritmo * Acelerador
           , data=Data)

Anova(model, type="II")

x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))

#TRANSFORMACION DE DATOS - POR RAIZ CUBICA

#La transformacion se aplica sobre la variable dependiente
T.cub = sign(Data$Rendimiento) * abs(Data$Rendimiento) ^ (1/3)

model = lm(T.cub ~ Entrenamiento * Algoritmo * Acelerador
           , data=Data)

Anova(model, type="II")

x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))

#TRANSFORMACION DE DATOS - POR LOGARITMO

#La transformacion se aplica sobre la variable dependiente
T.log = log(Data$Rendimiento)

model = lm(T.log ~ Entrenamiento * Algoritmo * Acelerador
           , data=Data)

Anova(model, type="II")

x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))

#Prueba de LEVEN para homocedasticidad 
#Para esta prueba queremos un p-value alto
leveneTest(T.log ~ Entrenamiento * Algoritmo * Acelerador
           , data=Data)

#Analisis post-hoc con los datos transformados
marginal = lsmeans(model, pairwise ~ Algoritmo,
                   adjust = "tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD


#Ahora hacemos post-hoc pero por la variable Entrenamiento


#Analisis post-hoc con los datos transformados
marginal = lsmeans(model, pairwise ~ Entrenamiento,
                   adjust = "tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD



#Ahora hacemos post-hoc pero por la variable Acelerador


#Analisis post-hoc con los datos transformados
marginal = lsmeans(model, pairwise ~ Acelerador,
                   adjust = "tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD

#Graficos Finales
Sum = Summarize(T.log ~ Entrenamiento + Algoritmo, data=Data, digits=3)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Entrenamiento = factor(Sum$Entrenamiento, levels=unique(Sum$Entrenamiento))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Entrenamiento, y = mean, color = Algoritmo)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Rendimiento")

#Graficos Finales
Sum = Summarize(T.log ~ Acelerador + Algoritmo, data=Data, digits=3)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Entrenamiento = factor(Sum$Acelerador, levels=unique(Sum$Acelerador))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Acelerador, y = mean, color = Algoritmo)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Rendimiento")




#GRAFICO PRINICIPAL - PROMEDIOS TRANSFORMADOS


Sum = Summarize(T.log ~ Algoritmo, data=Data, digits=3)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Algoritmo = factor(Sum$Algoritmo, levels=unique(Sum$Algoritmo))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Algoritmo, y = mean, color = Algoritmo)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  geom_point(shape=15, size=4, position=pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Logaritmo de Rendimiento")


#Ahora des-transformemos

Sum = Summarize(T.log ~ Algoritmo, data=Data, digits=3)


Sum$mean = exp(Sum$mean)
Sum$sd = exp(Sum$sd )
Sum

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Algoritmo = factor(Sum$Algoritmo, levels=unique(Sum$Algoritmo))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Algoritmo, y = mean, color = Algoritmo)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  geom_point(shape=15, size=4, position=pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Originales de Rendimiento")
