#' Bootstrap logistic regression coefficients
#'
#' @description Deprecated. Use \code{\link{bootstrap_geotax_model}} instead.
#'
#' @param incidence Incidence binary matrix.
#' @param phydist Phylogenetic distance matrix.
#' @param n Number of bootstrap iterations.
#'
#' @return A named numeric vector of mean coefficients (old format).
#' @importFrom stats median
#' @export
#' @examples
#' incidence_matrix <- get_incidence_matrix(beetleTreeInteractions)
#' incidence_matrix <- incidence_matrix[, colnames(phy_dist)]
#' log_reg_boostrap(incidence_matrix, phy_dist, 10)
log_reg_boostrap <- function(incidence, phydist, n) {
  .Deprecated("bootstrap_geotax_model")
  result <- bootstrap_geotax_model(incidence = incidence, phydist = phydist, n = n, seed = NULL)
  s <- result$summary
  old_names <- c("intercept", "Std. Error", "z value", "Pr(>|z|)", "2.5 %", "97.5 %",
                 "slope", "Std. Error", "z value", "Pr(>|z|)", "2.5 %", "97.5 %")
  out <- c(s$intercept, s$intercept_se, s$intercept_z, s$intercept_p,
           s$intercept_ci_lower, s$intercept_ci_upper,
           s$slope, s$slope_se, s$slope_z, s$slope_p,
           s$slope_ci_lower, s$slope_ci_upper)
  names(out) <- old_names
  out
}
