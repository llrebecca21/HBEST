#' @title Generate `R`-Many Conditionally Independent Time Series from the Same AR(p) Process
#'
#' @description
#' `generate_AR` generates `R`-many conditionally independent time series from an AR(p) process using `arima.sim()`.
#'
#' @param phi A vector containing the AR(p) coefficients. Same syntax used in `arima.sim()`, e.g. `c(ar1coefficient, ar2coefficient)`.
#' @param n An optional numeric scalar (default `1000`) that determines the length of the time series generated.
#' @param R An optional numeric scalar (default `1`) that determines how many time series to generate. Each time series is stored column wise in output.
#' @param burn An optional numeric scalar (default `50`) that determines the `n.start` argument of the `arima.sim()` function.
#'
#' @return a list object that contains the `R`-long list object `ts_list` each containing a matrix of dimension `(n x 1)` and the `true_phi` which is the user-specified `phi`.
#' @examples
#' ## An AR(1) process with `\phi = 0.5`
#' phi <- c(0.5)
#' n <- 2000
#' R <- 5
#' burn <- 100
#' ts <- generate_AR(phi = c(0.5), n = n, R = R, burn = 100)$ts_list
#' ## output generates an R-long list that each contains a (2000 x 1) matrix
#' @export
generate_AR <- function(phi, n = 1000, R = 1, burn = 50) {
  # create matrix to store the time series
  ts_list <- vector(mode = "list", length = R)
  for (r in 1:R) {
    # generate the AR(p) time series using phi and optional burn and R arguments
    ts_list[[r]] <- matrix(stats::arima.sim(model = list("ar" = phi), n = n, n.start = burn), ncol = 1)
  }
  return(list("ts_list" = ts_list,
              "true_phi" = phi))
}
