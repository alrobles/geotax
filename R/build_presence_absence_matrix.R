#' Build a presence-absence matrix from species occurrence points
#'
#' Creates a presence-absence matrix (PAM) overlaying species occurrence points
#' onto a raster grid derived from a shape file. This is the v2 replacement
#' for \code{PAM()}.
#'
#' @param shp A spatial object (shape file / SpatialPolygonsDataFrame).
#' @param points A data.frame with 3 columns: species name, longitude, latitude.
#' @param res Positive numeric. Raster resolution in geographical degrees.
#'
#' @return A tibble with rows representing raster cells (with x/y coordinates)
#'   and columns for each species, filled with 0/1.
#'
#' @seealso \code{\link{PAM}} (deprecated)
#'
#' @importFrom sp SpatialPointsDataFrame
#' @importFrom raster raster extract as.data.frame ncell values
#' @importFrom tibble enframe as_tibble
#' @importFrom rlang .data
#' @importFrom dplyr bind_cols select distinct arrange mutate inner_join
#' @importFrom tidyr spread
#' @export
#'
#' @examples
#' build_presence_absence_matrix(shp = mexico, points = host_points_mexico, res = 3)
build_presence_absence_matrix <- function(shp, points, res) {
  .validate_spatial_inputs(shp, points = points, res = res)

  pts <- sp::SpatialPointsDataFrame(
    coords       = as.matrix(points[, c(2, 3)]),
    data         = data.frame(label = points[[1]]),
    coords.nrs   = c(2:3),
    proj4string  = raster::crs(shp)
  )
  r <- raster::raster(shp, res = res)
  raster::values(r) <- 1:raster::ncell(r)

  point_cell <- raster::extract(x = r, y = pts) %>%
    tibble::enframe(value = "layer")

  pam <- dplyr::bind_cols(points, point_cell) %>%
    dplyr::select(.data$layer, 1) %>%
    dplyr::distinct() %>%
    dplyr::arrange(.data$layer) %>%
    dplyr::mutate(value = 1) %>%
    tidyr::spread(2, 3, fill = 0)

  dplyr::inner_join(
    tibble::as_tibble(raster::as.data.frame(r, xy = TRUE)),
    pam,
    by = "layer"
  )
}
