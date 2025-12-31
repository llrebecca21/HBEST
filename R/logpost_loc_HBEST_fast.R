#' Function that calculates the conditional log posterior distribution of \eqn{\pmb{e}^{(r)}} from Model A.
#'
#' @description
#' `logpost_loc_HBEST_fast` calculates the conditional posterior distribution for model B
#'
#' @param sumPsi 
#' @param Psi 
#' @param loc 
#' @param Sigma_loc 
#' @param Psi_glob 
#' @param y 
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @noRd
logpost_loc_HBEST_fast = function(sumPsi, loc, Psi, y, Sigma_loc, Psi_glob){
  -crossprod(sumPsi, loc) - sum(y / exp(Psi_glob + Psi %*% loc)) - sum(loc^2/Sigma_loc) / 2
}