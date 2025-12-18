#' Title
#'
#' @param n 
#' @param R 
#' @param burn 
#' @param alpha 
#'
#' @returns
#' @export
#'
#' @examples
generate_MA4_vary = function(n = 1000, R = 1, burn = 50, alpha = 0.05){
  # create matrix to store the time series
  ts_list <- vector(mode = "list", length = R)
  # create matrix to store "true" theta values
  theta_true <- matrix(NA, nrow = 4, ncol = R)
  # create matrix to store mu_r values
  mu_r_gen <- matrix(NA, nrow = 4, ncol = R)
  # set AR parameter
  phi <- NULL
  # set MA parameter
  basetheta <- c(-.3,-.6,-.3,.6)
  for (r in 1:R) {
    # Take each theta from the baseline theta
    # sample from a N(0,1) to get a mu_r
    mu_r = rnorm(n = length(basetheta), mean = 0, sd = 1)
    # calculate: theta_r + alpha * |theta_r| * mu_r
    theta = basetheta + alpha * mu_r * abs(basetheta)
    # store MA(1) coefficient generated
    theta_true[,r] <- theta
    # store mu_r
    mu_r_gen[,r] <- mu_r
    # generate data
    ts_list[[r]] <- matrix(stats::arima.sim(model = list(ar = phi, ma = theta), n = n_vary[r], sd = 1, n.start = burn), ncol = 1)
  }
  return(list(
    "ts_list" = ts_list,
    "theta_true" = theta_true,
    "alpha" = alpha,
    "mu_r_gen" = mu_r_gen
  ))
  
  
  
  
  # S=arima.sim(n = size, list(ma=c(-.3,-.6,-.3,.6)  ), sd = 1, n.start = 10000)
  #standarized serie
  # S=(S-mean(S))/sd(S)
  
}