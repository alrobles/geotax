## code to prepare `inter_data` dataset goes here
load("data-raw/inter_data.RData")
beetleTreeInteractions <- tibble(inter_data)

usethis::use_data(beetleTreeInteractions, overwrite = TRUE)
