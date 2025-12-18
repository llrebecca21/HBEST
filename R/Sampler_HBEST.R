#' A Sampling Algorithm for HBEST
#'
#' @description
#' `Sampler_HBEST` is an MCMC algorithm that samples parameter values for HBEST.
#'
#'
#' @param ts_list A list `R` long containing the vectors of the stationary time series of potentially different lengths.
#' @param B       An integer specifying the number of basis coefficients (not including the intercept basis coefficient \eqn{\beta_0})
#' @param iter    An integer specifying the number of iterations for the MCMC algorithm embedded in this function.
#' @param tausquared A scalar which is used as the initial value of `tausquared` that controls the global smoothing effect.
#' @param burnin     An integer specifying the burn-in to be removed at the end of the sampling algorithm.
#' @param zeta_min   A scalar controlling the smallest value \eqn{\zeta} can take. So, `zeta_min`^2 is the smallest value `zetasquared` can take.
#' @param zeta_max   A scalar controlling the largest value \eqn{\zeta} can take. So, `zeta_max`^2 is the largest value that `zetasquared` can take.
#' @param tau_min    A scalar controlling the smallest value \eqn{\tau} can take. So, `tau_min`^2 is the smallest value `tausquared` can take.
#' @param tau_max    A scalar controlling the largest value \eqn{\tau} can take. So, `tau_max`^2 is the largest value `tausquared` can take.
#' @param num_gpts   A scalar controlling the denseness of the grid during the sampling of both `tausquared` and `zetasquared`.
#' @param nu_tau     A scalar indicating the degrees of freedom for the prior on \eqn{\tau}.
#' @param nu_zeta    A scalar indicating the degrees of freedom for the prior on \eqn{\zeta}.
#' @param sigmasquared_glob A scalar...
#' @param sigmasquared_loc A scalar...
#'
#' @return
#' @export
#'
#' @examples
Sampler_HBEST <- function(ts_list, B, iter, sigmasquared_glob, sigmasquared_loc, nu_tau, tausquared, nu_zeta, burnin, zeta_min, zeta_max, tau_min, tau_max, num_gpts) {
  # Extract length of each time series (n_len) and the number of time series (R) from time series input (ts_list)
  n_len <- sapply(ts_list, nrow)
  R <- length(n_len)

  # highest little j index value for the frequencies:
  J <- floor(n_len / 2)

  # Define D's main diagonal :
  # D is a measure of prior variance for \beta_1 through \beta_B
  D <- 1 / (4 * pi * (1:B)^2)

  # Create matrix to store estimated samples row-wise for \tau^2 for each iteration
  tausquared_samps <- matrix(NA, nrow = iter, ncol = 1)
  # Create array to store estimated samples row-wise for e^(r)_b for each iteration
  loc_samps <- array(data = NA, dim = c(iter, B + 1, R))
  # Create matrix to store estimated samples row-wise for beta^glob_b for each iteration
  glob_samps <- matrix(data = NA, nrow = iter, ncol = B + 1)

  # Initialize perio as a list
  perio_list <- vector(mode = "list", length = R)
  # initialize Psi as a list
  Psi_list <- vector(mode = "list", length = R)
  # initialize sumPsi
  sumPsi <- matrix(data = NA, nrow = B + 1, ncol = R)
  # initialize omega as a list
  omega <- vector(mode = "list", length = R)
  # initialize beta_values to help initialize beta^loc_{rb} and beta^glob_{b}
  betavalues <- matrix(data = NA, nrow = B + 1, ncol = R)

  # Define periodogram and Psi
  for (r in 1:R) {
    # Define y_n(\omega_j) for the posterior function below
    perio_list[[r]] <- (abs(stats::fft(ts_list[[r]]))^2 / n_len[r])
    # subset perio for unique values, J = floor(n/2)
    perio_list[[r]] <- perio_list[[r]][(1:J[r]) + 1, , drop = FALSE]

    ##########
    # Set Psi
    ##########
    # Create matrix of the basis functions with the Fourier frequencies
    Psi_list[[r]] <- outer(X = (2 * pi * (1:J[r])) / n_len[r], Y = 0:B, FUN = function(x, y) {
      sqrt(2) * cos(y * x)
    })
    # Redefine the first column of Psi to be 1's
    Psi_list[[r]][, 1] <- 1
    # omega for output:
    omega[[r]] <- (2 * pi * (1:J[r])) / n_len[r]

    # Specify Sum of Psi for the posterior function that is used later in sampler
    sumPsi[, r] <- crossprod(Psi_list[[r]], rep(1, J[r]))

    # Using J amount of data for the periodogram, can initialize beta this way:
    betavalues[, r] <- solve(crossprod(Psi_list[[r]]), crossprod(Psi_list[[r]], log(perio_list[[r]])))
  }

  ########################
  # Initialize Parameters
  ########################
  # Initialize beta^glob: the row means of the betavalues.
  glob <- rowMeans(betavalues)
  glob_samps[1, ] <- glob
  # Initialize beta^loc_{rb}: the residuals.
  loc <- betavalues - glob_samps[1, ]
  loc_samps[1, , ] <- loc
  # Initialize first row of tausquared_samps with the argument tausquared
  tausquared_samps[1, ] <- c(tausquared)
  # Initialize starting value of zetasquared.
  zetasquared <- rep(2, length = R)
  # Create matrix-array to store zetasquared values
  zetasquared_samps <- array(data = NA, dim = c(iter, R))
  # Initialize zetasquared values
  zetasquared_samps[1, ] <- zetasquared
  # The Sigma_glob matrix houses the prior variance of the beta^glob_b terms across b = 0,1,...,B terms
  Sigma_glob <- c(sigmasquared_glob / 2, D * tausquared)
  #####################
  # MCMC Algorithm
  #####################
  # begin counter:
  pb <- progress_bar$new(total = iter - 1)
  for (g in 2:iter) {
    pb$tick()
    ###############################################
    # Sample tausquared with Griddy Gibbs Step
    ###############################################
    tausquared <- tausquared_HBEST(
      loc = loc[-1, , drop = FALSE],
      glob = glob[-1],
      B = B,
      D = D,
      R = R,
      cur_zetasquared = zetasquared,
      nu_tau = nu_tau,
      tau_min = tau_min,
      tau_max = tau_max,
      num_gpts = num_gpts
    )

    # Update tausquared_samps matrix with new tausquared value
    tausquared_samps[g, ] <- tausquared
    # Update Sigma_a with new tausquared value
    Sigma_glob <- c(sigmasquared_glob / 2, D * tausquared)
    ###########################################
    # Update zetasquared using Griddy Gibbs
    ###########################################
    for (r in 1:R) {
      zetasquared[r] <- zetasquared_HBEST(
        loc = loc[-1, r, drop = FALSE],
        B = B,
        D = D,
        tausquared = tausquared,
        nu_zeta = nu_zeta,
        zeta_min = zeta_min,
        zeta_max = zeta_max,
        num_gpts = num_gpts
      )
    }

    # put zetasquared into array for storage
    zetasquared_samps[g, ] <- zetasquared

    ######################
    # beta^loc update : MH
    ######################
    for (r in 1:R) {
      # Update Sigma_loc with new rth zetasquared value
      Sigma_loc <- c(sigmasquared_loc / 2, D * tausquared * (zetasquared[r] - 1))
      map <- stats::optim(
        par = loc[, r], fn = logpost_loc_HBEST, gr = grad_loc_HBEST, method = "BFGS", control = list(fnscale = -1),
        glob = glob, Psi = Psi_list[[r]], sumPsi = sumPsi[, r, drop = FALSE], y = perio_list[[r]], Sigma_loc = Sigma_loc
      )$par
      # Call the Hessian function for HBEST
      precision_loc <- hess_loc_HBEST(loc = map, Psi = Psi_list[[r]], y = perio_list[[r]], glob = glob, Sigma_loc = Sigma_loc) * -1
      # Calculate the beta^loc_r proposal, using Cholesky Sampling
      locprop <- chol_sampling(Lt = chol(precision_loc), d = B + 1, beta_c = map)
      # Calculate acceptance ratio
      locprop_ratio <- min(1, exp(logpost_loc_HBEST(loc = locprop, glob = glob, Psi = Psi_list[[r]], sumPsi = sumPsi[, r, drop = FALSE], y = perio_list[[r]], Sigma_loc = Sigma_loc) -
        logpost_loc_HBEST(loc = loc[, r], glob = glob, Psi = Psi_list[[r]], sumPsi = sumPsi[, r, drop = FALSE], y = perio_list[[r]], Sigma_loc = Sigma_loc)))
      # Create acceptance decision
      accept <- stats::runif(1)
      if (accept < locprop_ratio) {
        # Accept locprop as new beta^loc_r
        loc[, r] <- locprop
      } else {
        # Reject locprop as new beta^loc_r
        loc[, r] <- loc[, r]
      }
    }
    ######################
    # beta^glob update : MH
    ######################
    map <- optim(
      par = glob, fn = logpost_glob_HBEST, gr = grad_glob_HBEST, method = "BFGS", control = list(fnscale = -1),
      loc = loc, Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_glob = Sigma_glob, R = R
    )$par
    # Call the Hessian function
    precision_glob <- hess_glob_HBEST(glob = map, Psi_list = Psi_list, y_list = perio_list, loc = loc, Sigma_glob = Sigma_glob, R = R) * -1
    # Calculate the beta^glob proposal, using Cholesky Sampling
    globprop <- chol_sampling(Lt = chol(precision_glob), d = B + 1, beta_c = map)
    # Calculate acceptance ratio
    globprop_ratio <- min(1, exp(logpost_glob_HBEST(glob = globprop, loc = loc, Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_glob = Sigma_glob, R = R) -
      logpost_glob_HBEST(glob = glob, loc = loc, Psi_list = Psi_list, sumPsi = sumPsi, y_list = perio_list, Sigma_glob = Sigma_glob, R = R)))
    # Create acceptance decision
    accept <- stats::runif(1)
    if (accept < globprop_ratio) {
      # Accept globprop as new beta^glob
      glob <- globprop
    } else {
      # Reject globprop as new beta^glob
      glob <- glob
    }
    loc_samps[g, , ] <- loc
    glob_samps[g, ] <- glob
  }
  return(list(
    "loc_samps" = loc_samps[-(1:burnin), , ],
    "glob_samps" = glob_samps[-(1:burnin), ],
    "zetasquared_samps" = zetasquared_samps[-(1:burnin), ],
    "tausquared_samps" = tausquared_samps[-(1:burnin), ],
    "perio_list" = perio_list,
    "omega" = omega,
    "D" = D
  ))
}
