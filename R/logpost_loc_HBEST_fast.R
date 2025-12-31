#' Function that calculates the conditional log posterior distribution of \eqn{\pmb{e}^{(r)}} from Model A.
#'
#' @description
#' `logpost_loc_HBEST_fast` calculates the conditional posterior distribution for model B
#'
#' @param sumPsi The `r`th column of the column sum across `Psi`.
#' @param Psi The `r`th `Psi` matrix.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param Sigma_loc The current \eqn{\Sigma^{loc}}.
#' @param y The `r`th periodogram sub-setted for the Fourier frequencies for the `r`th time series.
#' @param Psi_glob A list of length `R`; each element is the pre-computed \eqn{\Psi \beta^{glob}}.
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @noRd
logpost_loc_HBEST_fast = function(sumPsi, loc, Psi, y, Sigma_loc, Psi_glob){
  -crossprod(sumPsi, loc) - sum(y / exp(Psi_glob + Psi %*% loc)) - sum(loc^2/Sigma_loc) / 2
}