# geotax v2 Roadmap

## Phase 0 — Audit freeze and scope definition
- [ ] Inventory all exported functions and classify each as keep, rename, merge, deprecate, or internalize.
- [ ] Document current data assets, examples, and package workflows.
- [ ] Record all likely breaking changes and compatibility risks.
- [ ] Approve the target public API before code changes begin.

## Phase 1 — API cleanup and compatibility wrappers
- [ ] Add new API functions: `prepare_taxonomic_tree()`, `prepare_incidence_matrix()`, `align_geotax_inputs()`, `validate_geotax_inputs()`, `fit_geotax_model()`, `bootstrap_geotax_model()`, `predict_geotax_probability()`, `extract_geotax_coefficients()`, `summarize_geotax_model()`, `build_presence_absence_matrix()`, `make_null_raster_points()`, and `make_null_raster_polygons()`.
- [ ] Keep old exported names as wrappers.
- [ ] Add deprecation warnings to legacy functions.
- [ ] Standardize naming and spelling across the package.
- [ ] Update `NAMESPACE` exports to match the new API.

## Phase 2 — Input validation layer
- [ ] Add internal validators for taxonomic tables, incidence tables, phylogenetic distance matrices, and spatial inputs.
- [ ] Enforce required columns, valid data frame structure, minimum rank count, matrix alignment, and missing-value checks.
- [ ] Standardize error messages across all public functions.
- [ ] Ensure every exported function uses shared validation helpers.

## Phase 3 — Modeling core refactor
- [ ] Separate model data construction from model fitting.
- [ ] Replace duplicated regression logic in `get_log_reg_coefficients()` and `log_reg_coef()` with a single canonical workflow.
- [ ] Implement `fit_geotax_model()` with a structured `geotax_model` object.
- [ ] Implement `extract_geotax_coefficients()`.
- [ ] Implement `predict_geotax_probability()`. 
- [ ] Implement `bootstrap_geotax_model()` with explicit `seed` support and reproducible sampling.
- [ ] Document the bootstrap strategy and modeling assumptions.

## Phase 4 — Spatial/PAM module refactor
- [ ] Implement `build_presence_absence_matrix()` as the main PAM interface.
- [ ] Implement `make_null_raster_points()` and `make_null_raster_polygons()`.
- [ ] Keep spatial logic conceptually aligned with `alrobles/pam` but independent in code.
- [ ] Avoid introducing a hard dependency on the `pam` package.
- [ ] Validate geometry, CRS, and resolution inputs robustly.

## Phase 5 — Documentation and user workflow
- [ ] Update the README to reflect the new API and v2 vision.
- [ ] Add a package vignette that walks from taxonomic table to model fit.
- [ ] Add a spatial workflow vignette if needed.
- [ ] Document assumptions, limitations, and deprecation path for legacy functions.
- [ ] Add examples for each public function.

## Phase 6 — Tests and CI
- [ ] Add tests for valid inputs, invalid inputs, duplicated rows, missing values, mismatched labels, and empty tables.
- [ ] Add tests for bootstrap reproducibility and deprecated wrapper behavior.
- [ ] Add CI workflow for package checks.
- [ ] Ensure all core workflows are covered by tests.

## Phase 7 — Cleanup and stabilization
- [ ] Move helper-only functions to internal files.
- [ ] Remove duplicate exports.
- [ ] Review and modernize dependencies where appropriate.
- [ ] Polish object printing and summary methods.
- [ ] Prepare the package for the next release stage.

## Definition of done
- [ ] The package has a small, understandable public API.
- [ ] Inputs are validated consistently.
- [ ] Modeling is reproducible.
- [ ] Spatial utilities are optional and clearly separated.
- [ ] Tests and documentation cover the core workflows.
- [ ] Legacy users can migrate through wrappers and deprecation warnings.