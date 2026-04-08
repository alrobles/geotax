#' Predict probabilities from logistic regression coefficients
#'
#' @description Deprecated. Use \code{\link{predict_geotax_probability}} instead.
#'
#' @param coef A vector of two elements (intercept and slope).
#' @param dist A numeric vector of distances.
#'
#' @return A vector of probabilities.
#' @export
#' @examples
#' prob_logit(c(1, -0.5), seq(0, 10, 1))
prob_logit <- function(coef, dist) {
  .Deprecated("predict_geotax_probability")
  predict_geotax_probability(coef = coef, dist = dist)
}
