#' Calculate the gradient of the conditional log posterior distribution of the \eqn{\pmb{\beta}^{loc}_r} from HBEST.
#' 
#' @description
#' `grad_loc_HBEST` function calculates the conditional posterior for the `r`th \eqn{\beta^{loc}} coefficients under HBEST.
#' 
#' @param sumPsi  The `r`th column of the column sum across `Psi`.
#' @param Psi The `r`th `Psi` matrix.
#' @param y   The `r`th periodogram sub-setted for the Fourier frequencies for the `r`th time series.
#' @param loc The current \eqn{\beta^{loc}}.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param Sigma_loc The current \eqn{\Sigma^{loc}}.
#'
#' @return A vector containing the gradient for the conditional posterior of \eqn{\pmb{\beta}^{loc}_r}.
#' @noRd
grad_loc_HBEST <- function(loc, glob, sumPsi, Psi, y, Sigma_loc) {
  -sumPsi - (loc / Sigma_loc) + colSums(Psi * c(y / exp(Psi %*% (glob + loc))))
}