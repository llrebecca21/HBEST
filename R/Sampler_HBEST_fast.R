#' A Sampling Algorithm for HBEST (fast version)
#' 
#' @description
#' `HBEST_fast` is an MCMC algorithm that samples parameter values for HBEST (fast).
#' 
#'
#' @param ts_list A list `R` long containing the vectors of the stationary time series of potentially different lengths.
#' @param B       An integer specifying the number of basis coefficients (not including the intercept basis coefficient \eqn{\beta_0})
#' @param iter    An integer specifying the number of iterations for the MCMC algorithm embedded in this function.
#' @param sigmasquared A scalar specifying the variance of the prior (N(0,`sigmasquared`)) intercept term for \eqn{\beta_0}. (default is `100` to ensure a diffuse prior).
#' @param tausquared A scalar which is used as the initial value of `tausquared` that controls the global smoothing effect.
#' @param burnin     An integer specifying the burn-in to be removed at the end of the sampling algorithm.
#' @param zeta_min   A scalar controlling the smallest value \eqn{\zeta} can take. So, `zeta_min`^2 is the smallest value `zetasquared` can take.
#' @param zeta_max   A scalar controlling the largest value \eqn{\zeta} can take. So, `zeta_max`^2 is the largest value that `zetasquared` can take.
#' @param tau_min    A scalar controlling the smallest value \eqn{\tau} can take. So, `tau_min`^2 is the smallest value `tausquared` can take.
#' @param tau_max    A scalar controlling the largest value \eqn{\tau} can take. So, `tau_max`^2 is the largest value `tausquared` can take.
#' @param num_gpts   A scalar controlling the denseness of the grid during the sampling of both `tausquared` and `zetasquared`.
#' @param nu_tau     A scalar indicating the degrees of freedom for the prior on \eqn{\tau}.
#' @param nu_zeta    A scalar indicating the degrees of freedom for the prior on \eqn{\zeta}.
#'
#' @return
#' @export
#'
#' @examples
HBEST_fast = function(ts_list, B, iter, sigmasquared_a, sigmasquared_e, nu_tau, tausquared, nu_zeta, burnin, zeta_min, zeta_max, tau_min, tau_max, num_gpts){
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
  # Create array to store estimated samples row-wise for e^(r)_b for each iteration
  ebr_samps = array(data = NA, dim = c(iter, B+1, R))
  # Create matrix to store estimated samples row-wise for a_b for each iteration
  ab_samps = matrix(data = NA, nrow = iter, ncol = B+1)
  
  # Initialize perio as a list
  perio_list = vector(mode = "list", length = R)
  # initialize Psi as a list
  Psi_list = vector(mode = "list", length = R)
  # initialize Psi_ebr_list
  Psi_ebr_list = vector(mode = "list", length = R)
  # Initialize Psi_ab_list
  Psi_ab_list = vector(mode = "list", length = R)
  # initialize sumPsi
  sumPsi = matrix(data = NA, nrow = B + 1, ncol = R)
  # initialize omega as a list
  omega = vector(mode = "list", length = R)
  # initialize beta_values to help initialize erb and ab
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
  # Initialize ab: the row means of the betavalues.
  ab = rowMeans(betavalues)
  ab_samps[1,] = ab
  # Initialize erb: the residuals. 
  ebr = betavalues - ab_samps[1, ]
  ebr_samps[1,,] = ebr
  # Initialize Psi_ebr_list
  for(r in 1:R){
    Psi_ebr_list[[r]] = Psi_list[[r]] %*% ebr[,r]
    Psi_ab_list[[r]] = Psi_list[[r]] %*% ab
  }
  # Initialize first row of tausquared_samps with the argument tausquared
  tausquared_samps[1,] = c(tausquared)
  # Initialize starting value of zetasquared
  zetasquared = rep(2, length = R)
  # Create matrix-array to store zetasquared values
  zetasquared_samps = array(data = NA, dim = c(iter,R))
  # Initialize zetasquared values
  zetasquared_samps[1,] = zetasquared
  # The Sigma_a matrix houses the prior variance of the a_b terms across b = 0,1,...,B terms
  Sigma_a = c(sigmasquared_a/2, D * tausquared)
  #####################
  # MCMC Algorithm
  #####################
  # Update erb (local beta), ab (global beta), zetasquared (local smoothing), and tausquared (global smoothing)
  # begin counter:
  pb = progress_bar$new(total = iter-1)
  for (g in 2:iter) {
    pb$tick()
    ###############################################
    # Sample tausquared with Griddy Gibbs Step
    ###############################################
    tausquared = GG_tausquared_modelA(ebr = ebr[-1, , drop = FALSE],
                                      ab = ab[-1],
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
    Sigma_a = c(sigmasquared_a/2, D * tausquared)
    ###########################################
    # Update zetasquared using Griddy Gibbs
    ###########################################
    for (r in 1:R){
      zetasquared[r] = GG_zetasquared_modelA(er = ebr[-1,r, drop = FALSE],
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
      # Update the Psi_ab_list 
      Psi_ab_list[[r]] = Psi_list[[r]] %*% ab
      # Update Sigma_e with new rth zetasquared value
      Sigma_e = c(sigmasquared_e/2, D * tausquared * (zetasquared[r] - 1))
      map = optim(par = ebr[,r], fn = logposteriore_modelA_fast, gr = gradiente_modelA_fast, method = "BFGS", control = list(fnscale = -1),
                  Psi = Psi_list[[r]], sumPsi = sumPsi[,r, drop = FALSE], y = perio_list[[r]], Sigma_e = Sigma_e, Psi_ab = Psi_ab_list[[r]])$par
      # Call the Hessian function for HBEST_fast
      precisione_modelA = hee_modelA_fast(er = map, Psi = Psi_list[[r]], y = perio_list[[r]], Sigma_e = Sigma_e, Psi_ab = Psi_ab_list[[r]]) * -1
      # Calculate the er proposal, using Cholesky Sampling
      erprop = Chol_sampling(Lt = chol(precisione_modelA), d = B + 1, beta_c = map)
      # Calculate acceptance ratio
      erprop_ratio = min(1, exp(logposteriore_modelA_fast(er = erprop, Psi = Psi_list[[r]], sumPsi = sumPsi[,r, drop = FALSE], y = perio_list[[r]], Sigma_e = Sigma_e, Psi_ab = Psi_ab_list[[r]]) -
                                  logposteriore_modelA_fast(er = ebr[,r], Psi = Psi_list[[r]], sumPsi = sumPsi[,r, drop = FALSE], y = perio_list[[r]], Sigma_e = Sigma_e, Psi_ab = Psi_ab_list[[r]])))
      # Create acceptance decision
      accept <- runif(1)
      if(accept < erprop_ratio){
        # Accept erprop as new e^(r)
        ebr[ ,r] <- erprop
      }else{
        # Reject erprop as new e^(r)
        ebr[ ,r] <- ebr[,r]
      }
      
      # update Psi_ebr_list
      Psi_ebr_list[[r]] = Psi_list[[r]] %*% ebr[,r]
    }
    ######################
    # ab update : MH
    ######################
    map = optim(par = ab, fn = logposteriora_modelA_fast, gr = gradienta_modelA_fast, method = "BFGS", control = list(fnscale = -1),
                 Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_a = Sigma_a, R = R, sumsumPsi = sumsumPsi, Psi_ebr_list = Psi_ebr_list)$par
    # Call the Hessian function for HBEST_fast for update ab
    precisiona_modelA = hea_modelA_fast(ab = map, Psi_list = Psi_list, y_list = perio_list, Sigma_a = Sigma_a, R = R, Psi_ebr_list = Psi_ebr_list) * -1
    # Calculate the ab proposal, using Cholesky Sampling
    abprop = Chol_sampling(Lt = chol(precisiona_modelA), d = B + 1, beta_c = map)
    # Calculate acceptance ratio
    abprop_ratio = min(1, exp(logposteriora_modelA_fast(ab = abprop, Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_a = Sigma_a, R = R, sumsumPsi = sumsumPsi, Psi_ebr_list = Psi_ebr_list) -
                                logposteriora_modelA_fast(ab = ab, Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_a = Sigma_a, R = R, sumsumPsi = sumsumPsi, Psi_ebr_list = Psi_ebr_list)))
    # Create acceptance decision
    accept <- runif(1)
    if(accept < abprop_ratio){
      # Accept abprop as new ab
      ab <- abprop
    }else{
      # Reject abprop as new ab
      ab <- ab
    }
    ebr_samps[g,,] <- ebr
    ab_samps[g,] <- ab
  }
  return(list("beta_loc_est" = ebr_samps[-(1:burnin),,],
              "beta_glob_est" = ab_samps[-(1:burnin),],
              "zetasquared_est" = zetasquared_samps[-(1:burnin),],
              "tausquared_est" = tausquared_samps[-(1:burnin),],
              "perio_list" = perio_list,
              "omega" = omega,
              "D" = D))
}




