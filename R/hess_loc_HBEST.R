#' Hessian function for conditional log posterior of \eqn{\pmb{beta}_{(r)}}  from HBESt
#'
#' @description
#' `hess_loc_HBEST` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for HBEST.
#'
#'
#' @param Psi The `r`th `Psi` matrix.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param Sigma_loc The current \eqn{\Sigma^{loc}}.
#' @param y The `r`th periodogram sub-setted for the Fourier frequencies for the `r`th time series.
#'
#' @return A vector containing the hessian for the conditional posterior of \eqn{\pmb{beta}^{loc}}.
#' @noRd
hess_loc_HBEST <- function(Psi, y, loc, glob, Sigma_loc) {
  he = -crossprod(Psi, Psi * c(y / exp(Psi %*% (loc + glob))))
  diag(he) = diag(he) - 1/Sigma_loc
  return(he)
}
