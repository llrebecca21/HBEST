#' Function that calculates the conditional log posterior distribution of the vector \eqn{\pmb{\beta}^{glob}} for HBEST.
#'
#' @description
#' `logpost_glob_HBEST` calculates the conditional posterior distribution for HBEST
#'
#' @param y_list An `R` list of column matrices each storing a truncated/half periodogram.
#' @param Psi_list A list of length `R` which stores the `Psi` matrix.
#' @param sumPsi `((B+1) x R)` The `r`th column of the column sum across `Psi`.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param Sigma_glob The current \eqn{\Sigma^{glob}}.
#' @param R A scalar indicating the number of conditionally independent time series.
#'
#' @return A vector that contains the posterior conditional for \eqn{\pmb{\beta}^{glob}}.
#' @noRd
logpost_glob_HBEST = function(glob, loc, Sigma_glob, y_list, sumPsi, Psi_list, R){
  k = -c(crossprod(rowSums(sumPsi), glob)) - sum(glob^2 / (Sigma_glob * 2))
  for(r in 1:R){
    k = k-sum(y_list[[r]] / exp(Psi_list[[r]] %*% (glob + loc[,r])))
  }
  return(k)
}