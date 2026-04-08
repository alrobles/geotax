#' Prepare an incidence matrix from an interaction table
#'
#' Builds an incidence (presence/absence) matrix from a two-column data.frame
#' of species interactions. This is the v2 replacement for
#' \code{get_incidence_matrix()}.
#'
#' @param db A data.frame with exactly two columns (e.g., host and parasite).
#' @param return Character. Either \code{"matrix"} (default) or \code{"tibble"}.
#'
#' @return An incidence matrix (rows = first column unique values, cols =
#'   second column unique values) filled with 0/1, or a tibble if
#'   \code{return = "tibble"}.
#'
#' @seealso \code{\link{get_incidence_matrix}} (deprecated)
#'
#' @importFrom dplyr mutate distinct
#' @importFrom tidyr spread
#' @export
#'
#' @examples
#' prepare_incidence_matrix(beetleTreeInteractions)
#' prepare_incidence_matrix(beetleTreeInteractions, return = "tibble")
prepare_incidence_matrix <- function(db, return = c("matrix", "tibble")) {
  return <- match.arg(return)

  if (!inherits(db, "data.frame")) {
    stop("'db' must be a data.frame.")
  }
  if (ncol(db) != 2) {
    stop("'db' must have exactly two columns.")
  }

  if (return == "matrix") {
    m <- as.matrix(db)
    interactors  <- unique(m[, 1])
    interactuans <- unique(m[, 2])
    incidence_mat <- sapply(interactors, function(x) {
      as.numeric(interactuans %in% m[(m[, 1] %in% x), 2])
    })
    rownames(incidence_mat) <- interactuans
    colnames(incidence_mat) <- interactors
    return(t(incidence_mat))
  } else {
    db %>%
      dplyr::mutate(value = 1) %>%
      dplyr::distinct() %>%
      tidyr::spread(2, 3, fill = 0)
  }
}

#' Align incidence matrix and phylogenetic distance matrix
#'
#' Validates both inputs and reorders the columns of \code{incidence} to match
#' the column order of \code{phydist}.
#'
#' @param incidence A binary incidence matrix (rows = parasites, cols = hosts).
#' @param phydist A square phylogenetic distance matrix among hosts.
#'
#' @return A named list with:
#' \describe{
#'   \item{incidence}{The incidence matrix with columns reordered to match \code{phydist}.}
#'   \item{phydist}{The (unchanged) phylogenetic distance matrix.}
#' }
#'
#' @export
#'
#' @examples
#' incidence <- prepare_incidence_matrix(beetleTreeInteractions)
#' aligned <- align_geotax_inputs(incidence, phy_dist)
align_geotax_inputs <- function(incidence, phydist) {
  .validate_incidence(incidence)
  .validate_phydist(phydist)
  .check_incidence_phydist_alignment(incidence, phydist)

  common_cols       <- intersect(colnames(phydist), colnames(incidence))
  incidence_aligned <- incidence[, common_cols, drop = FALSE]

  list(incidence = incidence_aligned, phydist = phydist)
}
