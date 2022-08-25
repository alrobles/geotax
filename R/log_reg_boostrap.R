#' Logistic regression coeficients.
#' Calculates the coefficients of a logistic regression.
#' As input use an incidence matrix of host - parasite interaction
#' and a phylogenetical distance matrix of host.
#' It replicates the calculation of the coefficients 1000 times
#' and gets the central tendency of the distribution of each coefficient.
#'
#' @param incidence Incidence binary matrix between pest - host interaction
#' @param phydist Phylogenetic host distance matrix
#' @param n Number of boostrap iteration
#' @importFrom stats median
#' @export
#'
#' @examples
#' phy_dist <- ape::cophenetic.phylo(host_tree)
#' incidence_matrix <-  get_incidence_matrix(beetleTreeInteractions)
#' incidence_matrix <- incidence_matrix[ , colnames(phy_dist)]
#' log_reg_boostrap(incidence_matrix, phy_dist, 10)
log_reg_boostrap <- function(incidence, phydist, n){
  coef <- t(replicate(n, get_log_reg_coefficients(incidence, phydist), simplify = TRUE) )
  coef <- apply( apply (coef, 2, as.numeric ), 2, mean )
  return(coef)
}

