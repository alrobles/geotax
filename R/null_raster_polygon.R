#' Create a Spatial Polygon Data Set from a shape file
#'
#' @description Deprecated. Use \code{\link{make_null_raster_polygons}} instead.
#'
#' @param shp A shape file.
#' @param res Resolution in geographical degrees.
#'
#' @return A SpatialPolygonsDataFrame.
#' @importFrom raster raster res crop rasterToPolygons
#' @export
#' @examples
#' \dontrun{
#' null_raster_polygon(shp = mexico, res = 1)
#' }
null_raster_polygon <- function(shp, res) {
  .Deprecated("make_null_raster_polygons")
  make_null_raster_polygons(shp = shp, res = res)
}
