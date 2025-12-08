#' Calculate the spectral density for a known ARMA process
#'
#' @description
#' Gives the spectral density across a given set of omegas for a known ARMA process.
#'
#'
#' @param omega  A vector containing a set of frequencies the spectral density is to be calculated over.
#' @param phi The vector of AR coefficient(s).
#' @param theta The vector of MA coefficient(s).
#'
#' @return A vector as long as the `omega` vector containing the calculated spectral density
#' @export
#'
#' @examples
#' omega <- seq(0, pi, length.out = 1000)
#' phi <- 0.5
#' arma_spec(omega = omega, phi = phi)
#' ## output is a vector of length 1000
#'
arma_spec <- function(omega, phi = 0, theta = 0) {
  # create a vector to store the spectral density calculation
  s <- rep(NA, length(omega))
  for (i in 1:length(s)) {
    z <- exp(-1i * omega[i])
    s[i] <- Mod(1 + crossprod(theta, z^(1:length(theta))))^2 /
      Mod(1 - crossprod(phi, z^(1:length(phi))))^2
  }
  return(s)
}