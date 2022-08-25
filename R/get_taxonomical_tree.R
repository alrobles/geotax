#' Create a taxonomic tree (cladogram) given a taxonomic table
#'
#' Internally use the as.phylo.formula from the ape R package. Internally parse
#' the name of the taxonomical hierarchy to a formula. Works with a table
#' which columns are the taxonomic hierarchy from left to right.
#'
#' @details Use the same algorithm in compute.brlen from ape package
#' @param tax_table A data frame (or tibble) with taxonomic information.
#' @param power The power at which heights must be raised according to
#' Grafen's (1989) computation of branch lengths.
#' Use taxonomic hierarchy (class, order, family genus, species) as columns.
#' Default is 1 to get distances as integer numbers.
#' @importFrom ape as.phylo.formula compute.brlen
#' @importFrom stats as.formula
#' @importFrom dplyr select distinct all_of
#' @return A cladogram (tree) from taxonomic table
#' @export
#' @references \url{https://search.r-project.org/CRAN/refmans/ape/html/compute.brlen.html}
#' @examples get_taxonomical_tree(tax_table)
get_taxonomical_tree <- function(tax_table, power = 1){

  flag <- "data.frame" %in% class(tax_table)
  if (!flag){
    stop("The taxonomic table doesn't has the correct format.") }

  fullNames <- c("class", "order", "family", "genus", "species")
  matchNames <- match( colnames(tax_table), fullNames)

  if (length(matchNames) < 3){
    stop("The taxonomic table doesn't has enough taxonomic ranks.") }

  sortNames <- fullNames[matchNames]
  tax_table <- dplyr::select(tax_table, dplyr::all_of(sortNames))
  tax_table <- dplyr::distinct(tax_table)
  #data <- unique(as.data.frame(tax_table) )
  rankNames <- colnames(tax_table)
  formulaNames <- paste("~", paste(rankNames[1],
                        paste("/", rankNames[2:length(rankNames)],
                              sep = "", collapse = "" ),
                        sep = ""),
             sep =  "")
  finalTree <- ape::as.phylo.formula(stats::as.formula(formulaNames),
                                     data = tax_table)
  finalTree <- ape::compute.brlen(finalTree, power = power)
  return(finalTree)
}
