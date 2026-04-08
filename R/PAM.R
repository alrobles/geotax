#' Create a Presence Absence Matrix
#'
#' @description Deprecated. Use \code{\link{build_presence_absence_matrix}} instead.
#'
#' @param shp A shape file.
#' @param points Data frame with sp long lat (3 columns).
#' @param res Resolution in geographical degrees.
#'
#' @return A tibble PAM.
#' @importFrom sp SpatialPointsDataFrame
#' @importFrom raster raster extract as.data.frame ncell values
#' @importFrom tibble enframe as_tibble
#' @importFrom rlang .data
#' @importFrom dplyr bind_cols select distinct arrange mutate inner_join
#' @importFrom tidyr spread
#' @export
#' @examples
#' \dontrun{
#' PAM(shp = mexico, points = host_points_mexico, res = 3)
#' }
PAM <- function(shp, points, res) {
  .Deprecated("build_presence_absence_matrix")
  build_presence_absence_matrix(shp = shp, points = points, res = res)
}
