#' Hessian function for conditional log posterior of \eqn{\pmb{glob}} from HBEST
#'
#' @param Psi_list 
#' @param y_list 
#' @param R 
#' @param glob 
#' @param loc 
#' @param Sigma_glob 
#' @param Psi_loc_list 
#'
#' @description
#' `hess_glob_HBEST_fast` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for model A.
#'
#' @return
#' @noRd
hess_glob_HBEST_fast <- function(glob, Psi_list, y_list, loc, Sigma_glob, R, Psi_loc_list) {
  ha = diag(-1/Sigma_glob)
  for(r in 1:R){
    # ha = ha - crossprod(Psi_list[[r]], Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (ebr[,r] + ab))))
    ha = ha - crossprod(Psi_list[[r]], Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% glob + Psi_loc_list[[r]])))
  }
  return(ha)
}
