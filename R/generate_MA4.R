#' Title
#'
#' @param n 
#' @param R 
#' @param burn 
#'
#' @returns
#' @export
#'
#' @examples
generate_MA4 = function(n = 1000, R = 1, burn = 50){
  # create matrix to store the time series
  ts_list <- vector(mode = "list", length = R)
  # create matrix to store "true" theta values
  theta_true <- matrix(NA, nrow = 4, ncol = R)
  for (r in 1:R) {
    # set AR parameter
    phi <- NULL
    # set MA parameter
    theta <- c(-.3,-.6,-.3,.6)
    # store MA(1) coefficient generated
    theta_true[,r] <- theta
    # generate data
    ts_list[[r]] <- matrix(stats::arima.sim(model = list(ar = phi, ma = theta), n = n, sd = 1, n.start = burn), ncol = 1)
  }
  return(list(
    "ts_list" = ts_list,
    "theta_true" = theta_true
  ))
  
  
  
  
  # S=arima.sim(n = size, list(ma=c(-.3,-.6,-.3,.6)  ), sd = 1, n.start = 10000)
  #standarized serie
  # S=(S-mean(S))/sd(S)
  
}