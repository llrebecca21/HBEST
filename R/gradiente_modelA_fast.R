#' Calculate the gradient of the conditional log posterior distribution of the \eqn{\pmb{e}^{(r)}} from Model A.
#' 
#' @description
#' `gradiente_modelA_fast` function calculates the conditional posterior for the `r`th \eqn{\beta} coefficients under Model B.
#' 
#' @param sumPsi  The `r`th column of the column sum across `Psi`.
#' @param Psi The `r`th `Psi` matrix.
#' @param er 
#' @param ab 
#' @param Sigma_e 
#' @param y   The `r`th periodogram sub-setted for the Fourier frequencies for the `r`th time series.
#'
#' @return A vector containing the gradient for the conditional posterior of \eqn{\beta}.
#' @export
#'
#' @examples
gradiente_modelA_fast <- function(er, sumPsi, Psi, y, Sigma_e, Psi_ab) {
  -sumPsi - (er / Sigma_e) + colSums(Psi * c(y / exp(Psi_ab + Psi %*% er)))
}