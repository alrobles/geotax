
#' Generate an incidence matrix from interaction data base
#'
#' @param db A data base with two columns, interactuans and interactors
#' @examples incidence (db = inter_data)
#' @export



# This function creates an incidence matrix
# for species interactions
# Need datafrane with 2 columns, one with the interactors
# and the other with tis interactuans

incidence <- function(db){

  if (ncol(db) != 2){
    stop("The data base has not two columns.") }

  interactors   <- unique(db[ ,1])
  interactuans  <- unique(db[ ,2])
  incidence.matrix <- sapply(interactors, function(x){
    as.numeric( interactuans %in% db[ (db[ ,1] %in% x), 2 ] ) } )
  rownames(incidence.matrix) <- interactuans
  colnames(incidence.matrix) <- interactors
  return(t(incidence.matrix))
}


