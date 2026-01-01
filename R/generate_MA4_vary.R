#' @title generate `R`-many conditionally independent varying MA(4) time series
#'
#' @description
#' `generate_MA4_vary()` generates `R`-many time series where the MA(4) that is used as the base coefficients for the variation is `(-.3,-.6,-.3,.6)`.
#' This is based on the MA(4) used in \insertCite{granados-garcia_brain_2022;textual}{HBEST}.
#' 
#' @details
#' The variation around the base theta coefficients is generated in the function by:
#' 1. Sample 4 values from a \eqn{N(0,1)} to use as a "mean".
#' 2. Calculate: `basetheta + alpha * mu_r * abs(basetheta)` where `basetheta` is the original coefficients; `mu_r` is the 4 sampled values from the \eqn{N(0,1)}; and `alpha` is the user-specified scalar that controls the variation around the base coefficients. 
#' 3. Generate: A new time-series using the new `theta` value from step 2.
#' 4. Repeat steps 1-3 `R`-many times.
#'
#' @param n A numeric vector that determines the length of the time series generated. Must contain `R`-many entries. Time series may be of different lengths.
#' @param R An optional scalar indicating the number of conditionally independent time series to be generated. (default is `1`).
#' @param burn A scalar indicating the amount of burn-in to be used with [stats::arima.sim()].  (default is `50`).
#' @param alpha A scalar specifying the variation wanted from the base coefficients. (default is `0.05`).
#'
#' @returns The function returns a list containing:
#' \tabular{ll}{
#'   `ts_list` \tab returns an `R`-long list each containing an `(n[r]` \eqn{\times} `1)` matrix of the generated time series. \cr
#'   `theta_true` \tab returns a `(4` \eqn{\times} `R)` matrix of true generated MA(4) coefficients. \cr
#'   `alpha` \tab returns the user-provided variation scalar. \cr
#'   `mu_r_gen` \tab returns the `(4` \eqn{\times} `R)` matrix of the generated standard normal values used to help calculate the new MA(4) coefficients. \cr
#' }
#' 
#'
#' @examples
#' R <- 20
#' ## For time series of different lengths:
#' n <- c(rep(500, R/2), rep(800, R/2))
#' burn <- 50
#' alpha <- 0.05
#' ts <- generate_MA4_vary(n = n, R = R, burn = burn, alpha = alpha)$ts_list
#' 
#' ## The function returns an R-long list object each with a (n[r] x 1) matrix object,
#' ## a (4 x 20) matrix of true MA(4) coefficients,
#' ## a scalar returning the alpha provided,
#' ## and a (4 x 20) matrix of the standard normal values generated for each R.
#' 
#' ## Plot
#' ## Create an empty plot
#' plot(
#'   x = c(),
#'   y = c(),
#'   xlim = c(0, 800),
#'   ylim = range(ts),
#'   ylab = "",
#'   xlab = "time"
#' )
#' for (r in 1:10) {
#'   lines(ts[[r]][, 1], col = "blue")
#' }
#' for (r in 11:R) {
#'   lines(ts[[r]][, 1], col = "red")
#' }
#'
#' @export
generate_MA4_vary = function(n, R = 1, burn = 50, alpha = 0.05){
  # create list to store the time series
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
    mu_r = stats::rnorm(n = length(basetheta), mean = 0, sd = 1)
    # calculate: theta_r + alpha * |theta_r| * mu_r
    theta = basetheta + alpha * mu_r * abs(basetheta)
    # store MA(1) coefficient generated
    theta_true[,r] <- theta
    # store mu_r
    mu_r_gen[,r] <- mu_r
    # generate data
    ts_list[[r]] <- matrix(stats::arima.sim(model = list(ar = phi, ma = theta), n = n[r], sd = 1, n.start = burn), ncol = 1)
  }
  return(list(
    "ts_list" = ts_list,
    "theta_true" = theta_true,
    "alpha" = alpha,
    "mu_r_gen" = mu_r_gen
  ))
}