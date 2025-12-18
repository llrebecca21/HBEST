#' Calculate the gradient of the conditional log posterior distribution of \eqn{\pmb{a}} from Model A.
#' 
#' @description
#' `grad_glob_HBEST` function calculates the conditional posterior for the `r`th \eqn{\beta} coefficients under Model B.
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
#' @export
#'
#' @examples
grad_glob_HBEST <- function(ebr, ab, sumPsi, Psi_list, y_list, Sigma_a, R) {
  k = -rowSums(sumPsi) - (ab / Sigma_a) 
  for(r in 1:R){
    k = k + colSums(Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (ab + ebr[,r]))))
  }
  return(k)
}