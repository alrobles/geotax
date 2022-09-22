## code to prepare `phy_dist` dataset goes here
load("data-raw/phy_dist.RData")
usethis::use_data(phy_dist, overwrite = TRUE)
