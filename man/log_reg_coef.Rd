% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/log_reg_coef.R
\name{log_reg_coef}
\alias{log_reg_coef}
\title{Logistic regression coeficients. Calculates the coefficients of a logistic
regression. Use an incidence matrix of pest - host interaction and a
phylogenetical distance matrix of host.}
\usage{
log_reg_coef(incidence, phydist)
}
\arguments{
\item{incidence}{Incidence binary matrix between pest - host interaction}

\item{phydist}{Phylogenetic host distance matrix}
}
\description{
Logistic regression coeficients. Calculates the coefficients of a logistic
regression. Use an incidence matrix of pest - host interaction and a
phylogenetical distance matrix of host.
}
\examples{
incidence_matrix <-  get_incidence_matrix(db = beetleTreeInteractions)
incidence_matrix <- incidence_matrix[, colnames(phy_dist)]
log_reg_coef(incidence_matrix, phy_dist)


}
