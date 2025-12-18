#' Hessian function for conditional log posterior of \eqn{\pmb{a}} from Model A
#'
#'
#' @param Psi_list 
#' @param y_list 
#' @param R 
#' @param glob 
#' @param loc 
#' @param Sigma_glob 
#'
#' @description
#' `hess_glob_HBEST` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for model A.
#'
#'
#' @return
#'
#' @examples
hess_glob_HBEST <- function(glob, Psi_list, y_list, loc, Sigma_glob, R) {
  ha = diag(-1/Sigma_glob)
  for(r in 1:R){
    ha = ha - crossprod(Psi_list[[r]], Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (loc[,r] + glob))))
  }
  return(ha)
}
