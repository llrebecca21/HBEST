#' Function that calculates the conditional log posterior distribution of \eqn{\pmb{\beta}_{(r)}} from HBEST.
#'
#' @description
#' `logpost_loc_HBEST` calculates the conditional posterior distribution for HBEST
#'
#' @param sumPsi The `r`th column of the column sum across `Psi`.
#' @param Psi The `r`th `Psi` matrix.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param Sigma_loc The current \eqn{\Sigma^{loc}}.
#' @param y The `r`th periodogram sub-setted for the Fourier frequencies for the `r`th time series.
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @noRd
logpost_loc_HBEST = function(sumPsi, loc, glob, Psi, y, Sigma_loc){
  -crossprod(sumPsi, loc) - sum(y / exp(Psi %*% (glob + loc))) - sum(loc^2/Sigma_loc) / 2
}