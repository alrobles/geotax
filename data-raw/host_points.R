## code to prepare `host_points` dataset goes here
host_points <- tibble::tibble(host_points)
host_points <- host_points %>%
  dplyr::filter(genus %in% host_tree_prune$tip.label)


usethis::use_data(host_points, overwrite = TRUE, compress = "xz")
