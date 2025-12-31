#' Hessian function for conditional log posterior of \eqn{\pmb{\beta}^{glob}} from HBEST
#'
#' @description
#' `hess_glob_HBEST` calculates the hessian of the conditional posterior of \eqn{\pmb{beta}^{glob}} under HBEST.
#'
#' @param Psi_list A list of length `R` which stores the `Psi` matrix.
#' @param y_list An `R` list of column matrices each storing a truncated/half periodogram.
#' @param R A scalar indicating the number of conditionally independent time series.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param Sigma_glob The current \eqn{\Sigma^{glob}}.
#'
#' @return A vector containing the hessian for the conditional posterior of \eqn{\pmb{beta}^{glob}}.
#' @noRd
hess_glob_HBEST <- function(glob, Psi_list, y_list, loc, Sigma_glob, R) {
  ha = diag(-1/Sigma_glob)
  for(r in 1:R){
    ha = ha - crossprod(Psi_list[[r]], Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (loc[,r] + glob))))
  }
  return(ha)
}
