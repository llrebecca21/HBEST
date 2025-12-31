#' Function that calculates the conditional log posterior distribution of the vector \eqn{\pmb{a}} for Model A.
#'
#' @description
#' `logpost_glob_HBEST_fast` calculates the conditional posterior distribution for model B
#'
#' @param y_list An `R` list of column matrices each storing a truncated/half periodogram.
#' @param Psi_list A list of length `R` which stores the `Psi` matrix.
#' @param sumPsi `((B+1) x R)` The `r`th column of the column sum across `Psi`.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param Sigma_glob The current \eqn{\Sigma^{glob}}.
#' @param R A scalar indicating the number of conditionally independent time series.
#' @param sumsumPsi A numeric vector; the precomputed `rowSums(sumPsi)` for efficiency.
#' @param Psi_loc_list A list of length `R`; each element is the pre-computed \eqn{\Psi_r \beta^{loc}_r}
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