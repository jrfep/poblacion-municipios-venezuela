##R --vanilla
require(labdsv)
Rdata.dir <- "../Rdata"
load(file=sprintf("%s/MatrizApellidosVenezuela.rda",Rdata.dir))

##En la matriz hay casi 200 mil apellidos
dim(mtz.ap.vzla)

## pero muchos de ellos en bajas frecuencias (errores de tipeo o apellidos poco comunes)
plot(rev(sort(rowSums(mtz.ap.vzla))),log="y")

## Pero para el análisis nos enfocamos en los apellidos que tienen
## una frecuencia mayor a 500 

m0 <- mtz.ap.vzla[rowSums(mtz.ap.vzla)>500,]
dim(m0)

## calcular proporción dentro del estado (dividir entre el total del estado) 
m1 <- apply(m0,2,function(x) x/sum(x))
## calcular proporción entre estados (dividir entre el total del país) 
m2 <- apply(m0,1,function(x) x/sum(x))

require(cluster)
require(vegan)



## Existen varios métodos posibles
##similar to:# h0 <- hclust(d0,method="mcquitty")
d0 <- daisy(t(m1))
h0 <- agnes(d0,method="weighted")

##similar to:# h0 <- hclust(d0,method="ward.D2")
h0 <- agnes(t(m1),method="ward")


plot(h0,  which.plot = 2,xlab="Basado en la frequencia de apellidos por estado",sub=sprintf("Coeficiente de aglomeración = %0.2f",h0$ac),main="Dendrograma de agrupamiento jerárquico según el método de Ward",ylab="Disimilitud")

rect.hclust(h0, k = 5, border = 2:6)




Tabla.Zulia <- data.frame(n.Zulia=m0[,"ZULIA"],n.Vzla=rowSums(m0),
                          freq.Zulia=m1[,"ZULIA"],p.Zulia=m2["ZULIA",])
Tabla.Zulia <- subset(Tabla.Zulia,n.Zulia>20000 & p.Zulia>.2)
Tabla.Zulia[order(Tabla.Zulia$p.Zulia),]

##https://rstudio-pubs-static.s3.amazonaws.com/1876_df0bf890dd54461f98719b461d987c3d.html
##http://www.sthda.com/english/wiki/print.php?id=237

