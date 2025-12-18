#' Function that calculates the conditional log posterior distribution of the vector \eqn{\pmb{a}} for Model A.
#'
#' @description
#' `logpost_glob_HBEST` calculates the conditional posterior distribution for model B
#'
#' @param y_list 
#' @param Psi_list 
#' @param sumPsi 
#' @param glob 
#' @param loc 
#' @param Sigma_glob 
#' @param R 
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta_{(r)}}.
#' @export
#'
#' @examples
logpost_glob_HBEST = function(glob, loc, Sigma_glob, y_list, sumPsi, Psi_list, R){
  k = -c(crossprod(rowSums(sumPsi), glob)) - sum(glob^2 / (Sigma_glob * 2))
  for(r in 1:R){
    k = k-sum(y_list[[r]] / exp(Psi_list[[r]] %*% (glob + loc[,r])))
  }
  return(k)
}