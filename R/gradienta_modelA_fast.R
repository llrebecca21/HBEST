#' Calculate the gradient of the conditional log posterior distribution of \eqn{\pmb{a}} from Model A.
#' 
#' @description
#' `gradienta_modelA_fast` function calculates the conditional posterior for the `r`th \eqn{\beta} coefficients under Model B.
#' 
#' @param sumPsi  ((B+1) x R) The `r`th column of the column sum across `Psi`.
#' @param ebr 
#' @param Psi_list 
#' @param y_list 
#' @param Sigma_a 
#' @param ab 
#' @param R 
#'
#' @return A vector containing the gradient for the conditional posterior of \eqn{\beta}.
#'
gradienta_modelA_fast <- function(ab, sumPsi, Psi_list, y_list, Sigma_a, R, sumsumPsi, Psi_ebr_list) {
  k = -sumsumPsi - (ab / Sigma_a) 
  for(r in 1:R){
    # k = k + colSums(Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (ab + ebr[,r]))))
    k = k + colSums(Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% ab + Psi_ebr_list[[r]])))
  }
  return(k)
}