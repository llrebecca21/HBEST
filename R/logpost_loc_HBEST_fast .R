#' Function that calculates the conditional log posterior distribution of \eqn{\pmb{e}^{(r)}} from Model A.
#'
#' @description
#' `logpost_loc_HBEST_fast` calculates the conditional posterior distribution for model B
#'
#' @param sumPsi 
#' @param br 
#' @param Psi 
#' @param y 
#' @param Sigma 
#' @param zetasquared_r 
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @noRd
logpost_loc_HBEST_fast = function(sumPsi, loc, Psi, y, Sigma_loc, Psi_glob){
  -crossprod(sumPsi, loc) - sum(y / exp(Psi_glob + Psi %*% loc)) - sum(loc^2/Sigma_loc) / 2
}