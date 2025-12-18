#' Hessian function for conditional log posterior of \eqn{\pmb{beta}_{(r)}}  from HBESt
#'
#' @description
#' `hess_loc_HBEST` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for HBEST.
#'
#'
#' @param Psi
#' @param loc 
#' @param glob 
#' @param Sigma_loc 
#' @param y
#'
#' @return
#' @noRd
hess_loc_HBEST <- function(Psi, y, loc, glob, Sigma_loc) {
  he = -crossprod(Psi, Psi * c(y / exp(Psi %*% (loc + glob))))
  diag(he) = diag(he) - 1/Sigma_loc
  return(he)
}
