periodogram <- function(ts_list, n_len, J){
    # Define y_n(\omega_j) for the posterior function below
    perio_list = (abs(fft(ts_list))^ 2 / n_len)
    # subset perio for unique values, J = floor(n/2)
    perio_list = perio_list[(1:J) + 1, , drop = FALSE]
    return(perio_list)
}



