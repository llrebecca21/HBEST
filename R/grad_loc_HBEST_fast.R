#' Calculate the gradient of the conditional log posterior distribution of the \eqn{\pmb{e}^{(r)}} from Model A.
#' 
#' @description
#' `grad_loc_HBEST_fast` function calculates the conditional posterior for the `r`th \eqn{\beta} coefficients under Model B.
#' 
#' @param sumPsi  The `r`th column of the column sum across `Psi`.
#' @param Psi The `r`th `Psi` matrix.
#' @param y   The `r`th periodogram sub-setted for the Fourier frequencies for the `r`th time series.
#' @param loc 
#' @param Sigma_loc 
#' @param Psi_glob 
#'
#' @return A vector containing the gradient for the conditional posterior of \eqn{\beta}.
#' @noRd
grad_loc_HBEST_fast <- function(loc, sumPsi, Psi, y, Sigma_loc, Psi_glob) {
  -sumPsi - (loc / Sigma_loc) + colSums(Psi * c(y / exp(Psi_glob + Psi %*% loc)))
}