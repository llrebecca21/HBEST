generate_MA4_varyType2 = function(n, R = 1, burn = 50, alpha){
  # create matrix to store the time series
  ts_list <- vector(mode = "list", length = R)
  # create baseline thetas:
  basetheta <- c(-.3,-.6,-.3,.6)
  # create matrix to store "true" theta values
  theta_true <- matrix(basetheta, nrow = 4, ncol = R)
  # create matrix to store mu_r values
  mu_r_gen <- rep(NA, length = R)
  # set AR parameter
  phi <- NULL
  for (r in 1:R) {
    # Take only the first theta from the baseline theta and vary that theta
    # sample from a N(0,1) to get a mu_r
    mu_r = rnorm(n = 1, mean = 0, sd = 1)
    # calculate: theta_r + alpha * |theta_r| * mu_r
    theta = basetheta[1] + alpha * mu_r * abs(basetheta[1])
    # store MA(1) coefficient generated
    theta_true[1,r] <- theta
    # store mu_r
    mu_r_gen[r] <- mu_r
    # generate data
    ts_list[[r]] <- matrix(stats::arima.sim(model = list(ar = phi, ma = theta_true[,r]),
                                            n = n[r],
                                            sd = 1,
                                            n.start = burn),
                           ncol = 1)
  }
  return(list(
    "ts_list" = ts_list,
    "theta_true" = theta_true
  ))
  
}
