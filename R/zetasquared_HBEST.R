#' Griddy Gibbs update for the local parameter zetasquared
#' 
#' @description
#' only need to pass beta_cur_sq_norm = (\eqn{\beta' D^{-1} \beta}). \eqn{\zeta} has half-t prior (with df = `nu_eta`)
#' 
#' @param zeta_min The smallest value zeta can take (default to `1`).
#' @param zeta_max The largest value zeta can take (default to `10`).
#' @param num_gpts A number which controls how dense the grid is.
#' @param B        An integer specifying the number of basis coefficients.
#' @param D        The vector of dampening coefficients in the prior.
#' @param tausquared The current global smoothing parameter `tausquared`.
#' @param loc
#' @param nu_zeta   A scalar that controls the degrees of freedom for the `zeta` prior.
#'
#' @return A vector containing the sampled zeta values.
#'
#' @examples
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
