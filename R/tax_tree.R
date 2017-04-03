#' Tax_tree Computes taxonomic tree from taxonomic table.
#' Needs a data frame witch taxonomic range as columns.
#'
#' @param tax_table A data frame with taxonomic information. Use taxonomic range as columns.
#'
#' @export
#'
#' @examples tax_tree(tax_table)
#'
tax_tree <- function(tax_table){
  if (class(tax_table) != "data.frame"){
      stop("The taxonomic table doesn't has the correct format.") }

  data <- unique(as.data.frame(tax_table) )
  n <- colnames(tax_table)
  f <- paste("~", paste(n[1], paste("/", n[2:length(n)], sep = "", collapse = "" ),
       sep=""), sep= "")
  tree_host <- ape::as.phylo.formula(stats::as.formula(f), data = data)
  return(tree_host)
  }

