#' Griddy Gibbs update for global smoothing parameter (`tausquared`). (internal)
#' 
#' @description
#' A function which samples values for the `tausquared` update as specified in HBEST.
#' 
#' @param loc The current \eqn{\beta^{loc}}.
#' @param glob The current \eqn{\beta^{glob}}.
#' @param B An integer specifying the number of basis coefficients (not including the intercept basis coefficient \eqn{\beta_0}).
#' @param D A vector containing the diagonal elements of \eqn{D} and is a measure of prior variance for \eqn{\beta_1} through \eqn{\beta_B}.
#' @param R A scalar indicating the number of conditionally independent time series.
#' @param cur_zetasquared The current \eqn{\zeta^{2}_r}.
#' @param nu_tau A scalar indicating the degrees of freedom for the prior on \eqn{\tau}. (default is `2`).
#' @param tau_min A scalar controlling the smallest value \eqn{\tau} can take. So, `tau_min`^2 is the smallest value `tausquared` can take.
#' @param tau_max A scalar controlling the largest value \eqn{\tau} can take. So, `tau_max`^2 is the largest value `tausquared` can take.
#' @param num_gpts A scalar controlling the denseness of the grid during the sampling of both `tausquared`.
#' 
#' @return A scalar containing the sampled tausquared value.
#' @noRd
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







