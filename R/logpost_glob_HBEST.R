#' Function that calculates the conditional log posterior distribution of the vector \eqn{\pmb{a}} for Model A.
#'
#' @description
#' `logpost_glob_HBEST` calculates the conditional posterior distribution for model B
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
logpost_glob_HBEST = function(ab, ebr, Sigma_a, y_list, sumPsi, Psi_list, R){
  k = -c(crossprod(rowSums(sumPsi), ab)) - sum(ab^2 / (Sigma_a * 2))
  for(r in 1:R){
    k = k-sum(y_list[[r]] / exp(Psi_list[[r]] %*% (ab + ebr[,r])))
  }
  return(k)
}