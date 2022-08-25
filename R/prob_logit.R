#' Get probabilities from logistic regression coefficients.
#' @description After a logistic model fit a logit function with the
#' coefficients of the regression to get the probabilities given a distance
#' vector. Usually the distance vector is used to plot the logistic model
#' as a curve from 0 to the maximum value of a distribution matrix used
#' to perform de logistic regression model.
#'
#' @param coef A vector of two elements of coefficients (Intercept and slope)
#' in a logistic regression.#'
#' @param dist A vector of distance to perform de regression
#'
#' @return A vector of probabilities given the vector of regression
#' @export
#'
#' @examples
#' phy_dist <- ape::cophenetic.phylo(host_tree)
#' phy_dist <- log10(phy_dist + 1)
#' incidence_matrix <-  get_incidence_matrix(beetleTreeInteractions)
#' incidence_matrix <- incidence_matrix[ ,colnames(phy_dist)]
#' coefficients <- log_reg_boostrap(incidence_matrix, phy_dist, 10)
#' coefficientsValues <- c(coefficients[["intercept"]], coefficients[["slope"]] )
#' distVector <- seq(0, max(phy_dist), 1)
#' prob_logit(coefficientsValues, distVector)

prob_logit <- function(coef, dist ){
  logit <- coef[1] + coef[2]*dist
  prob_logit <- (exp(logit)/(1+exp(logit)))
  return(prob_logit)
}
