#' Hessian function for conditional log posterior of \eqn{\pmb{a}} from Model A
#'
#' @param Psi_list 
#' @param y_list 
#' @param ebr 
#' @param ab 
#' @param Sigma_e 
#' @param R 
#'
#' @description
#' `hea_modelA` calculates the hessian of the conditional posterior of the `r`th \eqn{beta} for model A.
#'
#'
#' @return
#'
#' @examples
hea_modelA_fast <- function( ab, Psi_list, y_list, ebr, Sigma_a, R, Psi_ebr_list) {
  ha = diag(-1/Sigma_a)
  for(r in 1:R){
    # ha = ha - crossprod(Psi_list[[r]], Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (ebr[,r] + ab))))
    ha = ha - crossprod(Psi_list[[r]], Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% ab + Psi_ebr_list[[r]])))
  }
  return(ha)
}
