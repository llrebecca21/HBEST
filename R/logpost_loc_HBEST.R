#' Function that calculates the conditional log posterior distribution of \eqn{\pmb{\beta}_{(r)}} from HBEST.
#'
#' @description
#' `logpost_loc_HBEST` calculates the conditional posterior distribution for HBEST
#'
#' @param sumPsi 
#' @param Psi 
#' @param loc 
#' @param glob 
#' @param Sigma_loc 
#' @param y 
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @export
#'
#' @examples
logpost_loc_HBEST = function(sumPsi, loc, glob, Psi, y, Sigma_loc){
  -crossprod(sumPsi, loc) - sum(y / exp(Psi %*% (glob + loc))) - sum(loc^2/Sigma_loc) / 2
}