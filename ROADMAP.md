# geotax v2 Roadmap

## Phase 0 — Audit freeze and scope definition
- [x] Inventory all exported functions and classify each as keep, rename, merge, deprecate, or internalize.
- [x] Document current data assets, examples, and package workflows.
- [x] Record all likely breaking changes and compatibility risks.
- [x] Approve the target public API before code changes begin.

## Phase 1 — API cleanup and compatibility wrappers
- [x] Add new API functions: `prepare_taxonomic_tree()`, `prepare_incidence_matrix()`, `align_geotax_inputs()`, `fit_geotax_model()`, `bootstrap_geotax_model()`, `predict_geotax_probability()`, `extract_geotax_coefficients()`, `build_presence_absence_matrix()`, `make_null_raster_points()`, and `make_null_raster_polygons()`.
- [x] Keep old exported names as wrappers.
- [x] Add deprecation warnings to legacy functions.
- [x] Standardize naming and spelling across the package.
- [x] Update `NAMESPACE` exports to match the new API.

## Phase 2 — Input validation layer
- [x] Add internal validators for taxonomic tables, incidence tables, phylogenetic distance matrices, and spatial inputs.
- [x] Enforce required columns, valid data frame structure, minimum rank count, matrix alignment, and missing-value checks.
- [x] Standardize error messages across all public functions.
- [x] Ensure every exported function uses shared validation helpers.

## Phase 3 — Modeling core refactor
- [x] Separate model data construction from model fitting.
- [x] Replace duplicated regression logic in `get_log_reg_coefficients()` and `log_reg_coef()` with a single canonical workflow.
- [x] Implement `fit_geotax_model()` with a structured `geotax_model` object.
- [x] Implement `extract_geotax_coefficients()`.
- [x] Implement `predict_geotax_probability()`.
- [x] Implement `bootstrap_geotax_model()` with explicit `seed` support and reproducible sampling.
- [x] Document the bootstrap strategy and modeling assumptions.

## Phase 4 — Spatial/PAM module refactor
- [x] Implement `build_presence_absence_matrix()` as the main PAM interface.
- [x] Implement `make_null_raster_points()` and `make_null_raster_polygons()`.
- [x] Keep spatial logic conceptually aligned with `alrobles/pam` but independent in code.
- [x] Avoid introducing a hard dependency on the `pam` package.
- [x] Validate geometry, CRS, and resolution inputs robustly.

## Phase 5 — Documentation and user workflow
- [ ] Update the README to reflect the new API and v2 vision.
- [ ] Add a package vignette that walks from taxonomic table to model fit.
- [ ] Add a spatial workflow vignette if needed.
- [ ] Document assumptions, limitations, and deprecation path for legacy functions.
- [x] Add examples for each public function.

## Phase 6 — Tests and CI
- [x] Add tests for valid inputs, invalid inputs, duplicated rows, missing values, mismatched labels, and empty tables.
- [x] Add tests for bootstrap reproducibility and deprecated wrapper behavior.
- [ ] Add CI workflow for package checks.
- [x] Ensure all core workflows are covered by tests.

## Phase 7 — Cleanup and stabilization
- [ ] Move helper-only functions to internal files.
- [ ] Remove duplicate exports.
- [ ] Review and modernize dependencies where appropriate.
- [x] Polish object printing and summary methods.
- [ ] Prepare the package for the next release stage.

## Definition of done
- [x] The package has a small, understandable public API.
- [x] Inputs are validated consistently.
- [x] Modeling is reproducible.
- [x] Spatial utilities are optional and clearly separated.
- [x] Tests and documentation cover the core workflows.
- [x] Legacy users can migrate through wrappers and deprecation warnings.