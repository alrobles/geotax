#' Predict host susceptibility probabilities from logistic regression coefficients
#'
#' Applies a logit function using intercept and slope coefficients to a vector
#' of phylogenetic distances. Accepts a numeric vector, a \code{geotax_model},
#' or a \code{geotax_bootstrap} object. This is the v2 replacement for
#' \code{prob_logit()}.
#'
#' @param coef A named numeric vector with elements \code{"intercept"} and
#'   \code{"slope"}, OR a \code{geotax_model} object, OR a \code{geotax_bootstrap}
#'   object (in which case the bootstrap summary means are used).
#'   An unnamed vector of length >= 2 is interpreted as \code{c(intercept, slope)}.
#' @param dist A numeric vector of phylogenetic distances.
#'
#' @return A named numeric vector of predicted probabilities of the same length
#'   as \code{dist}.
#'
#' @seealso \code{\link{prob_logit}} (deprecated), \code{\link{fit_geotax_model}}
#'
#' @export
#'
#' @examples
#' model <- fit_geotax_model(incidence, phy_dist, seed = 42)
#' dist_vec <- seq(0, max(phy_dist), length.out = 50)
#' predict_geotax_probability(model, dist_vec)
predict_geotax_probability <- function(coef, dist) {
  if (inherits(coef, "geotax_model")) {
    intercept <- coef$coefficients["intercept"]
    slope     <- coef$coefficients["slope"]
  } else if (inherits(coef, "geotax_bootstrap")) {
    intercept <- coef$summary$intercept
    slope     <- coef$summary$slope
  } else {
    if (!is.numeric(coef) || length(coef) < 2) {
      stop("'coef' must be a numeric vector of length >= 2, a geotax_model, or a geotax_bootstrap.")
    }
    if (!is.null(names(coef)) && "intercept" %in% names(coef) && "slope" %in% names(coef)) {
      intercept <- coef["intercept"]
      slope     <- coef["slope"]
    } else {
      intercept <- coef[1]
      slope     <- coef[2]
    }
  }

  if (!is.numeric(dist)) stop("'dist' must be a numeric vector.")

  logit <- intercept + slope * dist
  probs <- exp(logit) / (1 + exp(logit))
  names(probs) <- names(dist)
  probs
}

#' Extract coefficients from a geotax model or bootstrap object
#'
#' Returns a named list of model coefficients and their associated statistics
#' from a \code{geotax_model} or \code{geotax_bootstrap} object.
#'
#' @param model A \code{geotax_model} or \code{geotax_bootstrap} object.
#'
#' @return A named list with elements:
#' \describe{
#'   \item{intercept}{Intercept coefficient (mean for bootstrap).}
#'   \item{slope}{Slope coefficient (mean for bootstrap).}
#'   \item{intercept_se}{Standard error of intercept.}
#'   \item{slope_se}{Standard error of slope.}
#'   \item{intercept_ci}{Two-element vector with 2.5\% and 97.5\% CI for intercept.}
#'   \item{slope_ci}{Two-element vector with 2.5\% and 97.5\% CI for slope.}
#' }
#'
#' @export
#'
#' @examples
#' model <- fit_geotax_model(incidence, phy_dist, seed = 42)
#' extract_geotax_coefficients(model)
extract_geotax_coefficients <- function(model) {
  if (inherits(model, "geotax_model")) {
    list(
      intercept    = unname(model$coefficients["intercept"]),
      slope        = unname(model$coefficients["slope"]),
      intercept_se = unname(model$standard_errors["intercept"]),
      slope_se     = unname(model$standard_errors["slope"]),
      intercept_ci = model$confidence_intervals["intercept", ],
      slope_ci     = model$confidence_intervals["slope", ]
    )
  } else if (inherits(model, "geotax_bootstrap")) {
    s <- model$summary
    list(
      intercept    = s$intercept,
      slope        = s$slope,
      intercept_se = s$intercept_se,
      slope_se     = s$slope_se,
      intercept_ci = c("2.5%" = s$intercept_ci_lower, "97.5%" = s$intercept_ci_upper),
      slope_ci     = c("2.5%" = s$slope_ci_lower,     "97.5%" = s$slope_ci_upper)
    )
  } else {
    stop("'model' must be a geotax_model or geotax_bootstrap object.")
  }
}
