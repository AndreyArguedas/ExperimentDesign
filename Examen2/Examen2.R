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


my_data <- read.table("datos_examen_II.txt", header=TRUE, 
                      colClasses = c("factor", "factor","factor", "factor", "double"))


Data = my_data

headTail(Data)
str(Data)
summary(Data)

Sum = Summarize(Puntaje ~ Equipo * Algoritmo, data=Data, digits=4)

Sum

Sum = Summarize(Puntaje ~ Aceleradores * Algoritmo, data=Data, digits=4)

Sum


Sum = Summarize(Puntaje ~ Datos + Algoritmo, data=Data, digits=4)

Sum


Sum = Summarize(Puntaje ~ Algoritmo, data=Data, digits=4)

Sum


interaction.plot(x.factor= Data$Equipo,
                 trace.factor= Data$Algoritmo,
                 response = Data$Puntaje,
                 fun=mean, type="b", col=c("black", "red", "green", "blue", "pink"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")


interaction.plot(x.factor= Data$Datos,
                 trace.factor= Data$Algoritmo,
                 response = Data$Puntaje,
                 fun=mean, type="b", col=c("black", "red", "green", "blue", "pink"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")

interaction.plot(x.factor= Data$Aceleradores,
                 trace.factor= Data$Algoritmo,
                 response = Data$Puntaje,
                 fun=mean, type="b", col=c("black", "red", "green", "blue", "pink"),
                 pch=c(19,17,15), fixed=TRUE, leg.bty="o")


#Definimos Modelo Lineal y Anova

model = lm(Puntaje ~ Datos * Algoritmo * Aceleradores * Equipo, data=Data)

Anova(model, type="II")


#Evaluacion de los supuestos
x =  residuals(model)
plotNormalHistogram(x)


#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))


plot(model)

#Prueba de LEVEN para homocedasticidad 
leveneTest(Puntaje ~ Datos * Algoritmo * Aceleradores * Equipo, data=Data)

#Transformacion de datos

T.sqrt = sqrt(Data$Puntaje)

model = lm(T.sqrt ~ Datos * Algoritmo * Aceleradores * Equipo, data=Data)

Anova(model, type="II")

x =  residuals(model)
plotNormalHistogram(x)

#Ver el patron homcedasteicidad
plot(fitted(model), residuals(model))

plot(model)


#Prueba de LEVEN para homocedasticidad 
leveneTest(T.sqrt ~ Datos * Algoritmo * Aceleradores * Equipo, data=Data)

Sum = Summarize(T.sqrt ~ Algoritmo, data=Data, digits=3)

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Algoritmo = factor(Sum$Algoritmo, levels=unique(Sum$Algoritmo))

#Graficamos

pd=position_dodge(.2)


ggplot ( Sum , aes (x= Algoritmo , y=mean , color = Algoritmo ) ) +
  geom_errorbar ( aes ( ymin = mean - se , ymax = mean + se) , width =.2 , size =0.7 , position = pd ) +
  geom_point ( aes ( shape = Algoritmo ) , size =5 , position = pd ) + theme_bw () +
  theme ( plot.title = element_text ( face ="bold", size =20 , hjust =0.5) ,
          axis.title = element_text ( face ="bold", size =20) ,
          axis.text = element_text ( face ="bold", size =15) ,
          plot.caption = element_text ( hjust =0) ,
          legend.text = element_text ( face ="bold", size =15) ,
          legend.title = element_text ( face ="bold", size =20) ,
          legend.justification = c(0 ,1) , legend.position =c (0.01 , 0.99) ) +
  ylab ( expression ( "Average of rendering time after data transformation" ) ) +
  ggtitle ( "puntaje vs algoritmo" )


#Destransformamos

Sum = Summarize(T.sqrt ~ Algoritmo, data=Data, digits=3)

Sum$mean = Sum$mean ^ 2
Sum$sd = Sum$sd ^ 2
Sum

#Agregamos el se

Sum$se = Sum$sd / sqrt(Sum$n)
Sum$se = signif(Sum$se, digits=3)
Sum

#Ordenamos
Sum$Algoritmo = factor(Sum$Algoritmo, levels=unique(Sum$Algoritmo))

#Graficamos

pd=position_dodge(.2)


ggplot ( Sum , aes (x= Algoritmo , y=mean , color = Algoritmo ) ) +
  geom_errorbar ( aes ( ymin = mean - se , ymax = mean + se) , width =.2 , size =0.7 , position = pd ) +
  geom_point ( aes ( shape = Algoritmo ) , size =5 , position = pd ) + theme_bw () +
  theme ( plot.title = element_text ( face ="bold", size =20 , hjust =0.5) ,
          axis.title = element_text ( face ="bold", size =20) ,
          axis.text = element_text ( face ="bold", size =15) ,
          plot.caption = element_text ( hjust =0) ,
          legend.text = element_text ( face ="bold", size =15) ,
          legend.title = element_text ( face ="bold", size =20) ,
          legend.justification = c(0 ,1) , legend.position =c (0.01 , 0.99) ) +
  ylab ( expression ( "Average of rendering time after data transformation" ) ) +
  ggtitle ( "Time vs Operating System" )



pd=position_dodge(.2)

ggplot(Sum, aes(x = Algoritmo, y = mean, color = Algoritmo)) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, size = 0.7, position = pd) +
  geom_point(shape=15, size=4, position=pd) +
  theme_bw() + theme(axis.title = element_text(face="bold")) + 
  scale_color_manual(values=c("black", "red", "green"))
ylab("Originales de Rendimiento")



#Puntaje vs Equipo


Sum = Summarize (T.sqrt ~ Algoritmo + Equipo , data = Data , digits =3)
Sum $se = Sum $sd / sqrt ( Sum $n)
Sum $se = signif ( Sum $se , digits =3)
Sum

pd = position_dodge (.2)
ggplot ( Sum , aes (x= Equipo ,y=mean , color = Algoritmo ) ) + geom_errorbar( aes ( ymin =  mean - se , ymax = mean + se), width = 0.2 , size =0.7 , position = pd )+
  geom_point ( aes ( shape = Algoritmo ) , size =5 , position = pd )+ theme_bw () +
  theme ( plot.title = element_text ( face ="bold", size =20 , hjust =0.5) ,
          axis.title = element_text ( face ="bold", size =20) ,
          axis.text = element_text ( face ="bold", size =15) ,
          plot.caption = element_text ( hjust =0) ,
          legend.text = element_text ( face ="bold", size =15) ,
          legend.title = element_text ( face ="bold", size =20) ,
          legend.justification = c(0 ,1) ,
          legend.position =c (0.01 , 0.99) ) + xlab (" Configuration ") +
  ylab ( expression ("Average time of square root transformation")) + ggtitle ("Time vs Configuration \n related to Operating System ")




pairwise.t.test (T.sqrt , Data$Algoritmo:Data$Datos, p.adjust.method = "BH")


pairwise.t.test (T.sqrt , Data$Algoritmo:Data$Aceleradores, p.adjust.method = "BH")

pairwise.t.test (T.sqrt , Data$Algoritmo:Data$Equipo, p.adjust.method = "BH")
