#' Logistic regression coeficients. Calculates the coefficients of a logistic
#' regression. Use an incidence matrix of pest - host interaction and a
#' phylogenetical distance matrix of host.
#'
#' @param incidence Incidence binary matrix between pest - host interaction
#' @param phydist Phylogenetic host distance matrix
#' @export
#'
#' @examples log_reg_coef(incidence, phydist)
#'
#'

log_reg_coef <- function(incidence, phydist){
  if(nrow(incidence) == 1 ){
    l <- list(names( incidence[ , apply(incidence, 2, function(x) (x==1) ) ] ) )
    names(l) <- rownames(incidence)
  }
  else{
    l <- lapply( apply (apply(incidence, 2, function(x) (x==1) ), 1, which),  names)
  }
  focal <- lapply(l, function(x) sample(x, 1))
  df <- do.call(rbind, lapply(names(focal), function(x) data.frame(colnames(incidence),
                focal[[x]], phydist[ , focal[[x]] ], as.numeric(incidence[x, ]), x) ) )
  colnames(df) <- c("tohost", "fromhost", "phydist", "suscept", "incidence")

  log_out <- stats::glm(df$suscept ~ df$phydist, family = stats::binomial(link="logit") )
  stats_log_out <- stats::coef(summary(log_out) )
  conf_int <- stats::confint.default(log_out)

  lrcoeffs <- data.frame(log_out$coefficients[1],
                         stats_log_out[1, 2],
                         stats_log_out[1, 3],
                         stats_log_out[1, 4],
                         conf_int[1, 1], conf_int[1, 2],
                         log_out$coefficients[2],
                         stats_log_out[2, 2],
                         stats_log_out[2, 3],
                         stats_log_out[2, 4],
                         conf_int[2, 1], conf_int[2, 2]  )
  colnames(lrcoeffs) <- c("intercept", "Std. Error", "z value", "Pr(>|z|)", "2.5 %", "97.5 %",
                          "slope", "Std. Error", "z value", "Pr(>|z|)", "2.5 %", "97.5 %" )
  rownames(lrcoeffs)  <- NULL
  return(lrcoeffs)
}
