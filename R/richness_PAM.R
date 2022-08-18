#' Create a richness raster from Presence-Absence-Matrix (PAM) along geographical area
#'
#' @param PAM A Presence Absence Matrix
#' @param shp A shape file to delimit geographical area of the raster
#' @param res A resolution vector of raster in geographical degrees
#' @examples richness_PAM(shp = world, PAM = PAM(world, host_points, 3), res = 3)
#' @export
#'

richness_PAM <- function(shp, PAM, res){
  xpoint <- geotax::null_raster_point(shp, res)
  richness <- raster::rasterFromXYZ( cbind(xpoint,colSums(PAM) ) )
  return(richness)
  }
