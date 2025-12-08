#' Function that calculates the conditional log posterior distribution of the vector \eqn{\pmb{a}} for Model A.
#'
#' @description
#' `logposteriora_modelA` calculates the conditional posterior distribution for model B
#'
#' @param ab 
#' @param ebr 
#' @param Sigma_a 
#' @param y_list 
#' @param Psi_list 
#' @param sumPsi 
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @export
#'
#' @examples
logposteriora_modelA_fast = function(ab, Sigma_a, y_list, sumPsi, Psi_list, R, sumsumPsi, Psi_ebr_list){
 #k = -c(crossprod(sumsumPsi, ab)) - sum(ab^2 / (Sigma_a * 2))
  k = -sum(sumsumPsi * ab) - sum(ab^2 / (Sigma_a * 2))
  for(r in 1:R){
    # k = k-sum(y_list[[r]] / exp(Psi_list[[r]] %*% (ab + ebr[,r])))
    k = k-sum(y_list[[r]] / exp(Psi_list[[r]] %*% (ab) + Psi_ebr_list[[r]]))
  }
  return(k)
}