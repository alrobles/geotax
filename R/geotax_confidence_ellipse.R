#' Joint confidence ellipse for intercept and slope
#'
#' Computes the boundary of the joint confidence region ("ellipse") for a
#' pair of coefficients, either from a fitted \code{glm} (using the
#' asymptotic covariance matrix) or from a
#' \code{\link{cluster_bootstrap_geotax}} object (using the empirical
#' covariance of the bootstrap draws, which respects parasite-level
#' clustering).
#'
#' @param object A \code{glm} fit or a \code{geotax_cluster_bootstrap} object.
#' @param terms Character vector of length 2 with the coefficient names.
#'   Default \code{c("(Intercept)", "phydist")}.
#' @param level Confidence level. Default 0.95.
#' @param n_points Number of points on the ellipse boundary. Default 200.
#'
#' @return A data.frame with \code{n_points} rows and two columns named after
#'   \code{terms}, tracing the ellipse boundary. The center (point estimates)
#'   is returned as the \code{"center"} attribute.
#'
#' @seealso \code{\link{cluster_bootstrap_geotax}}
#'
#' @export
#'
#' @examples
#' pairs <- prepare_pair_data(beetleTreeInteractions, phy_dist)
#' boot <- cluster_bootstrap_geotax(pairs, n_boot = 50, seed = 42)
#' ell <- geotax_confidence_ellipse(boot)
#' plot(ell, type = "l")
#' points(t(attr(ell, "center")), pch = 19)
geotax_confidence_ellipse <- function(object,
                                      terms = c("(Intercept)", "phydist"),
                                      level = 0.95, n_points = 200) {
  if (length(terms) != 2 || !is.character(terms)) {
    stop("'terms' must be a character vector of length 2.")
  }
  if (!is.numeric(level) || level <= 0 || level >= 1) {
    stop("'level' must be between 0 and 1.")
  }

  if (inherits(object, "geotax_cluster_bootstrap")) {
    if (!all(terms %in% colnames(object$draws))) {
      stop(paste0("Terms not found in bootstrap draws: ",
                  paste(setdiff(terms, colnames(object$draws)), collapse = ", ")))
    }
    draws <- object$draws[stats::complete.cases(object$draws[, terms]), terms]
    center <- object$estimates[terms]
    v <- stats::cov(draws)
  } else if (inherits(object, "glm")) {
    cf <- stats::coef(object)
    if (!all(terms %in% names(cf))) {
      stop(paste0("Terms not found in model coefficients: ",
                  paste(setdiff(terms, names(cf)), collapse = ", ")))
    }
    center <- cf[terms]
    v <- stats::vcov(object)[terms, terms]
  } else {
    stop("'object' must be a glm fit or a geotax_cluster_bootstrap object.")
  }

  r <- sqrt(stats::qchisq(level, df = 2))
  theta <- seq(0, 2 * pi, length.out = n_points)
  circle <- cbind(cos(theta), sin(theta))
  ell <- sweep(r * circle %*% chol(v), 2, center, "+")
  ell <- as.data.frame(ell)
  colnames(ell) <- terms
  attr(ell, "center") <- center
  attr(ell, "level") <- level
  ell
}
