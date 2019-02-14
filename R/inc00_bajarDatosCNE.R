##R --vanilla
require(ROpenOffice)
require(gdata)
## Descargar registro electoral y centros de votación (2012)
##http://www.cne.gov.ve/web/registro_electoral_descarga/abril2012/nacional.php

data.dir <- "../data/CNE"
Rdata.dir <- "../Rdata"
dst.file <- sprintf("%s/nacional.zip",data.dir)
if (!file.exists(dst.file))
    download.file("http://www.cne.gov.ve/web/registro_electoral_descarga/abril2012/00/nacional.zip", dst.file)

dst.file <- sprintf("%s/centros.zip",data.dir)
if (!file.exists(dst.file))
    download.file("http://www.cne.gov.ve/web/registro_electoral_descarga/abril2012/centros/centros.zip", dst.file)





## registro electoral nacional
x <- read.csv(unz("../data/CNE/nacional.zip","nacional.csv"),as.is=T,sep=";")
## ubicación de los centros (codigos)
y <- read.csv(unz("../data/CNE/centros.zip","centros.csv"),as.is=T,sep=";")

## tabla con la información geográfica [Elaboración propia]
##(nombre de estados, municipios y parroquias) 
z <- read.ods(sprintf("%s/ListaParroquiasCNE.ods",data.dir))
Z <- merge(merge(z[[1]],z[[3]],by="edo"),z[[2]],by=c("edo","mun"))

## Agregar informacion de estados a la tabla del registro electoral
x$estado <- y$cod_estado[match(x$cod_centro,y$cod_centro)]

## Reformatear información de apellidos en casos en que está desordenada la información original
x$a0 <- paste(trim(x$primer_apellido),trim(x$segundo_apellido),sep=" ")

x$a1 <- sapply(x$a0,function(x) trim(strsplit(x," ")[[1]][1]))
x$a2 <- sapply(x$a0,function(x) trim(strsplit(x," ")[[1]][2]))

## vectores de apellidos y estados
apellidos <- gsub("^DE ","",trim(c(x$a1,x$a2)))
estados <- z[[1]]$estado[match(c(x$estado,x$estado),z[[1]]$edo)]

## descartar datos de embajadas, apellido abreviados, vacíos o incompletos
ss <- (nchar(apellidos) %in% 0:1) |(nchar(apellidos)==2 & grepl("\\.",apellidos)) | apellidos %in% "" | estados %in% "EMBAJADA" 
table(ss)
apellidos <- apellidos[!ss]
estados <- estados[!ss]

mtz.ap.vzla <- table(apellidos,as.character(estados))

##grep("CAMACHO",rownames(mtz.ap.vzla),value=T)

save(file=sprintf("%s/MatrizApellidosVenezuela.rda",Rdata.dir),mtz.ap.vzla)

