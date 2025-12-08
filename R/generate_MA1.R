#' Generate R many time series from a random MA(1) process
#'
#' @description
#' Generate R many time series from an MA(1) process with a randomly chosen MA(1) coefficient
#' from a Uniform(0,1) distribution.
#'
#'
#' @inheritParams generate_AR
#'
#' @return  a list object that contains the following fields:
#'
#' * `matrix_timeseries`: a `(n x R)` matrix that contains the slightly varying MA(1) time series.
#'
#' * `theta_true`: a `R` long vector object that contains the MA(1) coefficients generated for each time series.
#'
#' @export
#'
#' @examples
#' n <- 2000
#' R <- 20
#' burn <- 50
#' generate_MA1(n = 2000, R = 20, burn = 50)
#' ## Returns a list with a matrix (2000 x 20) and
#' ## a R long vector of generated theta values
#'
generate_MA1 <- function(n = 1000, R = 1, burn = 50) {
  # create matrix to store the time series
  matrix_timeseries <- matrix(NA, nrow = n, ncol = R)
  # create vector to store "true" theta values
  theta_true <- rep(NA, R)
  for (r in 1:R) {
    # set AR parameter
    phi <- NULL
    # set MA parameter
    theta <- stats::runif(n = 1, min = 0, max = 1)
    # store MA(1) coefficient generated
    theta_true[r] <- theta
    # generate data
    matrix_timeseries[, r] <- stats::arima.sim(model = list(ar = phi, ma = theta), n = n, n.start = burn)
  }
  return(list(
    "matrix_timeseries" = matrix_timeseries,
    "theta_true" = theta_true
  ))
}
