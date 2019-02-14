##R --vanilla
require(ROpenOffice)

## Descargar registro electoral y centros de votación (2012)
##http://www.cne.gov.ve/web/registro_electoral_descarga/abril2012/nacional.php

data.dir <- "../data/CNE"
dst.file <- sprintf("%s/nacional.zip",data.dir)
if (!file.exists(dst.file))
    download.file("http://www.cne.gov.ve/web/registro_electoral_descarga/abril2012/00/nacional.zip", dst.file)

dst.file <- sprintf("%s/centros.zip",data.dir)
if (!file.exists(dst.file))
    download.file("http://www.cne.gov.ve/web/registro_electoral_descarga/abril2012/centros/centros.zip", dst.file)




z <- read.ods(sprintf("%s/ListaParroquiasCNE.ods",data.dir))

Z <- merge(merge(z[[1]],z[[3]],by="edo"),z[[2]],by=c("edo","mun"))


x <- read.csv(unz("../data/CNE/nacional.zip","nacional.csv"),as.is=T)
y <- read.csv(unz("../data/CNE/centros.zip","centros.csv"),as.is=T,sep=";")

