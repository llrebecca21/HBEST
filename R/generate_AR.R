#' Generate R time series from the same AR(p) process
#'
#' @description
#' `generate_AR` creates `R` copies of an AR(p) process from `arima.sim()`.
#'
#' @param phi A vector that contains the AR(p) coefficients. Same syntax used in `arima.sim()`, e.g. `c(ar1coefficient, ar2coefficient)`.
#' @param n An optional numeric scalar (default `1000`) that determines the length of the time series generated.
#' @param R An optional numeric scalar (default `1`) that determines how many time series to generate. Each time series is stored column wise in output.
#' @param burn An optional numeric scalar (default `50`) that determines the `n.start` argument of the `arima.sim()` function.
#'
#' @return a list object that contains the matrix object `matrix_timeseries` of dimension `(n x R)`
#' @export
#'
#' @examples
#' ## An AR(1) process with `\phi = 0.5`
#' phi <- c(0.5)
#' n <- 2000
#' R <- 5
#' burn <- 100
#' generate_AR(phi = c(0.5), n = n, R = R, burn = 100)
#' ## output generates a list that contains a (2000 x 5) matrix
#'
generate_AR <- function(phi, n = 1000, R = 1, burn = 50) {
  # Create a matrix object to store time series objects
  matrix_timeseries <- matrix(NA, nrow = n, ncol = R)
  for (r in 1:R) {
    # generate the AR(p) time series using phi and optional burn and R arguments
    matrix_timeseries[, r] <- stats::arima.sim(model = list("ar" = phi), n = n, n.start = burn)
  }
  return(list("matrix_timeseries" = matrix_timeseries,
              "true_phi" = phi))
}
