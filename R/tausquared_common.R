#' Griddy Gibbs Update for Common and Independent Method.
#'
#' @param num_gpts : number of grid points controls how dense the grid is.
#' @param b        : 
#' @param D        : 
#' @param nu_tau   : Degrees of freedom used for the t-distribution CDF and quantile functions.
#' @param tau_min  : The minimum value for the creation of the uniform grid of \eqn{\tau} values.
#' @param tau_max  : The maximum value for the creation of the uniform grid of \eqn{\tau} values.
#' @param B        : The number of basis functions.
#'
#' @return
#'
tausquared_common = function(b, B, D, nu_tau, tau_min, tau_max, num_gpts){
  # zeta_grid = seq(zeta_min,zeta_max,length.out=num_gpts) for equi-spaced grid points
  p_min = pt(q = tau_min, df = nu_tau)
  p_max = pt(q = tau_max, df = nu_tau)
  p_grid = seq(from = p_min, to = p_max,length.out = num_gpts)
  # inverse cdf (sort of)
  tau_grid = qt(p = p_grid, df = nu_tau) # equi-probability grid
  # plot(tau_grid, p_grid)
  # non-linear transformation of the grid
  tausquared_grid = tau_grid^2
  # compute log posterior-probability at each grid point
  lgprob = -B*0.5 * log(tausquared_grid) - 1/tausquared_grid * (sum(b^2 / (2*D)))
  # Caps lgprob at 1 or lower
  lgprob = lgprob - max(lgprob)
  # Get back into probability scale (softmax)
  postprob = exp(lgprob)/sum(exp(lgprob))
  tausquaredsamp = sample(x = tausquared_grid,size = 1,replace = TRUE,prob = postprob)
  return(tausquaredsamp)
}







