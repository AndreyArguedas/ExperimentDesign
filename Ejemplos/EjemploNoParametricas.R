Altura = c(100, 132, 137, 139, 140, 142, 142, 145)
names(Altura) = letters[1:8]
Altura
rank(Altura) #Convierte en rangos

if(!require(psych)){install.packages("psych")}
if(!require(FSA)){install.packages("FSA")}
if(!require(lattice)){install.packages("lattice")}
if(!require(multcompView)){install.packages("multcompView")}
if(!require(rcompanion)){install.packages("rcompanion")}

library(psych)
library(ggplot2)


# Directorio donde se encuentra el archivo
setwd(this.path::here())


Data = read.table("datos_no_parametricas.txt", header=TRUE)
Data$Algoritmo = factor(Data$Algoritmo,levels=unique(Data$Algoritmo)) #Ponderacion del rango
Data$Rendimiento.f = factor(Data$Rendimiento, ordered=TRUE)

headTail(Data)
str(Data)
summary(Data)



XT = xtabs(~Algoritmo + Rendimiento.f, data=Data)
XT

prop.table(XT, margin = 1)



library(lattice)
histogram(~Rendimiento.f | Algoritmo, data = Data, layout = c(1, 3))



library(FSA)
Summarize(Rendimiento ~ Algoritmo, data=Data, digits=3)


kruskal.test(Rendimiento ~ Algoritmo, data=Data)



Data$Algoritmo = factor(Data$Algoritmo, levels = c("Algoritmo A", "Algoritmo B", "Algoritmo C"))
levels(Data$Algoritmo)
DT = dunnTest(Rendimiento ~ Algoritmo, data = Data, method = "bh")
DT

PT = DT$res
cldList(P.adj ~ Comparison, data = PT, threshold = 0.05)


Sum = groupwiseMedian(Rendimiento ~ Algoritmo,
                      data = Data,
                      conf = 0.95,
                      R = 5000,
                      percentile = TRUE,
                      bca = FALSE,
                      digits = 3
)
Sum


X = 1:3
Y = Sum$Percentile.upper + 0.2
Label = c("a", "b", "a")
ggplot( Sum, aes(x = Algoritmo, y = Median)) + 
  geom_errorbar(aes(ymin = Percentile.lower,ymax = Percentile.upper),width = 0.05,size = 0.5 ) +
  geom_point(shape = 15, size = 4) + theme_bw() +
  theme(axis.title = element_text(face="bold")) +
  ylab("Mediana de puntaje de rendimiento") +
  annotate("text", x = X, y = Y, label = Label)

