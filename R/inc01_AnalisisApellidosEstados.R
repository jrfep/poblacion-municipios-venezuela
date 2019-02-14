##R --vanilla
require(labdsv)
Rdata.dir <- "../Rdata"
load(file=sprintf("%s/MatrizApellidosVenezuela.rda",Rdata.dir))

##En la matriz hay más de 200 mil apellidos
dim(mtz.ap.vzla)

## pero muchos de ellos en bajas frecuencias (errores de tipeo o apellidos poco comunes)
plot(rev(sort(rowSums(mtz.ap.vzla))),log="y")

## Pero para el análisis nos enfocamos en los apellidos que tienen
## una frecuencia mayor a 500 

m0 <- mtz.ap.vzla[rowSums(mtz.ap.vzla)>500,]
dim(m0)
