#' Create a Spatial polygon Data Set from a shape file with an arbitrary resolution
#'
#' @param shp A shape file
#' @param res A resolution vector of the null raster in geographical degrees
#' @examples null_raster_polygon(shp = world, res = 1)
#' @export

null_raster_polygon <- function(shp, res){
  x <- raster::raster()
  raster::res(x) <- c(res, res)
  xcrop <- raster::crop(x, shp)
  xpolygon <- raster::rasterToPolygons(xcrop)
  return(xpolygon)
}
