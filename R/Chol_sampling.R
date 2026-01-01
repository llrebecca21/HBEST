#' @title Perform Cholesky Sampling (internal)
#' 
#' @description
#' This function performs Cholesky Sampling given the Cholesky decomposition and the centers of the beta coefficients.
#' 
#' @param Lt A `(d x d)` Upper triangular matrix from Cholesky decomposition.
#' @param d  A numeric strictly positive value denoting the length of beta.
#' @param beta_c A vector of length `d` of center beta values.
#'
#' @return a vector of proposed beta values
#' @noRd
chol_sampling <- function(Lt, d, beta_c) {
  u <- solve(Lt, stats::rnorm(n = d))
  beta_prop <- beta_c + u
  return(beta_prop)
}
