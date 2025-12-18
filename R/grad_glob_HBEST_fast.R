#' Calculate the gradient of the conditional log posterior distribution of \eqn{\pmb{a}} from Model A.
#' 
#' @description
#' `grad_glob_HBEST_fast` function calculates the conditional posterior for the `r`th \eqn{\beta} coefficients under Model B.
#' 
#' @param sumPsi  ((B+1) x R) The `r`th column of the column sum across `Psi`.
#' @param Psi_list 
#' @param y_list 
#' @param R 
#' @param glob 
#' @param Sigma_glob 
#' @param sumsumPsi 
#' @param Psi_loc_list 
#'
#' @return A vector containing the gradient for the conditional posterior of \eqn{\beta}.
#'
grad_glob_HBEST_fast <- function(glob, sumPsi, Psi_list, y_list, Sigma_glob, R, sumsumPsi, Psi_loc_list) {
  k = -sumsumPsi - (glob / Sigma_glob) 
  for(r in 1:R){
    k = k + colSums(Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% glob + Psi_loc_list[[r]])))
  }
  return(k)
}