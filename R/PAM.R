#' Create a Presence Absence Matrix
#'
#' @param points Data frame with sp long lat
#' @param shp A shape file
#' @param res A resolution vector of the null raster in geographical degrees
#' @importFrom sp SpatialPointsDataFrame
#' @importFrom raster raster extract as.data.frame ncell values
#' @importFrom tibble enframe as_tibble
#' @importFrom rlang .data
#' @importFrom dplyr bind_cols select distinct arrange mutate inner_join
#' @importFrom tidyr spread
#' @return A tibble fill with ones and zeros, column names of species and
#' rows of sites with coordinates
#' @export
#'
#' @examples PAM(shp = mexico, points = host_points_mexico, res = 3)

PAM <- function(shp, points, res){
  if (ncol(points) != 3){
    stop("The points data doesn't has the correct format.") }


  pts <- sp::SpatialPointsDataFrame(coords = as.matrix(points[ ,c(2,3)]),
                         data = data.frame(label = points[[1]]),
                         coords.nrs = c(2:3),
                         proj4string = raster::crs(shp)  )
  r <- raster::raster(shp, res = res)

  raster::values(r) <- 1:raster::ncell(r)

  point_cell <- raster::extract(x = r, y = pts ) %>%
    tibble::enframe(value = "layer")


  PAM <- dplyr::bind_cols(points, point_cell) %>%
    dplyr::select(.data$layer, 1) %>%
    dplyr::distinct() %>%
    dplyr::arrange(.data$layer)  %>%
    dplyr::mutate(value = 1) %>%
    tidyr::spread(2, 3, fill = 0)

  PAM <- dplyr::inner_join(tibble::as_tibble(raster::as.data.frame(r, xy = TRUE)  ), PAM, by = "layer")
  return(PAM)
}
