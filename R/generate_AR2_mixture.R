#' @title Generate `R`-many conditionally independent varying AR(2) time series with angle representation
#'
#' @description
#' `generate_AR2_mixture()` generates `R`-many slightly varying AR(2) time series given an `R` long vector of peak locations and and `R` long vector of bandwidths.
#'
#' @param peaks A vector of length `R` with peak locations of each spectrum.
#' @param bandwidths A vector of length `n` with the bandwidths of each spectrum.
#' @param n A numeric vector that determines the length of the time series generated. Must contain `R`-many entries. Time series may be of different lengths.
#' @param variances An optional vector (default is `NULL`) of length `n` with the variances of the innovations.
#'
#' @return A list object that contains the following fields:
#' \tabular{ll}{
#'   `ts_list` \tab returns an `R`-long list each containing an `(n[r]` \eqn{\times} `1)` matrix of the generated time series. \cr
#'   `phi1_true` \tab returns a `(1` \eqn{\times} `R)` numeric matrix that contains the first AR(2) coefficients generated for each time series. \cr
#'   `phi2_true` \tab returns a `(1` \eqn{\times} `R)` numeric matrix that contains the second AR(2) coefficients generated for each time series. \cr
#' }
#'
#' @examples
#' R = 20
#' n = c(rep(300, R/2), rep(800, R/2))
#' 
#' ## Generate peaks and bandwidths:
#' peaks1 = stats::runif(R,
#'                       min = 0.2,
#'                       max = 0.23)
#' bandwidths1 = stats::runif(R,
#'                            min = .1,
#'                            max = .2)
#' peaks2 = stats::runif(R,
#'                       min = (pi * (2/5)) - 0.1,
#'                       max = (pi * (2/5)) + 0.1)
#' bandwidths2 = rep(0.15,
#'                   R)
#' peaks = rbind(peaks1, peaks2)
#' bandwidths = rbind(bandwidths1, bandwidths2)
#' 
#' ## Call the function to generate time series
#' ts = generate_AR2_mixture(peaks = peaks,
#'  bandwidths = bandwidths,
#'  n = n)$ts_list
#'
#' ## `$ts_list` returns an R-long list object each with a (n_vary[r] x 1) matrix object,
#' ## `$phi1_true` returns a (1 x 20) matrix of the first AR(2)
#' ## coefficients, and `$phi2_true` returns a
#' ## (1 x 20) matrix object of the second AR(2) coefficients.
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
#'
#' @export
generate_AR2_mixture <- function(peaks, bandwidths, n, variances = NULL) {
  # Extract the number of time series to generate:
  R <- ncol(peaks)
  # Assign variances if argument is left empty
  if (is.null(variances)) {
    variances <- matrix(1, nrow = nrow(peaks), ncol = R)
  }
  # generate matrix of realizations of each process, the multi-taper estimates,
  # and the "true" spectra
  ts_list = vector(mode = "list", length = R)
  
  phi1 = 2 * cos(peaks) * exp(-bandwidths)
  phi2 = -exp(-2 * bandwidths)
  
  for(r in 1:R){
    g = rep(0, n[r])
    for(p in 1:(nrow(phi1))){
      g = g + c(stats::arima.sim(list(ar = c(phi1[p,r], phi2[p,r])),
                               n = n[r],
                               sd = sqrt(variances[p,r])))
    }
    ts_list[[r]] = cbind(g)
    colnames(ts_list[[r]]) = NULL
  }
  row.names(phi1) = NULL
  row.names(phi2) = NULL
  return(list(
    "ts_list" = ts_list,
    "phi1_true" = phi1,
    "phi2_true" = phi2
  ))
}
