#' Create a point matrix from a shape file with an arbitrary resolution
#'
#' @description Deprecated. Use \code{\link{make_null_raster_points}} instead.
#'
#' @param shp A shape file.
#' @param res Resolution in geographical degrees.
#'
#' @return A matrix of null raster points.
#' @importFrom raster raster res crop rasterToPoints
#' @export
#' @examples
#' null_raster_point(shp = mexico, res = 1)
null_raster_point <- function(shp, res) {
  .Deprecated("make_null_raster_points")
  make_null_raster_points(shp = shp, res = res)
}
