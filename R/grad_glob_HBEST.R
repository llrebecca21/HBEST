#' Calculate the gradient of the conditional log posterior distribution of \eqn{\pmb{\beta}^{glob}}  from HBEST.
#' 
#' @description
#' `grad_glob_HBEST` function calculates the conditional posterior for the `r`th \eqn{\pmb{\beta}^{glob}}  coefficients under HBEST.
#' 
#' @param sumPsi  `((B+1) x R)` The `r`th column of the column sum across `Psi`.
#' @param Psi_list A list of length `R` which stores the `Psi` matrix.
#' @param y_list An `R` list of column matrices each storing a truncated/half periodogram.
#' @param R A scalar indicating the number of conditionally independent time series.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param Sigma_glob The current \eqn{\Sigma^{glob}}.
#'
#' @return A vector containing the gradient for the conditional posterior of \eqn{\pmb{\beta}^{glob}}.
#' @keywords internal
#' @noRd
grad_glob_HBEST <- function(loc, glob, sumPsi, Psi_list, y_list, Sigma_glob, R) {
  k = -rowSums(sumPsi) - (glob / Sigma_glob) 
  for(r in 1:R){
    k = k + colSums(Psi_list[[r]] * c(y_list[[r]] / exp(Psi_list[[r]] %*% (glob + loc[,r]))))
  }
  return(k)
}