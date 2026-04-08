#' Prepare a taxonomic tree (cladogram) from a taxonomic table
#'
#' Creates a phylogenetic tree from a taxonomic table using taxonomic ranks
#' as a hierarchy. This is the v2 replacement for \code{get_taxonomical_tree()}.
#'
#' @details Uses the same algorithm as \code{\link[ape]{compute.brlen}} from the
#' ape package.
#'
#' @param tax_table A data.frame with taxonomic information. Columns must include
#'   at least 3 of: class, order, family, genus, species.
#' @param power Numeric. The power at which heights must be raised according to
#'   Grafen's (1989) computation of branch lengths. Default is 1.
#'
#' @return A phylo object (cladogram) derived from the taxonomic table.
#'
#' @seealso \code{\link{get_taxonomical_tree}} (deprecated)
#'
#' @importFrom ape as.phylo.formula compute.brlen
#' @importFrom stats as.formula
#' @importFrom dplyr select distinct all_of
#' @export
#'
#' @references \url{https://search.r-project.org/CRAN/refmans/ape/html/compute.brlen.html}
#'
#' @examples
#' prepare_taxonomic_tree(tax_table)
prepare_taxonomic_tree <- function(tax_table, power = 1) {
  .validate_tax_table(tax_table)

  fullNames  <- c("class", "order", "family", "genus", "species")
  matchNames <- match(colnames(tax_table), fullNames)
  sortNames  <- fullNames[matchNames[!is.na(matchNames)]]

  tax_table  <- dplyr::select(tax_table, dplyr::all_of(sortNames))
  tax_table  <- dplyr::distinct(tax_table)
  tax_table  <- as.data.frame(lapply(tax_table, as.factor))
  rankNames  <- colnames(tax_table)

  formulaNames <- paste("~",
    paste(rankNames[1],
          paste("/", rankNames[2:length(rankNames)], sep = "", collapse = ""),
          sep = ""),
    sep = "")

  finalTree <- ape::as.phylo.formula(stats::as.formula(formulaNames), data = tax_table)
  finalTree <- ape::compute.brlen(finalTree, power = power)
  finalTree
}
