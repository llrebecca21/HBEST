#' Generate `R`-Many Conditionally Independent Varying AR(2) Time Series with Angle Representation
#'
#' @description
#' Generates `R` many slightly varying AR(2) time series given a `R` long vector of peak locations and and `R` long vector of bandwidths
#'
#' @param peaks a vector of length `R` with peak locations of each spectrum.
#' @param bandwidths a vector of length `n` with the bandwidths of each spectrum.
#' @param n_vary a numeric strictly positive scalar that determines the length of the time series generated.
#' @param variances an optional vector (default is `NULL`) of length `n` with the variances of the innovations.
#'
#' @return a list object that contains the following fields:
#'
#' * `matrix_timeseries`: a `(n x R)` matrix that contains the slightly varying AR(2) time series.
#'
#' * `phi`: a `(2 x R)` matrix object that contains the AR(2) coefficients generated for each time series.
#'
#' @export
#'
#' @examples
#' R = 20
#' peaks1 = runif(R, min = 0.2, max = 0.23)
#' bandwidths1 = runif(R, min = .1, max = .2)
#' peaks2 = runif(R, min = (pi * (2/5)) - 0.1, max = (pi * (2/5)) + 0.1)
#' bandwidths2 = rep(0.15, R)
#' peaks = rbind(peaks1, peaks2)
#' bandwidths = rbind(bandwidths1, bandwidths2)
#' ts = generate_AR2_mixture(peaks = peaks, bandwidth = bandwidth, n_vary = c(rep(300, 10), rep(800, 10)))
#' ## Returns an R-long list object each with a (n_vary[r] x 1) matrix object,
#' ## and a (2 x 20) matrix of AR(2) coefficients
#'
generate_AR2_mixture <- function(peaks, bandwidths, n_vary, variances = NULL) {
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
    g = rep(0, n_vary[r])
    for(p in 1:(nrow(phi1))){
      g = g + c(stats::arima.sim(list(ar = c(phi1[p,r], phi2[p,r])),
                               n = n_vary[r],
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
