test_that("fit_geotax_model returns a geotax_model object", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  model <- fit_geotax_model(inc, phy, seed = 1)
  expect_s3_class(model, "geotax_model")
})

test_that("fit_geotax_model has correct structure", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  model <- fit_geotax_model(inc, phy, seed = 1)
  expect_named(model$coefficients, c("intercept", "slope"))
  expect_named(model$standard_errors, c("intercept", "slope"))
  expect_equal(dim(model$confidence_intervals), c(2, 2))
  expect_true(is.logical(model$convergence))
  expect_equal(model$metadata$n_hosts, 3L)
  expect_equal(model$metadata$n_parasites, 2L)
})

test_that("fit_geotax_model is reproducible with seed", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  m1 <- fit_geotax_model(inc, phy, seed = 99)
  m2 <- fit_geotax_model(inc, phy, seed = 99)
  expect_equal(m1$coefficients, m2$coefficients)
})

test_that("fit_geotax_model rejects bad incidence", {
  phy <- make_simple_phydist()
  expect_error(fit_geotax_model(matrix(1:4, 2), phy), "rownames")
})

test_that("fit_geotax_model rejects incidence not aligned with phydist", {
  inc <- matrix(c(1, 0), nrow = 1, dimnames = list("p1", c("X", "Y")))
  phy <- make_simple_phydist()
  expect_error(fit_geotax_model(inc, phy), "not in phydist")
})

test_that("print.geotax_model produces output", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  model <- fit_geotax_model(inc, phy, seed = 1)
  expect_output(print(model), "Geotax model")
})

test_that("bootstrap_geotax_model returns geotax_bootstrap", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  bs <- bootstrap_geotax_model(inc, phy, n = 3, seed = 42)
  expect_s3_class(bs, "geotax_bootstrap")
  expect_equal(bs$n, 3L)
  expect_equal(nrow(bs$coefficients), 3L)
  expect_equal(ncol(bs$coefficients), 12L)
})

test_that("bootstrap_geotax_model summary has correct columns", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  bs <- bootstrap_geotax_model(inc, phy, n = 3, seed = 42)
  expect_true("intercept" %in% names(bs$summary))
  expect_true("slope" %in% names(bs$summary))
})

test_that("predict_geotax_probability returns probabilities in [0,1]", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  model <- fit_geotax_model(inc, phy, seed = 1)
  probs <- predict_geotax_probability(model, c(0, 1, 2))
  expect_true(all(probs >= 0 & probs <= 1))
  expect_length(probs, 3)
})

test_that("predict_geotax_probability works with named coef vector", {
  coef_vec <- c(intercept = 1.0, slope = -0.5)
  probs <- predict_geotax_probability(coef_vec, c(0, 2, 4))
  expect_length(probs, 3)
  expect_true(all(probs >= 0 & probs <= 1))
})

test_that("predict_geotax_probability works with unnamed coef vector", {
  probs <- predict_geotax_probability(c(1.0, -0.5), c(0, 1, 2))
  expect_length(probs, 3)
})

test_that("predict_geotax_probability works with geotax_bootstrap", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  bs <- bootstrap_geotax_model(inc, phy, n = 3, seed = 42)
  probs <- predict_geotax_probability(bs, c(0, 1, 2))
  expect_length(probs, 3)
})

test_that("extract_geotax_coefficients works with geotax_model", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  model <- fit_geotax_model(inc, phy, seed = 1)
  clist <- extract_geotax_coefficients(model)
  expect_named(clist, c("intercept", "slope", "intercept_se", "slope_se",
                        "intercept_ci", "slope_ci"))
})

test_that("extract_geotax_coefficients works with geotax_bootstrap", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  bs <- bootstrap_geotax_model(inc, phy, n = 3, seed = 42)
  clist <- extract_geotax_coefficients(bs)
  expect_named(clist, c("intercept", "slope", "intercept_se", "slope_se",
                        "intercept_ci", "slope_ci"))
})

test_that("bootstrap_geotax_model is reproducible with seed", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  bs1 <- bootstrap_geotax_model(inc, phy, n = 5, seed = 7)
  bs2 <- bootstrap_geotax_model(inc, phy, n = 5, seed = 7)
  expect_equal(bs1$coefficients, bs2$coefficients)
  expect_equal(bs1$summary, bs2$summary)
})

test_that("bootstrap_geotax_model produces different results with different seeds", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  bs1 <- bootstrap_geotax_model(inc, phy, n = 5, seed = 1)
  bs2 <- bootstrap_geotax_model(inc, phy, n = 5, seed = 2)
  # Coefficients should differ across seeds (with overwhelming probability)
  expect_false(identical(bs1$coefficients, bs2$coefficients))
})

test_that("print.geotax_bootstrap produces output", {
  inc <- make_simple_incidence()
  phy <- make_simple_phydist()
  bs <- bootstrap_geotax_model(inc, phy, n = 3, seed = 42)
  expect_output(print(bs), "Geotax bootstrap")
})

test_that("predict_geotax_probability rejects bad coef", {
  expect_error(predict_geotax_probability("not_numeric", c(0, 1)), "'coef' must be a numeric vector")
})

test_that("predict_geotax_probability rejects non-numeric dist", {
  expect_error(predict_geotax_probability(c(1.0, -0.5), "bad"), "'dist' must be a numeric vector")
})

test_that("extract_geotax_coefficients rejects unsupported object", {
  expect_error(extract_geotax_coefficients(list()), "geotax_model or geotax_bootstrap")
})
