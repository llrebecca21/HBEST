#' @title Generate `R`-many conditionally independent time series from the same AR(p) process
#'
#' @description
#' `generate_AR()` generates `R`-many conditionally independent time series from an AR(p) process using `arima.sim()`.
#'
#' @param phi A vector containing the AR(p) coefficients. Same syntax used in `arima.sim()`, e.g. `c(ar1coefficient, ar2coefficient)`.
#' @param n A numeric vector that determines the length of the time series generated. Must contain `R`-many entries. Time series may be of different lengths.
#' @param R An optional numeric scalar (default `1`) that determines how many time series to generate. Each time series is stored column wise in output.
#' @param burn An optional numeric scalar (default `50`) that determines the `n.start` argument of the `arima.sim()` function.
#'
#' @return A list object that contains the `R`-long list object `ts_list` each containing a matrix of dimension `(n[r] x 1)` and the `true_phi` which is the user-specified `phi`.
#' @examples
#' ## An AR(1) process with `phi = 0.5` and different length time-series
#' phi <- c(0.5)
#' R <- 5
#' n <- c(rep(2000, R - 2), rep(1000, R - 3))
#' burn <- 100
#' ts <- generate_AR(
#'   phi = c(0.5),
#'   n = n,
#'   R = R,
#'   burn = 100
#' )$ts_list
#' ## `$ts_list` output generates an R-long list that each
#' ## contains an (n[r] x 1) matrix
#'
#' ## Plot
#' ## Create an empty plot
#' plot(
#'   x = c(),
#'   y = c(),
#'   xlim = c(0, 2000),
#'   ylim = range(ts),
#'   ylab = "",
#'   xlab = "time"
#' )
#' for (r in 1:3) {
#'   lines(ts[[r]][, 1], col = "blue")
#' }
#' for (r in 4:R) {
#'   lines(ts[[r]][, 1], col = "red")
#' }
#'
#' #' ## An AR(1) process with `phi = 0.5` and same length time-series
#' phi <- c(0.5)
#' R <- 5
#' n <- rep(2000, R)
#' burn <- 100
#' ts <- generate_AR(
#'   phi = c(0.5),
#'   n = n,
#'   R = R,
#'   burn = 100
#' )$ts_list
#' ## `$ts_list` output generates an R-long list that each
#' ## contains an (n[r] x 1) matrix
#'
#' ## Plot
#' ## Create an empty plot
#' plot(
#'   x = c(),
#'   y = c(),
#'   xlim = c(0, 2000),
#'   ylim = range(ts),
#'   ylab = "",
#'   xlab = "time"
#' )
#' for (r in 1:R) {
#'   lines(ts[[r]][, 1], col = "blue")
#' }
#'
#' @export
generate_AR <- function(phi, n, R = 1, burn = 50) {
  # create a list to store the time series
  ts_list <- vector(mode = "list", length = R)
  for (r in 1:R) {
    # generate the AR(p) time series using phi and optional burn and R arguments
    ts_list[[r]] <- matrix(stats::arima.sim(model = list("ar" = phi), n = n[r], n.start = burn), ncol = 1)
  }
  return(list(
    "ts_list" = ts_list,
    "true_phi" = phi
  ))
}
