## code to prepare `host_tree_prune` dataset goes here
load("data-raw/host_tree.rda")

genus_names <- host_points %>%
  dplyr::distinct(genus) %>%
  dplyr::filter(! genus %in% c("Heynea", "Muellera", "Deguelia",  "Paraderris", "Aegiphila", "Cartrema")  ) %>%
  dplyr::pull(genus)
host_tree_prune <- keep.tip(host_tree, as.character(genus_names))

usethis::use_data(host_tree_prune, overwrite = TRUE)
