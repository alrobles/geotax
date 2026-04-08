#' Logistic regression coefficients
#'
#' @description Deprecated. Use \code{\link{fit_geotax_model}} instead.
#'
#' @param incidence Incidence binary matrix.
#' @param phydist Phylogenetic distance matrix.
#'
#' @return A data.frame of logistic regression coefficients.
#' @export
#' @examples
#' \dontrun{
#' incidence_matrix <- get_incidence_matrix(beetleTreeInteractions)
#' incidence_matrix <- incidence_matrix[, colnames(phy_dist)]
#' get_log_reg_coefficients(incidence_matrix, phy_dist)
#' }
get_log_reg_coefficients <- function(incidence, phydist) {
  .Deprecated("fit_geotax_model")
  model <- fit_geotax_model(incidence = incidence, phydist = phydist)
  ct <- .extract_coef_table(model$fitted_model)
  lrcoeffs <- data.frame(
    ct$intercept, ct$intercept_se, ct$intercept_z, ct$intercept_p,
    ct$intercept_ci_lower, ct$intercept_ci_upper,
    ct$slope, ct$slope_se, ct$slope_z, ct$slope_p,
    ct$slope_ci_lower, ct$slope_ci_upper
  )
  colnames(lrcoeffs) <- c("intercept", "Std. Error", "z value", "Pr(>|z|)",
                           "2.5 %", "97.5 %",
                           "slope", "Std. Error", "z value", "Pr(>|z|)",
                           "2.5 %", "97.5 %")
  rownames(lrcoeffs) <- NULL
  lrcoeffs
}
