

#' Generate a binary random matrix with a sucsess parameter
#'
#' @param m The number of columns
#' @param n The number of rows
#' @param succes The succes rate in each row. Default is 0.5
#' @examples bin_matrix (m = 3  , n =  4, succes =  0.3)
#' @export

bin_matrix <-function (m, n, succes ) {
	return(matrix(ifelse(stats::runif(m * n) > succes, 1, 0), ncol = m, nrow = n))
}
