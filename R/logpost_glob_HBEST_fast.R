#' Function that calculates the conditional log posterior distribution of the vector \eqn{\pmb{a}} for Model A.
#'
#' @description
#' `logpost_glob_HBEST_fast` calculates the conditional posterior distribution for model B
#'
#' @param ab 
#' @param ebr 
#' @param Sigma_a 
#' @param y_list 
#' @param Psi_list 
#' @param sumPsi 
#'
#' @return A vector that contains the `r`th posterior conditional for \eqn{\beta^{(r)}}.
#' @noRd
logpost_glob_HBEST_fast = function(glob, Sigma_glob, y_list, sumPsi, Psi_list, R, sumsumPsi, Psi_loc_list){
 #k = -c(crossprod(sumsumPsi, ab)) - sum(ab^2 / (Sigma_a * 2))
  k = -sum(sumsumPsi * glob) - sum(glob^2 / (Sigma_glob * 2))
  for(r in 1:R){
    # k = k-sum(y_list[[r]] / exp(Psi_list[[r]] %*% (ab + ebr[,r])))
    k = k-sum(y_list[[r]] / exp(Psi_list[[r]] %*% (glob) + Psi_loc_list[[r]]))
  }
  return(k)
}