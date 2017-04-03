#' prob_logit
#'
#' @param coef Coefficients of logistic regresion
#' @param dist A distance matrix to perform regression
#' @export
#'

prob_logit <- function(coef, dist ){
  logit <- coef[1] + coef[2]*dist
  prob_logit <- (exp(logit)/(1+exp(logit)))
  return(prob_logit)
}
