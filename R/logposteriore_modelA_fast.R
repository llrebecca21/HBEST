#' Function that calculates the conditional log posterior distribution of \eqn{\pmb{e}^{(r)}} from Model A.
#'
#' @description
#' `logposteriore_modelA` calculates the conditional posterior distribution for model B
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
logposteriore_modelA_fast = function(sumPsi, er, Psi, y, Sigma_e, Psi_ab){
  # -crossprod(sumPsi, er) - sum(y / exp(Psi %*% (ab + er))) - sum(er^2/Sigma_e) / 2
  -crossprod(sumPsi, er) - sum(y / exp(Psi_ab + Psi %*% er)) - sum(er^2/Sigma_e) / 2
}