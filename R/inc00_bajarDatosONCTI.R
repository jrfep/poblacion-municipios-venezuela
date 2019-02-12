##R --vanilla
require(rvest)

data.dir <- "../data/PEII"

PEII <- data.frame(id=c(120,115,110,108,100,109,102,111,117,118,99,113,116,98,103,106,121,101,104,105,97,112,119,107,114),
                   estado=c("Yaracuy","Portuguesa","Lara","Falcon",
                       "Apure","Guarico",
                       "Barinas","Merida","Tachira","Trujillo",
                       "Anzoategui","Monagas","Sucre",
                       "Amazonas","Bolivar","Delta Amacuro",
                       "Zulia",
                       "Aragua","Carabobo","Cojedes",
                       "Distrito Capital","Miranda","Vargas",
                       "Dependencias Federales","Nueva Esparta"))

for (k in 1:nrow(PEII)){
    dst.file <- sprintf("%s/PEII_%s.html",data.dir,gsub(" ","_",PEII$estado[k]))
    if (!file.exists(dst.file))
        download.file(sprintf("http://www.oncti.gob.ve/index.php/component/content/article?id=%s",PEII$id[k]),dst.file)
}


rm(lista.PEII)
for (k in 1:nrow(PEII)) {
    pg <- read_html(sprintf("%s/PEII_%s.html",data.dir,gsub(" ","_",PEII$estado[k])))

    for (j in 1:length(html_nodes(pg,"table"))) {
        rr <- html_table(html_nodes(pg,"table")[j],header=T,fill=T)[[1]]
        if (any(c("NOMBRE","NOMBRES") %in% colnames(rr))) {
            if (nrow(rr)>0) {
                rr$estado <- PEII$estado[k]
                if (!exists("lista.PEII")) {
                    lista.PEII <- rr
                } else {
                    colnames(rr) <- colnames(lista.PEII)
                    lista.PEII <- rbind(lista.PEII,rr)
                }
            }
        }
    }
}
