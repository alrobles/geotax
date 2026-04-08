test_that("get_taxonomical_tree emits deprecation warning", {
  skip_if_not_installed("ape")
  df <- data.frame(
    class  = c("A", "A", "B"),
    order  = c("C", "C", "D"),
    family = c("E", "F", "G")
  )
  expect_warning(get_taxonomical_tree(df), "prepare_taxonomic_tree")
})

test_that("get_incidence_matrix emits deprecation warning", {
  db <- data.frame(host = c("h1","h1","h2"), parasite = c("p1","p2","p1"))
  expect_warning(get_incidence_matrix(db), "prepare_incidence_matrix")
})

test_that("get_incidence_matrix still returns a matrix", {
  db <- data.frame(host = c("h1","h1","h2"), parasite = c("p1","p2","p1"))
  suppressWarnings({
    result <- get_incidence_matrix(db)
  })
  expect_true(is.matrix(result))
})

test_that("get_log_reg_coefficients emits deprecation warning", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  expect_warning(get_log_reg_coefficients(inc, phy), "fit_geotax_model")
})

test_that("get_log_reg_coefficients still returns expected columns", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  suppressWarnings({
    result <- get_log_reg_coefficients(inc, phy)
  })
  expect_true(is.data.frame(result))
  expect_true("intercept" %in% colnames(result))
  expect_true("slope" %in% colnames(result))
})

test_that("log_reg_coef emits deprecation warning", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  expect_warning(log_reg_coef(inc, phy), "fit_geotax_model")
})

test_that("log_reg_boostrap emits deprecation warning", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  expect_warning(log_reg_boostrap(inc, phy, 3), "bootstrap_geotax_model")
})

test_that("log_reg_boostrap still returns a named vector", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  suppressWarnings({
    result <- log_reg_boostrap(inc, phy, 3)
  })
  expect_true(is.numeric(result))
  expect_true("intercept" %in% names(result))
  expect_true("slope" %in% names(result))
})

test_that("prob_logit emits deprecation warning", {
  expect_warning(prob_logit(c(1, -0.5), c(0, 1, 2)), "predict_geotax_probability")
})

test_that("prob_logit still returns probabilities", {
  suppressWarnings({
    result <- prob_logit(c(1, -0.5), c(0, 1, 2))
  })
  expect_length(result, 3)
  expect_true(all(result >= 0 & result <= 1))
})
