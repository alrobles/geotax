## code to prepare `tax_table` dataset goes here
load("data-raw/tax-table.RData")
tax_table <- tibble::tibble(tax_table)
usethis::use_data(tax_table, overwrite = TRUE)
