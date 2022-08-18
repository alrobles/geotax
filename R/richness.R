#' Create a richness raster from species occurrens along geographical area
#'
#' @param points needs data frame with sp long lat
#' @param shp A shape file to delimit geographical area of the raster
#' @param res A resolution vector of raster in geographical degrees
#' @examples richness(shp = world, points = host_points, res = 3)
#' @export
#'

richness <- function(shp, points, res){
  #@points needs data frame with sp long lat

  if (ncol(points) != 3){
    stop("The points data doesn't has the correct format.") }

  xpoint <-  geotax::null_raster_point(shp, res)
  pam <- geotax::PAM(shp, points, res)

  richness <- raster::rasterFromXYZ( cbind(xpoint, colSums(pam) ) )
  return(richness)
}

