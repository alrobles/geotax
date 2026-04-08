# Shared test fixtures - loaded automatically by testthat

make_simple_incidence <- function() {
  matrix(
    c(1, 0, 1,
      0, 1, 1),
    nrow = 2, byrow = TRUE,
    dimnames = list(c("parasite1", "parasite2"), c("host1", "host2", "host3"))
  )
}

make_simple_phydist <- function() {
  matrix(
    c(0, 1, 2,
      1, 0, 1,
      2, 1, 0),
    nrow = 3,
    dimnames = list(c("host1", "host2", "host3"), c("host1", "host2", "host3"))
  )
}
