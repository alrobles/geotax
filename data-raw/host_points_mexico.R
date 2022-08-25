## code to prepare `host_points_mexico` dataset goes here

pts  <- SpatialPointsDataFrame(coords = as.matrix(host_points[ ,2:3]),
                               data =  host_points[, 1] )
pts  <- SpatialPointsDataFrame(coords = host_points[ , 2:3],
  data =  host_points[ ,1], coords.nrs = c(2:3), proj4string =raster::crs(mexico)  )
pts_mexico_vec <- sp::over(pts, mexico)
host_points_mexico <- host_points[which(!is.na(pts_mexico)), ]

usethis::use_data(host_points_mexico, overwrite = TRUE)
