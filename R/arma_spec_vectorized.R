#' A vectorized version of [bayestime::arma_spec()]
#'
#' @description
#' Gives the spectral density across a given set of omegas for a known ARMA process.
#' This function is vectorized for faster computation.
#'
#' @inheritParams arma_spec
#'
#' @return A vector as long as the `omega` vector containing the calculated spectral density.
#' @export
#'
#' @examples
#' omega <- seq(0, pi, length.out = 1000)
#' phi <- 0.5
#' arma_spec_vectorized(omega = omega, phi = phi)
#' ## output is a vector of length 1000
#'
arma_spec_vectorized <- function(omega, phi = 0, theta = 0) {
  E <- outer(
    omega,
    1:max(length(phi), length(theta)),
    FUN = function(x, y) {
      exp(1i * x * y)
    }
  )
  c((Mod(1 + E[, 1:length(theta), drop = FALSE] %*% theta) / Mod(1 - E[, 1:length(phi), drop = FALSE] %*% phi))^
    2)
}
