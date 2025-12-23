#' Time-series Data Generation Wrapper Function.
#' 
#' @description
#' This function is a wrapper function for various time-series data generation methods.
#' This is used to call one of six methods that generates data in the structure used for simulations for [HBEST::HBEST()] or [HBEST::HBEST_fast()].
#' 
#' @param gen_method Method of data generation to use. Options include `ARp`, `AR1vary`, `AR2mix`, `MA4`, `MA4vary`, and `MA4varyType2`.
#' @param ... further arguments, passed to chosen method. See details below.
#'
#' @details Available data generation methods include:
#' \tabular{ll}{
#'   `ARp` \tab calls the [HBEST::generate_AR()] function which is based on [stats::arima.sim]. \cr
#'   `AR1vary` \tab calls the [HBEST::generate_AR1_vary()] function which is based on [stats::arima.sim]. \cr
#'   `AR2mix` \tab calls the [HBEST::generate_AR2_mixture()] function which is based on [stats::arima.sim] and \insertCite{granados-garcia_brain_2022}{HBEST}. \cr
#'   `MA4` \tab calls the [HBEST::generate_MA4()] function which is based on [stats::arima.sim]. \cr
#'   `MA4vary` \tab calls the [HBEST::generate_MA4_vary()] function which is based on [stats::arima.sim]. \cr
#'   `MA4varyType2` \tab calls the [HBEST::generate_MA4_varyType2()] function which is based on [stats::arima.sim]. \cr
#' }
#' 
#' @returns The `gen_data()` function returns the appropriate objects based on the method chosen. See help pages for each function for more details.
#' @export
#'
#' @examples
#' ## `ARp` method:
#' gen_data(gen_method = "ARp", phi = c(0.5), n = n, R = R, burn = 100)
#' 
gen_data = function(gen_method, ...){
  gen_method = match.arg(gen_method, c("ARp", "AR1vary", "AR2mix", "MA4","MA4vary","MA4varyType2"))
  # Extract call parameters:
  Call = c(as.list(environment()), list(...))
  
  Send_Call = switch(gen_method,
                     ARp = formals(generate_AR),
                     AR1vary = formals(generate_AR1_vary),
                     AR2mix = formals(generate_AR2_mixture),
                     MA4vary = formals(generate_MA4_vary),
                     MA4 = formals(generate_MA4),
                     MA4varyType2 = formals(generate_MA4_varyType2),
                     stop("Invalid `gen_method` value"))
  
  Send_Call[names(Call)[names(Call) %in% names(Send_Call)]] = Call[names(Call) %in% names(Send_Call)]
  
  out = switch(gen_method,
               ARp = do.call(generate_AR, args = Send_Call),
               AR1vary = do.call(generate_AR1_vary, args = Send_Call),
               AR2mix = do.call(generate_AR2_mixture, args = Send_Call),
               MA4vary = do.call(generate_MA4_vary, args = Send_Call),
               MA4 = do.call(generate_MA4, args = Send_Call),
               MA4varyType2 = do.call(generate_MA4_varyType2, args = Send_Call),
               stop("Invalid `gen_method` value"))
  
  return(out)
  
}






