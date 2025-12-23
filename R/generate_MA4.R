#' Generate Conditionally Independent `R`-Many MA(4) Time Series of the Same Length
#'
#' @description
#' The MA(4) coefficients used in the data generation are `(-.3,-.6,-.3,.6)`. This is based on the MA(4) used in \insertCite{granados-garcia_brain_2022;textual}{HBEST}.
#' 
#' @details
#' No variation around the base coefficients is used in this data generation function. 
#'
#' @param n A scalar indicating the length of all `R` time series. (default is `1000`).
#' @param R A scalar indicating the number of conditionally independent time series to be generated. (default is `1`).
#' @param burn A scalar indicating the amount of burn-in to be used with [stats::arima.sim()].  (default is `50`).
#' 
#' @returns The function returns a list containing:
#' \tabular{ll}{
#'   `ts_list` \tab returns an `R`-long list each containing an `(n` \eqn{\times} `1)` matrix of the generated time series. \cr
#'   `theta_true` \tab returns a `(4` \eqn{\times} `R)` matrix of true generated MA(4) coefficients. \cr
#' }
#' 
#' @export
#'
#' @examples
#' R = 20
#' n = rep(500, R)
#' burn = 50
#' ts = generate_MA4(n = n, R = R, burn = burn)$ts_list
#' ## Returns an R-long list object each with a (500 x 1) matrix object,
#' ## and a (4 x 20) matrix of true MA(4) coefficients - all the same value.
#' 
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
    ts_list[[r]] <- matrix(stats::arima.sim(model = list(ar = phi, ma = theta),
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