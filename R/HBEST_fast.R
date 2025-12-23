#' A Sampling Algorithm for HBEST (fast version)
#' 
#' @description
#' `HBEST_fast` is an MCMC algorithm that samples parameter values for HBEST (fast). This is a faster version of [HBEST::HBEST()].
#' 
#' @param ts_list A list `R` long containing the vectors of the stationary time series of potentially different lengths.
#' @param B       An integer specifying the number of basis coefficients (not including the intercept basis coefficient \eqn{\beta_0}).
#' @param iter    An integer specifying the number of iterations for the MCMC algorithm embedded in this function.
#' @param burnin     An integer specifying the burn-in to be removed at the end of the sampling algorithm.
#' @param sigmasquared_glob A scalar specifying the variance of the prior (N(0,`sigmasquared_glob`)) intercept term for \eqn{\beta^{glob}_0}. (default is `100` to ensure a diffuse prior).
#' @param sigmasquared_loc A scalar specifying the variance of the prior (N(0,`sigmasquared_loc`)) intercept term for \eqn{\beta^{loc}_0}. (default is `0.1`).
#' @param nu_tau     A scalar indicating the degrees of freedom for the prior on \eqn{\tau}. (default is `2`).
#' @param tausquared A scalar used as the initial value of `tausquared` that controls the global smoothing effect. (default is `10`).
#' @param nu_zeta    A scalar indicating the degrees of freedom for the prior on \eqn{\zeta}. (default is `5`).
#' @param zeta_min   A scalar controlling the smallest value \eqn{\zeta} can take. So, `zeta_min`^2 is the smallest value `zetasquared` can take. (default is `1.001`).
#' @param zeta_max   A scalar controlling the largest value \eqn{\zeta} can take. So, `zeta_max`^2 is the largest value that `zetasquared` can take. (default is `15`).
#' @param tau_min    A scalar controlling the smallest value \eqn{\tau} can take. So, `tau_min`^2 is the smallest value `tausquared` can take. (default is `0.001`).
#' @param tau_max    A scalar controlling the largest value \eqn{\tau} can take. So, `tau_max`^2 is the largest value `tausquared` can take. (default is `100`).
#' @param num_gpts   A scalar controlling the denseness of the grid during the sampling of both `tausquared` and `zetasquared`. (default is `1000`).
#' 
#'
#' @return A list object with components:
#' \tabular{ll}{
#'   `beta_loc_est` \tab returns a `(iter - burnin` \eqn{\times} `B+1` \eqn{\times} `R)` array of \eqn{\beta^{loc}_{br}} estimates. \cr
#'   `beta_glob_est` \tab returns a `(iter - burnin` \eqn{\times} `B+1)` array of \eqn{\beta^{glob}_{b}} estimates. \cr
#'   `zetasquared_est` \tab returns a `(iter - burnin` \eqn{\times} `R)` array of \eqn{\zeta^{2}_{r}} estimates. \cr
#'   `tausquared_est` \tab returns a `(iter - burnin` \eqn{\times} `1)` array of \eqn{\tau^{2}} estimates. \cr
#'   `perio_list` \tab returns an `R` list of column matrices each storing a truncated/half periodogram. \cr
#'   `omega` \tab returns an `R` list of column matrices each storing \eqn{\omega_{j}} see paper in references for details. \cr
#'   `D` \tab returns a `B` vector that stores the prior variance for \eqn{\beta_{1}} through \eqn{\beta_{B}}. \cr
#' }
#' 
#' @references
#' \insertRef{lee_hierarchical_2025}{HBEST}
#' 
#' @export
#'
#' @examples
HBEST_fast = function(ts_list, B, iter, burnin, sigmasquared_glob = 100, sigmasquared_loc = 0.1, nu_tau = 2, tausquared = 10, nu_zeta = 5, zeta_min = 1.001, zeta_max = 15, tau_min = 0.001, tau_max = 100, num_gpts = 1000){
  # Extract length of each time series (n_len) and the number of time series (R) from time series input (ts_list)
  n_len = sapply(ts_list, nrow)
  R = length(n_len)
  
  # Highest little j index value for the frequencies:
  J = floor(n_len / 2)
  
  # Define D's main diagonal : 
  # D is a measure of prior variance for \beta_1 through \beta_B
  D = 1 / (4 * pi * (1:B)^2)
  
  # Create matrix to store estimated samples row-wise for \tau^2 for each iteration
  tausquared_samps = matrix(NA, nrow = iter, ncol = 1)
  # Create array to store estimated samples row-wise for beta^loc for each iteration
  loc_samps = array(data = NA, dim = c(iter, B+1, R))
  # Create matrix to store estimated samples row-wise for beta^glob for each iteration
  glob_samps = matrix(data = NA, nrow = iter, ncol = B+1)
  
  # Initialize perio as a list
  perio_list = vector(mode = "list", length = R)
  # Initialize Psi as a list
  Psi_list = vector(mode = "list", length = R)
  # Initialize Psi_loc_list as a list
  Psi_loc_list = vector(mode = "list", length = R)
  # Initialize Psi_glob_list as a list
  Psi_glob_list = vector(mode = "list", length = R)
  # Initialize sumPsi as a matrix
  sumPsi = matrix(data = NA, nrow = B + 1, ncol = R)
  # initialize omega as a list
  omega = vector(mode = "list", length = R)
  # initialize beta_values to help initialize loc and glob
  betavalues = matrix(data = NA, nrow = B + 1, ncol = R)
  
  # Define periodogram and Psi
  for(r in 1:R){
    # Define y_n(\omega_j) for the posterior function below
    perio_list[[r]] = (abs(fft(ts_list[[r]]))^ 2 / n_len[r])
    
    # subset perio for unique values, J = floor(n/2)
    perio_list[[r]] = perio_list[[r]][(1:J[r]) + 1, , drop = FALSE]
    
    ##########
    # Set Psi
    ##########
    # Create matrix of the basis functions with the Fourier frequencies
    Psi_list[[r]] = outer(X = (2 * pi * (1:J[r])) / n_len[r], Y = 0:B, FUN = function(x,y){sqrt(2)* cos(y * x)})
    # Redefine the first column of Psi to be 1's
    Psi_list[[r]][,1] = 1
    # omega for output:
    omega[[r]] = (2 * pi * (1:J[r])) / n_len[r]
    
    # Specify Sum of Psi for the posterior function that is used later in the Sampler
    sumPsi[,r] = crossprod(Psi_list[[r]], rep(1,J[r])) 
    
    # Using J amount of data for the periodogram, can initialize Beta this way:
    betavalues[,r] = solve(crossprod(Psi_list[[r]]), crossprod(Psi_list[[r]], log(perio_list[[r]])))
  }
  
  #####################
  # Create sumsumPsi
  #####################
  sumsumPsi = rowSums(sumPsi)
  
  ########################
  # Initialize Parameters
  ########################
  # Initialize glob: the row means of the betavalues.
  glob = rowMeans(betavalues)
  glob_samps[1,] = glob
  # Initialize loc: the residuals. 
  loc = betavalues - glob_samps[1, ]
  loc_samps[1,,] = loc
  # Initialize Psi_loc_list
  for(r in 1:R){
    Psi_loc_list[[r]] = Psi_list[[r]] %*% loc[,r]
    Psi_glob_list[[r]] = Psi_list[[r]] %*% glob
  }
  # Initialize first row of tausquared_samps with the argument tausquared
  tausquared_samps[1,] = c(tausquared)
  # Initialize starting value of zetasquared
  zetasquared = rep(2, length = R)
  # Create matrix-array to store zetasquared values
  zetasquared_samps = array(data = NA, dim = c(iter,R))
  # Initialize zetasquared values
  zetasquared_samps[1,] = zetasquared
  # The Sigma_glob matrix houses the prior variance of the beta^glob terms across b = 0,1,...,B terms
  Sigma_glob = c(sigmasquared_glob/2, D * tausquared)
  #####################
  # MCMC Algorithm
  #####################
  # Update loc (local beta), glob (global beta), zetasquared (local smoothing), and tausquared (global smoothing)
  # begin counter:
  pb = progress_bar$new(total = iter-1)
  for (g in 2:iter) {
    pb$tick()
    ###############################################
    # Sample tausquared with Griddy Gibbs Step
    ###############################################
    tausquared = tausquared_HBEST(loc = loc[-1, , drop = FALSE],
                                  glob = glob[-1],
                                  B = B,
                                  D = D,
                                  R = R,
                                  cur_zetasquared = zetasquared,
                                  nu_tau = nu_tau,
                                  tau_min = tau_min,
                                  tau_max = tau_max,
                                  num_gpts = num_gpts)
    
    # Update tausquared_samps matrix with new tausquared value
    tausquared_samps[g,] = tausquared
    # Update Sigma_a with new tausquared value
    Sigma_glob = c(sigmasquared_glob/2, D * tausquared)
    ###########################################
    # Update zetasquared using Griddy Gibbs
    ###########################################
    for (r in 1:R){
      zetasquared[r] = zetasquared_HBEST(loc = loc[-1,r, drop = FALSE],
                                         B = B,
                                         D = D,
                                         tausquared = tausquared,
                                         nu_zeta = nu_zeta,
                                         zeta_min = zeta_min,
                                         zeta_max = zeta_max,
                                         num_gpts = num_gpts)
    }
    
    # put zetasquared into array for storage
    zetasquared_samps[g,] = zetasquared
    
    ######################
    # ebr update : MH
    ######################
    for(r in 1:R){
      # Update the Psi_glob_list 
      Psi_glob_list[[r]] = Psi_list[[r]] %*% glob
      # Update Sigma_loc with new rth zetasquared value
      Sigma_loc = c(sigmasquared_loc/2, D * tausquared * (zetasquared[r] - 1))
      map = optim(par = loc[,r], fn = logpost_loc_HBEST_fast, gr = grad_loc_BEST_fast, method = "BFGS", control = list(fnscale = -1),
                  Psi = Psi_list[[r]], sumPsi = sumPsi[,r, drop = FALSE], y = perio_list[[r]], Sigma_loc = Sigma_loc, Psi_glob = Psi_glob_list[[r]])$par
      # Call the Hessian function for HBEST_fast
      precision_loc = hess_loc_HBEST_fast(loc = map, Psi = Psi_list[[r]], y = perio_list[[r]], Sigma_loc = Sigma_loc, Psi_glob = Psi_glob_list[[r]]) * -1
      # Calculate the loc proposal, using Cholesky Sampling
      locprop = Chol_sampling(Lt = chol(precision_loc), d = B + 1, beta_c = map)
      # Calculate acceptance ratio
      locprop_ratio = min(1, exp(logpost_loc_HBEST_fast(loc = locprop, Psi = Psi_list[[r]], sumPsi = sumPsi[,r, drop = FALSE], y = perio_list[[r]], Sigma_loc = Sigma_loc, Psi_glob = Psi_glob_list[[r]]) -
                                 logpost_loc_HBEST_fast(loc = loc[,r], Psi = Psi_list[[r]], sumPsi = sumPsi[,r, drop = FALSE], y = perio_list[[r]], Sigma_loc = Sigma_loc, Psi_glob = Psi_glob_list[[r]])))
      # Create acceptance decision
      accept <- runif(1)
      if(accept < locprop_ratio){
        # Accept locprop as new beta^loc_r
        loc[ ,r] <- locprop
      }else{
        # Reject locprop as new beta^loc_r
        loc[ ,r] <- loc[,r]
      }
      
      # update Psi_loc_list
      Psi_loc_list[[r]] = Psi_list[[r]] %*% loc[,r]
    }
    ######################
    # beta^glob update : MH
    ######################
    map = optim(par = glob, fn = logpost_glob_HBEST_fast, gr = grad_glob_HBEST_fast, method = "BFGS", control = list(fnscale = -1),
                 Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_glob = Sigma_glob, R = R, sumsumPsi = sumsumPsi, Psi_loc_list = Psi_loc_list)$par
    # Call the Hessian function for HBEST_fast for update glob
    precision_glob = hess_glob_HBEST_fast(glob = map, Psi_list = Psi_list, y_list = perio_list, Sigma_glob = Sigma_glob, R = R, Psi_loc_list = Psi_loc_list) * -1
    # Calculate the ab proposal, using Cholesky Sampling
    globprop = Chol_sampling(Lt = chol(precision_glob), d = B + 1, beta_c = map)
    # Calculate acceptance ratio
    globprop_ratio = min(1, exp(logpost_glob_HBEST_fast(glob = globprop, Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_glob = Sigma_glob, R = R, sumsumPsi = sumsumPsi, Psi_loc_list = Psi_loc_list) -
                                logpost_glob_HBEST_fast(glob = glob, Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_glob = Sigma_glob, R = R, sumsumPsi = sumsumPsi, Psi_loc_list = Psi_loc_list)))
    # Create acceptance decision
    accept <- runif(1)
    if(accept < globprop_ratio){
      # Accept globprop as new beta^glob
      glob <- globprop
    }else{
      # Reject globprop as new beta^glob
      glob <- glob
    }
    loc_samps[g,,] <- loc
    glob_samps[g,] <- glob
  }
  return(list("beta_loc_est" = loc_samps[-(1:burnin),,],
              "beta_glob_est" = glob_samps[-(1:burnin),],
              "zetasquared_est" = zetasquared_samps[-(1:burnin),],
              "tausquared_est" = tausquared_samps[-(1:burnin),],
              "perio_list" = perio_list,
              "omega" = omega,
              "D" = D))
}




