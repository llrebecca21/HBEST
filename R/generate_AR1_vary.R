#' Generate multiple AR(1) varying time series
#'
#' @description
#' Generates `R` time series from an AR(1) varying processes.
#' Each time series AR(1) coefficient is uniformly chosen from the range provided by the `min` and `max` arguments.
#'
#' @param n An optional numeric scalar (default `1000`) that determines the length of the time series generated.
#' @param R An optional numeric scalar (default `1`) that determines how many time series to generate. Each time series is stored column wise in output.
#' @param burn An optional numeric scalar (default `50`) that determines the `n.start` argument of the `arima.sim()` function.
#' @param min An optional numeric scalar (default `0.45`) that determines the minimum value the AR(1) coefficient could possibly take.
#' @param max An optional numeric scalar (default `0.60`) that determines the maximum value the AR(1) coefficient could possibly take.
#'
#' @return a list object that contains the following fields:
#'
#' * `matrix_timeseries`: a `(n x R)` matrix that contains the slightly varying AR(1) time series.
#'
#' * `phi_true`: a `R` long vector object that contains the AR(1) coefficients for each time series.
#' @export
#'
#' @examples
#' n <- 1000
#' R <- 5
#' min <- 0.45
#' max <- 0.6
#' burn <- 50
#' generate_AR1_vary(n = 1000, R = 5, min = 0.45, max = 0.6, burn = 50)
#' ## Output is a list containing a (1000 x 5) matrix and a 5 long vector containing the true phi values randomly generated to create the R many time series.
#'
generate_AR1_vary <- function(n, R = 1, min = 0.45, max = 0.60, burn = 50) {
  # create matrix to store the time series
  matrix_timeseries <- matrix(NA, nrow = n, ncol = R)
  # create vector to store "true" phi values
  phi_true <- rep(NA, R)
  for (r in 1:R) {
    # set an AR parameter by randomly drawing from the Uniform(min, max) distribution
    phi <- stats::runif(n = 1, min = 0.45, max = 0.60)
    # store the phi value chosen
    phi_true[r] <- phi
    # generate the time series and store in the matrix
    matrix_timeseries[, r] <- stats::arima.sim(model = list(ar = phi), n = n, n.start = burn)
  }
  return(list("matrix_timeseries" = matrix_timeseries,
              "phi_true" = phi_true))
}
