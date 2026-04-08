# Internal validation helpers - not exported

.validate_tax_table <- function(tax_table) {
  if (!inherits(tax_table, "data.frame")) {
    stop("'tax_table' must be a data.frame.")
  }
  fullNames <- c("class", "order", "family", "genus", "species")
  matchNames <- match(colnames(tax_table), fullNames)
  matchNames <- matchNames[!is.na(matchNames)]
  if (length(matchNames) < 3) {
    stop("'tax_table' must have at least 3 columns matching: class, order, family, genus, species.")
  }
  if (nrow(unique(tax_table)) < 2) {
    stop("'tax_table' must have at least 2 unique rows.")
  }
  invisible(NULL)
}

.validate_incidence <- function(incidence) {
  if (!is.matrix(incidence) && !is.data.frame(incidence)) {
    stop("'incidence' must be a matrix or data.frame.")
  }
  if (is.null(rownames(incidence)) || is.null(colnames(incidence))) {
    stop("'incidence' must have both rownames and colnames.")
  }
  vals <- as.numeric(as.matrix(incidence))
  if (!all(vals %in% c(0, 1, NA))) {
    stop("'incidence' must be a binary (0/1) matrix.")
  }
  if (any(apply(incidence, 1, function(r) all(is.na(r))))) {
    stop("'incidence' must not contain all-NA rows.")
  }
  invisible(NULL)
}

.validate_phydist <- function(phydist) {
  if (!is.matrix(phydist)) {
    stop("'phydist' must be a matrix.")
  }
  if (nrow(phydist) != ncol(phydist)) {
    stop("'phydist' must be a square matrix.")
  }
  if (!identical(rownames(phydist), colnames(phydist))) {
    stop("'phydist' rownames must equal colnames.")
  }
  if (!is.numeric(phydist)) {
    stop("'phydist' must be numeric.")
  }
  if (!all(diag(phydist) == 0)) {
    stop("'phydist' diagonal should be 0.")
  }
  invisible(NULL)
}

.validate_spatial_inputs <- function(shp, points = NULL, res = NULL) {
  if (is.null(shp)) {
    stop("'shp' must be provided.")
  }
  if (!is.null(points)) {
    if (ncol(points) != 3) {
      stop("'points' must have exactly 3 columns (species, longitude, latitude).")
    }
  }
  if (!is.null(res)) {
    if (!is.numeric(res) || any(res <= 0)) {
      stop("'res' must be a positive numeric value.")
    }
  }
  invisible(NULL)
}

.check_incidence_phydist_alignment <- function(incidence, phydist) {
  inc_cols <- colnames(incidence)
  phy_names <- colnames(phydist)
  missing <- setdiff(inc_cols, phy_names)
  if (length(missing) > 0) {
    stop(paste0("The following incidence columns are not in phydist: ",
                paste(missing, collapse = ", ")))
  }
  invisible(NULL)
}
