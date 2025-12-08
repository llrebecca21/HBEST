#' Conditional Posterior of Beta coefficients
#'
#' @param ab  A `(B+1)` column vector of intercept and basis function coefficient values.
#' @param X  A basis vector matrix.
#' @param sumX A vector of the column sums of the `X` matrix.
#' @param tsq  A tau squared scalar.
#' @param perio A vector of the log of the periodogram.
#' @param sigmasalpha A prior intercept variance, variance associated with the alpha_0 prior
#' @param D A vector of length B with strictly positive entries.
#'
#' @return A scalar of the value of the conditional posterior at the given value
#'
whittle_post <- function(ab, X, sumX, tsq, perio, sigmasalpha, D) {
  # extract the intercept term
  a <- ab[1]
  # extract the beta coefficients
  b <- ab[-1]
  # calculate the conditional posterior of beta
  return(-1 / 2 * (sum(b * b / D) / tsq + a^2 / sigmasalpha + nrow(X) * a + crossprod(sumX, b) +
    sum(exp(perio - a - X %*% b))))
}