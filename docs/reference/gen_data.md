# Time-series data generation wrapper function

`data_gen()` is a wrapper function for various time-series data
generation methods. This is used to call one of six methods that
generates data in the structure required for simulations for
[`HBEST()`](https://llrebecca21.github.io/HBEST/reference/HBEST.md) or
[`HBEST_fast()`](https://llrebecca21.github.io/HBEST/reference/HBEST_fast.md).

## Usage

``` r
gen_data(gen_method, ...)
```

## Arguments

- gen_method:

  Method of data generation to use. Options include `ARp`, `AR1vary`,
  `AR2mix`, `MA4`, `MA4vary`, and `MA4varyType2`.

- ...:

  further arguments, passed to chosen method. See details below.

## Value

returns the appropriate objects based on the method chosen. See help
pages for each function for more details.

## Details

Available data generation methods include:

|                |                                                                                                                                                                                                                                       |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ARp`          | calls the [`generate_AR()`](https://llrebecca21.github.io/HBEST/reference/generate_AR.md) function which is based on [stats::arima.sim](https://rdrr.io/r/stats/arima.sim.html).                                                      |
| `AR1vary`      | calls the [`generate_AR1_vary()`](https://llrebecca21.github.io/HBEST/reference/generate_AR1_vary.md) function which is based on [stats::arima.sim](https://rdrr.io/r/stats/arima.sim.html).                                          |
| `AR2mix`       | calls the [`generate_AR2_mixture()`](https://llrebecca21.github.io/HBEST/reference/generate_AR2_mixture.md) function which is based on [stats::arima.sim](https://rdrr.io/r/stats/arima.sim.html) and (Granados-Garcia et al. 2022) . |
| `MA4`          | calls the [`generate_MA4()`](https://llrebecca21.github.io/HBEST/reference/generate_MA4.md) function which is based on [stats::arima.sim](https://rdrr.io/r/stats/arima.sim.html).                                                    |
| `MA4vary`      | calls the [`generate_MA4_vary()`](https://llrebecca21.github.io/HBEST/reference/generate_MA4_vary.md) function which is based on [stats::arima.sim](https://rdrr.io/r/stats/arima.sim.html).                                          |
| `MA4varyType2` | calls the [`generate_MA4_varyType2()`](https://llrebecca21.github.io/HBEST/reference/generate_MA4_varyType2.md) function which is based on [stats::arima.sim](https://rdrr.io/r/stats/arima.sim.html).                                |

## Examples

``` r
## Other examples can be found in the vignette `Data_generation_tutorial`
R <- 20
n <- rep(500, R)
burn <- 50

## `ARp` method:
ts <- gen_data(
  gen_method = "ARp",
  phi = c(0.5),
  n = n,
  R = R,
  burn = burn
)

## `AR1vary` method:
ts <- gen_data(
  gen_method = "AR1vary",
  n = n,
  R = 5,
  min = 0.45,
  max = 0.6,
  burn = burn
)

## `AR2mix` method:
R <- 20
n <- c(rep(300, 10),
       rep(800, 10)
  )
peaks1 <- runif(R, min = 0.2, max = 0.23)
bandwidths1 <- runif(R, min = .1, max = .2)
peaks2 <- runif(R,
                min = (pi * (2 / 5)) - 0.1,
                max = (pi * (2 / 5)) + 0.1)
bandwidths2 <- rep(0.15, R)
peaks <- rbind(peaks1, peaks2)
bandwidths <- rbind(bandwidths1, bandwidths2)
ts <- gen_data(
  gen_method = "AR2mix",
  peaks = peaks,
  bandwidths = bandwidths,
  n = n
)

## `MA4` method:
n <- rep(500, R)
ts <- gen_data(
  gen_method = "MA4",
  n = n,
  R = R,
  burn = burn
)

## `MA4vary` method:
n <- rep(500, R)
alpha <- 0.05
ts <- gen_data(
  gen_method = "MA4vary",
  n = n,
  R = R,
  burn = burn,
  alpha = alpha
)

## `MA4varyType2` method:
n <- rep(500, R)
ts <- gen_data(
  gen_method = "MA4varyType2",
  n = n,
  R = R,
  burn = burn,
  alpha = alpha
)
```
