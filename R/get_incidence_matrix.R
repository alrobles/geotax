#' Generate an incidence matrix from a interaction table
#'
#' @description This function creates an incidence matrix
#  for species interactions. Needs dataframe with 2 columns,
#  for example one with the host and the other with the parasites

#' @param db A data.frame or matrix with two columns,
#' for example host and parasites
#'
#' @param returnDataFrame Logical, by default if FALSE and the function
#' returns a Matrix
#'
#' @return An incidence matrix or data.frame (tibble) with rows of one
#' kind (for example host) and columns with the other (for example parasites)
#' filled with ones and zeros.
#' @export
#'
#' @examples
#' get_incidence_matrix(beetleTreeInteractions)
#' get_incidence_matrix(beetleTreeInteractions,
#' returnDataFrame = TRUE)
get_incidence_matrix <- function(db, returnDataFrame = FALSE){

  flag <- "data.frame" %in% class(db)
  if (!flag){
    stop("The table is not a data frame.") }

  if (ncol(db) != 2){
    stop("The table does not have two columns.") }
  if(!returnDataFrame){
    db <- as.matrix(db)
    interactors   <- unique(db[ ,1])
    interactuans  <- unique(db[ ,2])
    incidence.matrix <- sapply(interactors, function(x){
      as.numeric( interactuans %in% db[ (db[ ,1] %in% x), 2 ] ) } )
    rownames(incidence.matrix) <- interactuans
    colnames(incidence.matrix) <- interactors
    return(t(incidence.matrix))
  } else {
    db %>%
      dplyr::mutate(value = 1) %>%
      dplyr::distinct() %>%
      spread(2, 3, fill = 0)
  }
}


