#' Griddy Gibbs update for the local parameter zetasquared
#' 
#' @description
#' only need to pass beta_cur_sq_norm = (\eqn{\beta' D^{-1} \beta}). \eqn{\zeta} has half-t prior (with df = `nu_eta`)
#' 
#' @param zeta_min   : A scalar controlling the smallest value \eqn{\zeta} can take. So, `zeta_min`^2 is the smallest value `zetasquared` can take. (default is `1.001`).
#' @param zeta_max   : A scalar controlling the largest value \eqn{\zeta} can take. So, `zeta_max`^2 is the largest value that `zetasquared` can take. (default is `15`).
#' @param num_gpts   : A scalar controlling the denseness of the grid during the sampling of both `tausquared`.
#' @param B          : An integer specifying the number of basis coefficients (not including the intercept basis coefficient \eqn{\beta_0}).
#' @param D          : A vector containing the diagonal elements of \eqn{D} and is a measure of prior variance for \eqn{\beta_1} through \eqn{\beta_B}.
#' @param tausquared : The current global smoothing parameter `tausquared`.
#' @param loc        : The current \eqn{\beta^{loc}}.
#' @param nu_zeta    : A scalar indicating the degrees of freedom for the prior on \eqn{\zeta}.
#'
#' @return A vector containing the sampled zetasquared values.
#' @noRd
zetasquared_HBEST = function(loc, B, D, tausquared, nu_zeta, zeta_min, zeta_max, num_gpts){
  p_min = pt(q = zeta_min, df = nu_zeta)
  p_max = pt(q = zeta_max, df = nu_zeta)
  p_grid = seq(from = p_min, to = p_max,length.out = num_gpts)
  # inverse cdf (sort of)
  zeta_grid = qt(p = p_grid, df = nu_zeta) # equi-probability grid
  # non-linear transformation of the grid
  zeta_squared_grid = zeta_grid^2
  # compute log posterior-probability at each grid point (marginal)
  lgprob = -(nu_zeta + 1 / 2) * log(1 + (zeta_grid / nu_zeta)) -B/2 * log(zeta_squared_grid - 1) - sum(loc^2 / D) / (2*tausquared*(zeta_squared_grid - 1))
  # Caps lgprob at 1 or lower
  lgprob = lgprob - max(lgprob)
  # Get back into probability scale (softmax)
  postprob = exp(lgprob)/sum(exp(lgprob))
  zeta_squared_samp = sample(x = zeta_squared_grid,size = 1,replace = TRUE,prob = postprob)
  return(zeta_squared_samp)
}
