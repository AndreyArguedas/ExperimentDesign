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

#original_data

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


#Convirtiendo las lineas de tipo  
#_(cantidad de objetos)(arquitectura)(efectos en la escena)-(resolución de la escena) 
#en datos separados

#Obteniendo la resolucion
resolucion = str_remove_all(only_technical_data, regex(".*(?=-)"))
resolucion = str_replace_all(resolucion, "-", "")

#Obteniendo los efectos de la escena
efectos = str_remove_all(only_technical_data, regex("(?=-).*"))
efectos = str_remove_all(efectos, regex(".*GPU"))
efectos = str_remove_all(efectos, regex(".*APU"))
efectos = str_remove_all(efectos, regex(".*CPU"))

#Obteniendo los ARQUITECTURA de la escena
arquitectura = str_remove_all(only_technical_data, regex(".*(?=GPU)"))
arquitectura = str_remove_all(arquitectura, regex("(?<=GPU).*"))
arquitectura = str_remove_all(arquitectura, regex(".*(?=APU)"))
arquitectura = str_remove_all(arquitectura, regex("(?<=APU).*"))
arquitectura = str_remove_all(arquitectura, regex(".*(?=CPU)"))
arquitectura = str_remove_all(arquitectura, regex("(?<=CPU).*"))

#Obteniendo la cantidad de objetos de la escena
objetos = str_remove_all(only_technical_data, regex("(?=GPU).*"))
objetos = str_remove_all(objetos, regex("(?=CPU).*"))
objetos = str_remove_all(objetos, regex("(?=APU).*"))
objetos = str_replace_all(objetos, "_", "")

# Create a data table from a data frame
data_frame <- data.frame(TiempoResolucion=rep(c(only_time_data)),
                            Objetos=rep(c(objetos)),
                            Arquitectura=rep(c(arquitectura)),
                            Efectos=rep(c(efectos)),
                            Resolucion=rep(c(resolucion)))

write.table(data_frame, "Datos2kTabla.txt", quote = FALSE, row.names=FALSE)


# Se leen los datos y se guardan en la variable Data
my_data <- read.table("Datos2kTabla.txt", header=TRUE, 
                      colClasses = c("numeric", "factor", "factor", "factor", "factor"))
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


Summarize(TiempoResolucion ~ TechnicalData, data=Data, digits=4)



#Grafico simple de interaccion, se hace antes de analisis de varianzas y modelos

interaction.plot(x.factor= Data$Objetos,
                 trace.factor= Data$Arquitectura,
                 response = Data$TiempoResolucion,
                 fun=mean, type="b", col=c("black", "red", "green"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")

interaction.plot(x.factor= Data$Efectos,
                 trace.factor= Data$Arquitectura,
                 response = Data$TiempoResolucion,
                 fun=mean, type="b", col=c("black", "red", "green"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")

interaction.plot(x.factor= Data$Resolucion,
                 trace.factor= Data$Arquitectura,
                 response = Data$TiempoResolucion,
                 fun=mean, type="b", col=c("black", "red", "green"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")


#Definimos Modelo Lineal y Anova

model = lm(TiempoResolucion ~ Objetos * Arquitectura * Efectos * Resolucion
           , data=Data)

Anova(model, type="II")

#Evaluacion de los supuestos
x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))


plot(model)

#Transformacion de datos - Por raiz cuadrada

T.sqrt = sqrt(Data$TiempoResolucion)

model = lm(T.sqrt ~ Objetos * Arquitectura * Efectos * Resolucion, data=Data)

Anova(model, type="II")

x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))

plot(model)



#Prueba de LEVEN para homocedasticidad 
#Para esta prueba mas bien queremos un p-value alto
leveneTest(T.sqrt ~ Objetos * Arquitectura * Efectos * Resolucion, data=Data)



#Analisis post-hoc con los datos transformados


#Analisis post-hoc con los datos transformados
marginal = lsmeans(model, pairwise ~ Arquitectura,
                   adjust = "tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD


#Ahora hacemos post-hoc pero por la variable Tiempo Resolucion


#Analisis post-hoc con los datos transformados
marginal = lsmeans(model, pairwise ~ Efectos,
                   adjust = "tukey")

#Con CLD podemos agregar letras a cada grupo
CLD = cld(marginal, alpha=0.05, Letters = letters, adjust="tukey")

#Grupos con distintas letras en el group son estadisticamente distintos
#Si comparten letra es que son iguales
CLD




#Final part

Sum = Summarize(T.sqrt ~ Objetos + Arquitectura, data=Data, digits=4)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Objetos = factor(Sum$Objetos, levels=unique(Sum$Objetos))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Objetos, y = mean, color = Arquitectura)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Objetos")





Sum = Summarize(T.sqrt ~ Efectos + Arquitectura, data=Data, digits=4)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Efectos = factor(Sum$Efectos, levels=unique(Sum$Efectos))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Efectos, y = mean, color = Arquitectura)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Efectos")



Sum = Summarize(T.sqrt ~ Resolucion + Arquitectura, data=Data, digits=4)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Resolucion = factor(Sum$Resolution, levels=unique(Sum$Resolucion))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Resolucion, y = mean, color = Arquitectura)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Resolucion")




#GRAFICO PRINICIPAL - PROMEDIOS TRANSFORMADOS


Sum = Summarize(T.sqrt ~ Arquitectura, data=Data, digits=3)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Arquitectura = factor(Sum$Arquitectura, levels=unique(Sum$Arquitectura))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Arquitectura, y = mean, color = Arquitectura)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  geom_point(shape=15, size=4, position=pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Raiz cuadrada de arquitectura")

#Ahora des-transformemos

Sum = Summarize(T.sqrt ~ Arquitectura, data=Data, digits=3)


Sum$mean = Sum$mean ^ 2
Sum$sd = Sum$sd ^ 2
Sum

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Arquitectura = factor(Sum$Arquitectura, levels=unique(Sum$Arquitectura))

#Graficamos

pd=position_dodge(.2)

ggplot(Sum, aes(x = Arquitectura, y = mean, color = Arquitectura)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  geom_point(shape=15, size=4, position=pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Originales de Arquitectura")


