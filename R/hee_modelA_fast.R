#' Hessian function for conditional log posterior of \eqn{\pmb{e}^{(r)}}  from Model A
#'
#' @description
#' `hee_modelA_fast` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for model A.
#'
#'
#' @inheritParams gradiente_modelA
#' @param Psi
#' @param y
#' @param br
#' @param Sigma
#' @param zetasquared_r
#'
#' @return
#' @noRd
hee_modelA_fast <- function(Psi, y, er, ab, Sigma_e, Psi_ab) {
  he = -crossprod(Psi, Psi * c(y / exp(Psi %*% er +  Psi_ab)))
  diag(he) = diag(he) - 1/Sigma_e
  return(he)
}
