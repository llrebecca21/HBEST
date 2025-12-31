#' Hessian function for conditional log posterior of \eqn{\pmb{\beta}^{glob}} from HBEST. (internal)
#'
#'#' @description
#' `hess_glob_HBEST_fast` calculates the hessian of the conditional posterior of \eqn{\pmb{\beta}^{glob}} for HBEST.
#'
#' @param Psi_list A list of length `R` which stores the `Psi` matrix.
#' @param y_list An `R` list of column matrices each storing a truncated/half periodogram.
#' @param R A scalar indicating the number of conditionally independent time series.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param Sigma_glob The current \eqn{\Sigma^{glob}}.
#' @param Psi_loc_list A list of length `R`; each element is the pre-computed \eqn{\Psi_r \beta^{loc}_r}
#'
#' @return A vector containing the hessian for the conditional posterior of \eqn{\pmb{beta}^{glob}}.
#' @noRd
hess_glob_HBEST_fast <- function(glob, Psi_list, y_list, loc, Sigma_glob, R, Psi_loc_list) {
  ha = diag(-1/Sigma_glob)
  for(r in 1:R){
    ha = ha - crossprod(Psi_list[[r]], Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% glob + Psi_loc_list[[r]])))
  }
  return(ha)
}
