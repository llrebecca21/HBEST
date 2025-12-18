#' Hessian function for conditional log posterior of \eqn{\pmb{e}^{(r)}}  from Model A
#'
#' @description
#' `hess_loc_HBEST_fast` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for model A.
#'
#' 
#' @param Psi
#' @param loc 
#' @param glob 
#' @param Sigma_loc 
#' @param Psi_glob 
#' @param y
#'
#' @return
#' @noRd
hess_loc_HBEST_fast <- function(Psi, y, loc, glob, Sigma_loc, Psi_glob) {
  he = -crossprod(Psi, Psi * c(y / exp(Psi %*% loc +  Psi_glob)))
  diag(he) = diag(he) - 1/Sigma_loc
  return(he)
}
