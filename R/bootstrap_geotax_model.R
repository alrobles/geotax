#' Bootstrap a geotax logistic regression model
#'
#' Runs the geotax logistic regression \code{n} times using random focal host
#' sampling, returning a distribution of coefficient estimates.
#' This is the v2 replacement for \code{log_reg_boostrap()}.
#'
#' @param incidence A binary incidence matrix (rows = parasites, cols = hosts).
#' @param phydist A square, numeric phylogenetic distance matrix among hosts.
#' @param n Integer. Number of bootstrap iterations. Default 1000.
#' @param seed Integer or NULL. Random seed for reproducibility. Default NULL.
#'
#' @return An S3 object of class \code{"geotax_bootstrap"}, a list with:
#' \describe{
#'   \item{call}{The matched call.}
#'   \item{n}{Number of bootstrap iterations.}
#'   \item{seed}{The seed used.}
#'   \item{coefficients}{A matrix of \code{n} rows x 12 columns (coefficient info
#'     from each iteration).}
#'   \item{summary}{A data.frame with the column-wise means (same 12 columns).}
#'   \item{metadata}{List with \code{n_parasites} and \code{n_hosts}.}
#' }
#'
#' @seealso \code{\link{log_reg_boostrap}} (deprecated),
#'   \code{\link{fit_geotax_model}}, \code{\link{predict_geotax_probability}}
#'
#' @export
#'
#' @examples
#' incidence <- prepare_incidence_matrix(beetleTreeInteractions)
#' aligned   <- align_geotax_inputs(incidence, phy_dist)
#' bootstrap_geotax_model(aligned$incidence, aligned$phydist, n = 5, seed = 42)
bootstrap_geotax_model <- function(incidence, phydist, n = 1000, seed = NULL) {
  .validate_geotax_inputs(incidence, phydist)
  n <- as.integer(n)

  if (!is.null(seed)) set.seed(seed)

  raw <- t(replicate(n, {
    df  <- .build_glm_dataframe(incidence, phydist)
    fit <- .fit_glm(df)
    ct  <- .extract_coef_table(fit)
    unlist(ct)
  }, simplify = TRUE))

  # Ensure raw is always a matrix (replicate with n=1 may return a vector)
  if (!is.matrix(raw)) {
    raw <- matrix(raw, nrow = 1L, dimnames = list(NULL, names(raw)))
  }

  raw_mat <- apply(raw, 2, as.numeric)
  if (!is.matrix(raw_mat)) {
    raw_mat <- matrix(raw_mat, nrow = n, ncol = length(raw_mat) / n,
                      dimnames = dimnames(raw))
  }
  means   <- as.data.frame(t(colMeans(raw_mat, na.rm = TRUE)))

  structure(
    list(
      call         = match.call(),
      n            = n,
      seed         = seed,
      coefficients = raw_mat,
      summary      = means,
      metadata     = list(
        n_parasites = nrow(incidence),
        n_hosts     = ncol(incidence)
      )
    ),
    class = "geotax_bootstrap"
  )
}

#' @export
print.geotax_bootstrap <- function(x, ...) {
  cat(sprintf("Geotax bootstrap (%d iterations)\n", x$n))
  cat(sprintf("Intercept (mean): %.4f\n", x$summary$intercept))
  cat(sprintf("Slope     (mean): %.4f\n", x$summary$slope))
  invisible(x)
}
