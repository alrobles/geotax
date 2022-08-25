#' Create a point matrix from from a shape file with an arbitrary resolution
#'
#' @param shp A shape file
#' @param res A resolution vector of the null raster in geographical degrees
#' @importFrom raster raster crop rasterToPoints
#' @return a data frame of null points
#' @export
#'
#' @examples null_raster_point(shp = mexico, res = 1)
null_raster_point <- function(shp, res){
  x <- raster::raster()
  raster::res(x) <- c(res, res)
  xcrop <- raster::crop(x, shp)
  xpoint <- raster::rasterToPoints(xcrop)
  return(xpoint)
}
