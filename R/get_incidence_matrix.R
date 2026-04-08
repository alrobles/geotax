#' Generate an incidence matrix from an interaction table
#'
#' @description Deprecated. Use \code{\link{prepare_incidence_matrix}} instead.
#'
#' @param db A data.frame with two columns.
#' @param returnDataFrame Logical. If TRUE returns a tibble. Default FALSE.
#'
#' @return An incidence matrix or tibble.
#' @export
#' @examples
#' get_incidence_matrix(beetleTreeInteractions)
get_incidence_matrix <- function(db, returnDataFrame = FALSE) {
  .Deprecated("prepare_incidence_matrix")
  ret <- if (returnDataFrame) "tibble" else "matrix"
  prepare_incidence_matrix(db = db, return = ret)
}
