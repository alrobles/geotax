make_interactions <- function() {
  data.frame(
    parasite = c("pA 1", "pA 1", "pA 2", "pB 1", "pB 1", "pB 2"),
    host = c("host1", "host2", "host1", "host2", "host3", "host3"),
    genus = c("pA", "pA", "pA", "pB", "pB", "pB"),
    stringsAsFactors = FALSE
  )
}

test_that("prepare_pair_data builds all focal pairs", {
  pairs <- prepare_pair_data(make_interactions(), make_simple_phydist())
  expect_s3_class(pairs, "geotax_pairs")
  expect_named(pairs, c("parasite", "focal", "target", "phydist", "suscept"))
  # pA 1 has hosts host1, host2: 2 focals x 2 targets each = 4 rows
  expect_equal(sum(pairs$parasite == "pA 1"), 4)
  # single-host parasites contribute 1 focal x 2 targets
  expect_equal(sum(pairs$parasite == "pA 2"), 2)
  expect_true(all(pairs$suscept %in% c(0, 1)))
  # a known co-host pair is susceptible
  row <- pairs[pairs$parasite == "pA 1" & pairs$focal == "host1" &
                 pairs$target == "host2", ]
  expect_equal(row$suscept, 1)
  expect_equal(row$phydist, 1)
})

test_that("prepare_pair_data is deterministic", {
  p1 <- prepare_pair_data(make_interactions(), make_simple_phydist())
  p2 <- prepare_pair_data(make_interactions(), make_simple_phydist())
  expect_identical(p1, p2)
})

test_that("prepare_pair_data supports group column and function", {
  pairs <- prepare_pair_data(make_interactions(), make_simple_phydist(),
                             group = "genus")
  expect_true("group" %in% colnames(pairs))
  expect_setequal(unique(pairs$group), c("pA", "pB"))

  pairs_f <- prepare_pair_data(make_interactions(), make_simple_phydist(),
                               group = function(x) sub(" .*", "", x))
  expect_equal(pairs$group, pairs_f$group)
})

test_that("prepare_pair_data validates inputs", {
  expect_error(prepare_pair_data(list(), make_simple_phydist()),
               "must be a data.frame")
  expect_error(prepare_pair_data(make_interactions()[, 1, drop = FALSE],
                                 make_simple_phydist()),
               "at least two columns")
  bad <- make_interactions()
  bad$host <- paste0("missing_", bad$host)
  expect_error(prepare_pair_data(bad, make_simple_phydist()),
               "No hosts")
  expect_error(prepare_pair_data(make_interactions(), make_simple_phydist(),
                                 group = "nope"),
               "not found")
  partial <- make_interactions()
  partial$host[1] <- "missing_host"
  expect_warning(prepare_pair_data(partial, make_simple_phydist()),
                 "dropped")
})

test_that("cluster_bootstrap_geotax is reproducible and shaped correctly", {
  pairs <- prepare_pair_data(make_interactions(), make_simple_phydist())
  b1 <- cluster_bootstrap_geotax(pairs, n_boot = 10, seed = 7)
  b2 <- cluster_bootstrap_geotax(pairs, n_boot = 10, seed = 7)
  expect_identical(b1$draws, b2$draws)
  expect_equal(nrow(b1$draws), 10)
  expect_true(all(c("(Intercept)", "phydist") %in% colnames(b1$draws)))
  expect_s3_class(b1, "geotax_cluster_bootstrap")
  expect_output(print(b1), "cluster bootstrap")
})

test_that("compare_geotax_slopes returns slopes per group", {
  pairs <- prepare_pair_data(make_interactions(), make_simple_phydist(),
                             group = "genus")
  cmp <- compare_geotax_slopes(pairs, n_boot = 10, seed = 7)
  expect_s3_class(cmp, "geotax_slope_comparison")
  expect_equal(cmp$groups, c("pA", "pB"))
  expect_named(cmp$slopes, c("pA", "pB"))
  expect_equal(unname(cmp$slopes[2] - cmp$slopes[1]), cmp$slope_difference,
               tolerance = 1e-8)
  expect_equal(rownames(cmp$slope_cis), c("pA", "pB", "difference"))
  expect_output(print(cmp), "slope comparison")
})

test_that("compare_geotax_slopes validates group structure", {
  pairs <- prepare_pair_data(make_interactions(), make_simple_phydist())
  expect_error(compare_geotax_slopes(pairs), "group")
  pairs1 <- prepare_pair_data(make_interactions(), make_simple_phydist(),
                              group = function(x) "same")
  expect_error(compare_geotax_slopes(pairs1), "exactly two")
})
