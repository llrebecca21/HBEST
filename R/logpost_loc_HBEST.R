#' Function that calculates the conditional log posterior distribution of \eqn{\pmb{e}^{(r)}} from HBEST.
#'
#' @description
#' `logpost_loc_HBEST` calculates the conditional posterior distribution for HBEST
#'
#' @inheritParams gradient_modelB 
#' @param sumPsi 
#' @param br 
#' @param Psi 
#' @param y 
#' @param Sigma 
#' @param zetasquared_r 
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @export
#'
#' @examples
logpost_loc_HBEST = function(sumPsi, er, ab, Psi, y, Sigma_e){
  -crossprod(sumPsi, er) - sum(y / exp(Psi %*% (ab + er))) - sum(er^2/Sigma_e) / 2
}