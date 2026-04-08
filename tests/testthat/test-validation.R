test_that(".validate_tax_table rejects non-data.frame", {
  expect_error(.validate_tax_table(matrix(1:4, 2, 2)), "'tax_table' must be a data.frame")
})

test_that(".validate_tax_table rejects too few matching columns", {
  df <- data.frame(a = 1:3, b = 1:3)
  expect_error(.validate_tax_table(df), "at least 3 columns")
})

test_that(".validate_tax_table rejects single unique row", {
  df <- data.frame(class = "A", order = "B", family = "C")
  expect_error(.validate_tax_table(df), "at least 2 unique rows")
})

test_that(".validate_tax_table passes valid input", {
  df <- data.frame(class = c("A", "B"), order = c("C", "D"), family = c("E", "F"))
  expect_invisible(.validate_tax_table(df))
})

test_that(".validate_incidence rejects non-matrix/data.frame", {
  expect_error(.validate_incidence(1:5), "must be a matrix or data.frame")
})

test_that(".validate_incidence rejects missing dimnames", {
  m <- matrix(c(0, 1, 1, 0), nrow = 2)
  expect_error(.validate_incidence(m), "must have both rownames and colnames")
})

test_that(".validate_incidence rejects non-binary values", {
  m <- matrix(c(0, 2, 1, 0), nrow = 2,
              dimnames = list(c("p1", "p2"), c("h1", "h2")))
  expect_error(.validate_incidence(m), "binary")
})

test_that(".validate_incidence passes valid binary matrix", {
  m <- matrix(c(1, 0, 0, 1), nrow = 2,
              dimnames = list(c("p1", "p2"), c("h1", "h2")))
  expect_invisible(.validate_incidence(m))
})

test_that(".validate_phydist rejects non-matrix", {
  expect_error(.validate_phydist(data.frame(a = 1)), "must be a matrix")
})

test_that(".validate_phydist rejects non-square matrix", {
  m <- matrix(1:6, 2, 3)
  expect_error(.validate_phydist(m), "square matrix")
})

test_that(".validate_phydist rejects mismatched row/col names", {
  m <- matrix(c(0, 1, 1, 0), 2, 2,
              dimnames = list(c("a", "b"), c("c", "d")))
  expect_error(.validate_phydist(m), "rownames must equal colnames")
})

test_that(".validate_phydist passes valid input", {
  m <- matrix(c(0, 1, 1, 0), 2, 2,
              dimnames = list(c("a", "b"), c("a", "b")))
  expect_invisible(.validate_phydist(m))
})

test_that(".validate_spatial_inputs rejects negative res", {
  expect_error(.validate_spatial_inputs("shp", res = -1), "positive numeric")
})

test_that(".validate_spatial_inputs rejects wrong points columns", {
  pts <- data.frame(a = 1, b = 2)
  expect_error(.validate_spatial_inputs("shp", points = pts), "exactly 3 columns")
})

test_that(".check_incidence_phydist_alignment catches missing hosts", {
  inc <- matrix(c(1, 0), nrow = 1, dimnames = list("p1", c("h1", "h2")))
  phy <- matrix(0, 1, 1, dimnames = list("h1", "h1"))
  expect_error(.check_incidence_phydist_alignment(inc, phy), "not in phydist")
})
