#' Create null raster points from a shape file
#'
#' Creates a point matrix from a shape file at an arbitrary resolution.
#' This is the v2 replacement for \code{null_raster_point()}.
#'
#' @param shp A spatial object (shape file).
#' @param res Positive numeric. Raster resolution in geographical degrees.
#'
#' @return A matrix of null raster points.
#'
#' @seealso \code{\link{null_raster_point}} (deprecated)
#'
#' @importFrom raster raster res crop rasterToPoints
#' @export
#'
#' @examples
#' make_null_raster_points(shp = mexico, res = 1)
make_null_raster_points <- function(shp, res) {
  .validate_spatial_inputs(shp, res = res)
  x <- raster::raster()
  raster::res(x) <- c(res, res)
  xcrop  <- raster::crop(x, shp)
  xpoint <- raster::rasterToPoints(xcrop)
  xpoint
}
