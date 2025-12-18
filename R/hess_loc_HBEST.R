#' Hessian function for conditional log posterior of \eqn{\pmb{e}^{(r)}}  from Model A
#'
#' @description
#' `hess_loc_HBEST` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for model A.
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
#' @export
#'
#' @examples
hess_loc_HBEST <- function(Psi, y, er, ab, Sigma_e) {
  he = -crossprod(Psi, Psi * c(y / exp(Psi %*% (er + ab))))
  diag(he) = diag(he) - 1/Sigma_e
  return(he)
}
