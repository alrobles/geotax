#' Logistic regression coeficients. Calculates the coefficients of a logistic
#' regression. Use an incidence matrix of pest - host interaction and a
#' phylogenetical distance matrix of host.
#'
#' @param incidence Incidence binary matrix between pest - host interaction
#' @param phydist Phylogenetic host distance matrix
#' @param n Number of boostrap iteration
#' @export
#'
#' @examples log_reg_boostrap(incidence, phydist, 10)
log_reg_boostrap <- function(incidence, phydist, n){
  coef <- t(replicate(n, geotax::log_reg_coef(incidence, phydist), simplify = T) )
  coef <- apply( apply (coef, 2, as.numeric ), 2, mean )
  return(coef)
}

