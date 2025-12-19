#' Calculate the gradient of the conditional log posterior distribution of \eqn{\pmb{a}} from HBEST.
#' 
#' @description
#' `grad_glob_HBEST` function calculates the conditional posterior for the `r`th \eqn{\beta} coefficients under HBEST.
#' 
#' @param sumPsi  ((B+1) x R) The `r`th column of the column sum across `Psi`.
#' @param Psi_list 
#' @param y_list 
#' @param R 
#' @param loc 
#' @param glob 
#' @param Sigma_glob 
#'
#' @return A vector containing the gradient for the conditional posterior of \eqn{\beta}.
#' @noRd
grad_glob_HBEST <- function(loc, glob, sumPsi, Psi_list, y_list, Sigma_glob, R) {
  k = -rowSums(sumPsi) - (glob / Sigma_glob) 
  for(r in 1:R){
    k = k + colSums(Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (glob + loc[,r]))))
  }
  return(k)
}