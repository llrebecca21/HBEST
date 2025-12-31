#' Hessian function for conditional log posterior of \eqn{\pmb{\beta}^{loc}} from HBEST
#'
#' @description
#' `hess_loc_HBEST_fast` calculates the hessian of the conditional posterior of the `r`th \eqn{\pmb{\beta}^{loc}} for HBEST.
#'
#' @param Psi The `r`th `Psi` matrix.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param Sigma_loc The current \eqn{\Sigma^{loc}}.
#' @param y The `r`th periodogram sub-setted for the Fourier frequencies for the `r`th time series.
#' @param Psi_glob A list of length `R`; each element is the pre-computed
#'  \eqn{\Psi_r \beta^{loc}_r}.
#'
#' @return A vector containing the hessian for the conditional posterior of \eqn{\pmb{beta}^{loc}}.
#' @noRd
hess_loc_HBEST_fast <- function(Psi, y, loc, glob, Sigma_loc, Psi_glob) {
  he = -crossprod(Psi, Psi * c(y / exp(Psi %*% loc +  Psi_glob)))
  diag(he) = diag(he) - 1/Sigma_loc
  return(he)
}
