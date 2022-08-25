#' Generate a binary random matrix of ones and zeros with a
#' threshold parameter
#'
#' @param m The number of columns
#' @param n The number of rows
#' @param success The probability of success in each trial. Default is 0.5
#'
#' @importFrom stats runif
#'
#' @return Matrix with ones and zeros
#' @export
#'
#' @examples get_bin_matrix(m = 3  , n =  4, success = 0.3)

get_bin_matrix <- function (m, n, success) {


  return(matrix(ifelse(stats::runif(m * n) > success, 1, 0),
                ncol = m,
                nrow = n)
         )

}
