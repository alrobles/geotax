#' Create a taxonomic tree (cladogram) given a taxonomic table
#'
#' @description Deprecated. Use \code{\link{prepare_taxonomic_tree}} instead.
#'
#' @param tax_table A data frame with taxonomic information.
#' @param power Numeric; power for branch length computation. Default is 1.
#'
#' @return A cladogram (phylo object).
#' @export
#' @examples
#' \dontrun{
#' get_taxonomical_tree(tax_table)
#' }
get_taxonomical_tree <- function(tax_table, power = 1) {
  .Deprecated("prepare_taxonomic_tree")
  prepare_taxonomic_tree(tax_table = tax_table, power = power)
}
