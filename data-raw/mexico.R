## code to prepare `mexico` dataset goes here
library("rgeos")
library("rgdal")
mexico <- rgdal::readOGR(system.file("mexico/mexico.shp", package = "geotax2"))
mexico@data <- mexico@data %>% dplyr::mutate(PAIS = "MEXICO")
mexico <- gUnaryUnion(mexico, id = mexico@data$PAIS)
usethis::use_data(mexico, overwrite = TRUE)
