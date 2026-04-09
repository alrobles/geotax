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

test_that(".validate_tax_table rejects NA values in rank columns", {
  df <- data.frame(class = c("A", NA), order = c("C", "D"), family = c("E", "F"))
  expect_error(.validate_tax_table(df), "NA values")
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

test_that(".validate_incidence rejects duplicate rownames", {
  m <- matrix(c(1, 0, 0, 1), nrow = 2,
              dimnames = list(c("p1", "p1"), c("h1", "h2")))
  expect_error(.validate_incidence(m), "duplicate rownames")
})

test_that(".validate_incidence rejects duplicate colnames", {
  m <- matrix(c(1, 0, 0, 1), nrow = 2,
              dimnames = list(c("p1", "p2"), c("h1", "h1")))
  expect_error(.validate_incidence(m), "duplicate colnames")
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

test_that(".validate_phydist rejects NA values", {
  m <- matrix(c(0, NA, NA, 0), 2, 2,
              dimnames = list(c("a", "b"), c("a", "b")))
  expect_error(.validate_phydist(m), "NA values")
})

test_that(".validate_phydist rejects negative off-diagonal values", {
  m <- matrix(c(0, -1, -1, 0), 2, 2,
              dimnames = list(c("a", "b"), c("a", "b")))
  expect_error(.validate_phydist(m), "non-negative")
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

test_that(".validate_spatial_inputs rejects non-data.frame/matrix points", {
  expect_error(.validate_spatial_inputs("shp", points = list(a = 1, b = 2, c = 3)),
               "data.frame or matrix")
})

test_that(".validate_spatial_inputs rejects NA coordinate values", {
  pts <- data.frame(sp = "A", lon = NA_real_, lat = 10)
  expect_error(.validate_spatial_inputs("shp", points = pts), "NA values in coordinate")
})

test_that(".validate_spatial_inputs passes valid points and res", {
  pts <- data.frame(sp = "A", lon = -99.1, lat = 19.4)
  expect_invisible(.validate_spatial_inputs("shp", points = pts, res = 1))
})

test_that(".check_incidence_phydist_alignment catches missing hosts", {
  inc <- matrix(c(1, 0), nrow = 1, dimnames = list("p1", c("h1", "h2")))
  phy <- matrix(0, 1, 1, dimnames = list("h1", "h1"))
  expect_error(.check_incidence_phydist_alignment(inc, phy), "not in phydist")
})

test_that(".check_incidence_phydist_alignment passes when all hosts present", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  expect_invisible(.check_incidence_phydist_alignment(inc, phy))
})

test_that(".validate_geotax_inputs passes valid incidence and phydist", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  expect_invisible(.validate_geotax_inputs(inc, phy))
})

test_that(".validate_geotax_inputs rejects bad incidence", {
  phy <- make_simple_phydist()
  expect_error(.validate_geotax_inputs(matrix(1:4, 2), phy), "rownames")
})

test_that(".validate_geotax_inputs rejects misaligned inputs", {
  inc <- matrix(c(1, 0), nrow = 1, dimnames = list("p1", c("X", "Y")))
  phy <- make_simple_phydist()
  expect_error(.validate_geotax_inputs(inc, phy), "not in phydist")
})
