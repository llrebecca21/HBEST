#' Griddy Gibbs update for global smoothing parameter (`tausquared`)
#' 
#' @description
#' A function which samples values for the `tausquared` update as specified in HBEST.
#' 
#' @param num_gpts 
#' @param D 
#' @param R 
#' @param nu_tau 
#' @param tau_min 
#' @param tau_max 
#' @param B 
#' @param cur_zetasquared 
#' @param loc 
#' @param glob 
#'
#' @return
#'
#' @examples
tausquared_HBEST = function(loc, glob, B, D, R, cur_zetasquared, nu_tau, tau_min, tau_max, num_gpts){
  p_min = pt(q = tau_min, df = nu_tau)
  p_max = pt(q = tau_max, df = nu_tau)
  p_grid = seq(from = p_min, to = p_max,length.out = num_gpts)
  # inverse cdf (sort of)
  tau_grid = qt(p = p_grid, df = nu_tau) # equi-probability grid
  # non-linear transformation of the grid
  tausquared_grid = tau_grid^2
  # compute log posterior-probability at each grid point
  lgprob = .5*-B*(R+1) * log(tausquared_grid) - sum(colSums(loc^2 / D) / (cur_zetasquared - 1)) / (2*tausquared_grid) -
    sum(glob^2 / D) / (2*tausquared_grid) - (nu_tau + 1) / 2 * log(1 + tau_grid / nu_tau)       
  lgprob = lgprob - max(lgprob)
  # Get back into probability scale (softmax)
  postprob = exp(lgprob)/sum(exp(lgprob))
  tausquaredsamp = sample(x = tausquared_grid,size = 1,replace = TRUE,prob = postprob)
  return(tausquaredsamp)
}







