#' Hessian function for conditional log posterior of \eqn{\pmb{e}^{(r)}}  from Model A
#'
#' @description
#' `hess_loc_HBEST_fast` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for model A.
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
hess_loc_HBEST_fast <- function(Psi, y, loc, glob, Sigma_loc, Psi_glob) {
  he = -crossprod(Psi, Psi * c(y / exp(Psi %*% loc +  Psi_glob)))
  diag(he) = diag(he) - 1/Sigma_loc
  return(he)
}
