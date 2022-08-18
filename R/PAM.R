#' Create a Presence Absence Matrix
#'
#' @param points Data frame with sp long lat
#' @param shp A shape file
#' @param res A resolution vector of the null raster in geographical degrees
#' @examples PAM(shp = world, points = host_points, res = 3)
#' @export
#'
PAM <- function(shp, points, res){
  if (ncol(points) != 3){
    stop("The points data doesn't has the correct format.") }

  x_poly <- geotax::null_raster_polygon(shp, res)
  point_cell <- raster::extract(x_poly, points[ ,c(2,3)] )
  m <- match(unique(point_cell[,"point.ID"]), point_cell[,"point.ID"])
  point_cell <- point_cell[m, 1:2 ]
  sp.cell.df <- data.frame( points[ , 1 ] , point_cell$poly.ID)
  sp <- unique(sp.cell.df[ ,1 ])
  cells <- 1:length(x_poly)
  table <-  sapply(sp, function(x)
            as.numeric ( cells %in% sp.cell.df[ (sp.cell.df[ ,1] %in% x ), 2]) )
  PAM <- t(table)
  rownames(PAM) <- sp
  return(PAM)

  }
