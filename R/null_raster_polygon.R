#' Create a Spatial polygon Data Set from a shape file
#' with an arbitrary resolution
#'
#' @param shp A shape file
#' @param res A resolution vector of the null raster in geographical degrees
#' @importFrom raster raster res rasterToPolygons crop
#'
#' @return a null polygon
#' @export
#'
#' @examples null_raster_polygon(shp = mexico, res = 1)
null_raster_polygon <- function(shp, res){
  x <- raster::raster()
  raster::res(x) <- c(res, res)
  xcrop <- raster::crop(x, shp)
  xpolygon <- raster::rasterToPolygons(xcrop)
  return(xpolygon)
}
