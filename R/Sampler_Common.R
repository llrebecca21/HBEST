#' Sampler Used to Run the Common method and the Independent Method
#' 
#' @details
#' To run the Common method, feed the sampler all time series at once. To run the Independent method, feed the sampler one time series at a time.
#' 
#' @param ts_list A list `R` long containing the vectors of the stationary time series of potentially different lengths.
#' @param B An integer specifying the number of basis coefficients (not including the intercept basis coefficient \eqn{\beta_0}).
#' @param iter An integer specifying the number of iterations for the MCMC algorithm embedded in this function.
#' @param nu_tau A scalar indicating the degrees of freedom for the prior on \eqn{\tau}. (default is `2`).
#' @param sigmasquared A scalar that is ideally the addition of `sigmasquared_glob` and `sigma_squared_loc` from the [HBEST::HBEST()] function. (default is `100.1`)
#' @param tausquared A scalar used as the initial value of `tausquared` that controls the global smoothing effect. (default is `10`).
#' @param tau_min A scalar controlling the smallest value \eqn{\tau} can take. So, `tau_min`^2 is the smallest value `tausquared` can take. (default is `0.001`).
#' @param tau_max A scalar controlling the largest value \eqn{\tau} can take. So, `tau_max`^2 is the largest value `tausquared` can take. (default is `100`).
#' @param num_gpts A scalar controlling the denseness of the grid during the sampling of both `tausquared` and `zetasquared`. (default is `1000`).
#' @param burnin An integer specifying the burn-in to be removed at the end of the sampling algorithm.
#'
#' @return A list object with components:
#' \tabular{ll}{
#'   `Theta` \tab returns an `( (iter - burnin)` \eqn{\times} `(B+1+1))` matrix that contains that estimates of \eqn{\beta} and the last entry is the estimate of \eqn{\tau^2}. \cr
#'   `perio` \tab returns an `R` list of column matrices each storing a truncated/half periodogram. \cr
#' }
#' @noRd
Sampler_Common = function(ts_list, B, iter, burnin, nu_tau = 2, sigmasquared = 100.1, tausquared = 10, tau_min = 0.001, tau_max = 100, num_gpts = 1000){
  
  # extract n and R from timeseries
  # extract the length of each replicate timeseries and store as a vector
  # ts_list will be the input for timeseries
  n_len = sapply(ts_list, nrow)
  R = length(n_len)
  
  # Create a single time series
  # set hyper-parameters
  # highest little j index value for the frequencies
  J = floor(n_len / 2)
  # Frequency (\omega_j): defined on [0, 2\pi)
  # for j = 0,...,n-1
  # omega = (2 * pi * (0:J)) / n
  
  #################
  # MCMC parameters
  #################
  
  # Rebecca's D
  D = 1 / (4 * pi * (1:B)^2)
  
  #######################
  # Initialize parameters
  #######################
  # The new D matrix that houses the prior variance of \beta^* 
  Sigma = c(sigmasquared, D * tausquared)
  
  # Create matrix to store estimated samples row-wise for (\beta^*, \tau^2)
  # ncol: number of parameters (beta^*, tau^2)
  # dim : (iter) x (B + 2)
  Theta = matrix(NA, nrow = iter, ncol = B + 2)
  # initialize perio as a list
  perio_list = vector(mode = "list", length = R)
  # initialize Psi as a list
  Psi_list = vector(mode = "list", length = R)
  # initialize beta_values
  betavalues = matrix(data = NA, nrow = B + 1, ncol = R)
  # initialize sumPsi
  sumPsi = matrix(data = NA, nrow = B + 1, ncol = R)
  
  # Define Periodogram and Psi
  for(r in 1:R){
    #r = 1
    # Define y_n(\omega_j) for the posterior function below
    perio_list[[r]] = (abs(fft(ts_list[[r]]))^ 2 / n_len[r])
    
    # subset perio for unique values, J = ceil((n-1) / 2) 
    perio_list[[r]] = perio_list[[r]][(1:J[r]+1), , drop = FALSE]
    
    # Create matrix of the basis functions
    # fix fourier frequencies
    Psi_list[[r]] = outer(X = (2 * pi * (1:J[r])) / n_len[r], Y = 0:B, FUN = function(x,y){sqrt(2)* cos(y * x)})
    # redefine the first column to be 1's
    Psi_list[[r]][,1] = 1
    
    # Using J amount of data for periodogram, can initialize beta this way:
    betavalues[,r] = solve(crossprod(Psi_list[[r]]), crossprod(Psi_list[[r]], log(perio_list[[r]])))
    
    # Specify Sum of X for the posterior function later
    # Specify Sum of X for the posterior function later
    # 1^T_n X part in the paper: identical to colSums but is a faster calculation
    sumPsi[,r] = c(crossprod(rep(1, nrow(Psi_list[[r]])), Psi_list[[r]]))
  }
  betavalues = rowMeans(betavalues)
  # calculate sumsumPsi which is the row sums of sumPsi
  sumsumPsi = rowSums(sumPsi)
  
  # Initialize first row of Theta
  Theta[1,] = c(betavalues, tausquared)
  
  #####################
  # MCMC Algorithm
  #####################
  
  #Rprof()
  # pb = progress_bar$new(total = iter - 1)
  for (g in 2:iter) {
    # pb$tick()
    #g = 2
    # Extract \beta^* and tau^2 from theta
    # beta^* of most recent iteration:
    b = Theta[g - 1, 1:(B+1)]
    # tau^squared of most recent iteration:
    tsq = Theta[g - 1, B + 2]
    ##########################
    # Metropolis Hastings Step
    ##########################
    # Maximum A Posteriori (MAP) estimate : finds the \beta^* that gives us the mode of the conditional posterior of \beta^* conditioned on y
    map = optim(par = b, fn = logposterior_common_list, gr = gradient_common_list, method ="BFGS", control = list(fnscale = -1),
                Psi_list = Psi_list, sumsumPsi = sumsumPsi, perio_list = perio_list, Sigma = Sigma, R = R)$par
    # Call the hessian function, and multiple by -1 to make it a positive definite matrix
    norm_precision <- -1 * hessian_common_list(b = map, Psi_list = Psi_list, perio_list = perio_list, Sigma = Sigma , R = R)
    # Calculate the \beta^* proposal, using Cholesky Sampling
    betaprop <- Chol_sampling(Lt = chol(norm_precision), d = B + 1, beta_c = map)
    # Calculate acceptance ratio
    prop_ratio <- min(1, exp(logposterior_common_list(b = betaprop, Psi_list = Psi_list, sumsumPsi = sumsumPsi, perio_list = perio_list,  Sigma = Sigma, R = R) -
                               logposterior_common_list(b = b, Psi_list = Psi_list, sumsumPsi = sumsumPsi, perio_list = perio_list,  Sigma = Sigma, R = R)))
    # Create acceptance decision
    accept <- runif(1)
    if(accept < prop_ratio){
      # Accept betaprop as new beta^*
      Theta[g, -(B+2)] <- betaprop
    }else{
      # Reject betaprop as new beta^*
      Theta[g, -(B+2)] <- b
    }
    ##############################
    # Tau^2 Update: Gibbs Sampler: conditional conjugate prior for the half-t
    ##############################
    # Call Griddy_Gibbs_tausquared Sampler
    newtsq = Griddy_Gibbs_tausquared_common(b = Theta[g, 2:(B+1)],
                                            B = B,
                                            D = D,
                                            nu_tau = nu_tau,
                                            tau_min = tau_min,
                                            tau_max = tau_max,
                                            num_gpts = num_gpts)
    # Update Theta matrix with new tau squared value
    Theta[g,B+2] = newtsq
    # Update Sigma with new tau^2 value
    Sigma = c(sigmasquared, D * newtsq)
  }
  # Rprof(NULL)
  # summaryRprof()
  
  
  #######################
  # Plots and Diagnostics
  #######################
  # Remove burn-in
  Theta <- Theta[-(1:burnin),]
  return(list("Theta" = Theta,
              "perio" = perio_list))
  
  
}