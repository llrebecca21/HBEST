# Generate `R`-many conditionally independent MA(4) time series

`generate_MA4()` generates generates `R`-many time series where the
MA(4) coefficients used in the data generation are `(-.3,-.6,-.3,.6)`.
This is based on the MA(4) used in Granados-Garcia et al. (2022) .

## Usage

``` r
generate_MA4(n, R = 1, burn = 50)
```

## Arguments

- n:

  A numeric vector that determines the length of the time series
  generated. Must contain `R`-many entries. Time series may be of
  different lengths.

- R:

  A scalar indicating the number of conditionally independent time
  series to be generated. (default is `1`).

- burn:

  A scalar indicating the amount of burn-in to be used with
  [`stats::arima.sim()`](https://rdrr.io/r/stats/arima.sim.html).
  (default is `50`).

## Value

The function returns a list containing:

|  |  |
|----|----|
| `ts_list` | returns an `R`-long list each containing an `(n` \\\times\\ `1)` matrix of the generated time series. |
| `true_theta` | returns a `(4` \\\times\\ `R)` matrix of true generated MA(4) coefficients. |

## Details

No variation around the base coefficients is used in this data
generation function.

## Examples

``` r
R <- 20
## For time series of different lengths:
n <- c(rep(500, R / 2), rep(800, R / 2))
burn <- 50
ts <- generate_MA4(n = n, R = R, burn = burn)$ts_list

## Returns an R-long list object each with a (500 x 1) matrix object,
## and a (4 x 20) matrix of true MA(4) coefficients - all the same value.

## Plot
## Create an empty plot
plot(
  x = c(),
  y = c(),
  xlim = c(0, 800),
  ylim = range(ts),
  ylab = "",
  xlab = "time"
)
for (r in 1:10) {
  lines(ts[[r]][, 1], col = "blue")
}
for (r in 11:R) {
  lines(ts[[r]][, 1], col = "red")
}
```
