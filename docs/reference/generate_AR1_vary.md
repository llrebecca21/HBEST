# Generate `R`-many conditionally independent AR(1) varying time series

`generate_AR1_vary()` generates `R`-many time series from an AR(1)
varying processes. Each time series AR(1) coefficient is uniformly
chosen from the range provided by the `min` and `max` arguments.

## Usage

``` r
generate_AR1_vary(n, R = 1, min = 0.45, max = 0.6, burn = 50)
```

## Arguments

- n:

  A numeric vector that determines the length of the time series
  generated. Must contain `R`-many entries. Time series may be of
  different lengths.

- R:

  An optional numeric scalar (default `1`) that determines how many time
  series to generate. Each time series is stored as a column-vector in
  the list output.

- min:

  An optional numeric scalar (default `0.45`) that determines the
  minimum value the AR(1) coefficient could possibly take.

- max:

  An optional numeric scalar (default `0.60`) that determines the
  maximum value the AR(1) coefficient could possibly take.

- burn:

  An optional numeric scalar (default `50`) that determines the
  `n.start` argument of the
  [`arima.sim()`](https://rdrr.io/r/stats/arima.sim.html) function.

## Value

a list object that contains the following fields:

|  |  |
|----|----|
| `ts_list` | returns an `R`-long list each containing an `(n[r]` \\\times\\ `1)` matrix of the generated time series. |
| `true_phi` | returns a `(1` \\\times\\ `R)` matrix of true generated AR(1) coefficients. |

## Examples

``` r
## An AR(1) process with coefficient(s) selected from $U(min,max)$
## with different length time-series
R <- 5
n <- c(rep(2000, R - 2), rep(1000, R - 3))
burn <- 100
ts <- generate_AR1_vary(
  n = n,
  R = 5
)$ts_list
## `$ts_list` output generates an R-long list that each
## contains an (n[r] x 1) matrix

## Plot
## Create an empty plot
plot(
  x = c(),
  y = c(),
  xlim = c(0, 2000),
  ylim = range(ts),
  ylab = "",
  xlab = "time"
)
for (r in 1:3) {
  lines(ts[[r]][, 1], col = "blue")
}
for (r in 4:R) {
  lines(ts[[r]][, 1], col = "red")
}


## An AR(1) process with coefficient(s) selected from $U(min,max)$
## with same length time-series
phi <- c(0.5)
R <- 5
n <- rep(2000, R)
burn <- 100
ts <- generate_AR1_vary(
  n = n,
  R = 5
)$ts_list
## `$ts_list` output generates an R-long list that each
## contains an (n[r] x 1) matrix

## Plot
## Create an empty plot
plot(
  x = c(),
  y = c(),
  xlim = c(0, 2000),
  ylim = range(ts),
  ylab = "",
  xlab = "time"
)
for (r in 1:R) {
  lines(ts[[r]][, 1], col = "blue")
}



## Output is a list containing a (1000 x 5) matrix and a 5 long vector
## containing the true phi values randomly generated to create the
## R many time series.
```
