#' Create null raster polygons from a shape file
#'
#' Creates a spatial polygon data set from a shape file at an arbitrary
#' resolution.
#'
#' @param shp A spatial object (shape file).
#' @param res Positive numeric. Raster resolution in geographical degrees.
#'
#' @return A SpatialPolygonsDataFrame of null raster polygons.
#'
#'
#' @importFrom raster raster res crop rasterToPolygons
#' @export
#'
#' @examples
#' make_null_raster_polygons(shp = mexico, res = 1)
make_null_raster_polygons <- function(shp, res) {
  .validate_spatial_inputs(shp, res = res)
  x <- raster::raster()
  raster::res(x) <- c(res, res)
  xcrop    <- raster::crop(x, shp)
  xpolygon <- raster::rasterToPolygons(xcrop)
  xpolygon
}
