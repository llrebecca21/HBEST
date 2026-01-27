# A sampling algorithm for HBEST

`HBEST` is an MCMC algorithm that samples parameter values for HBEST.

## Usage

``` r
HBEST(
  ts_list,
  B,
  iter,
  burnin,
  sigmasquared_glob = 100,
  sigmasquared_loc = 0.1,
  nu_tau = 2,
  tausquared = 10,
  nu_zeta = 5,
  zeta_min = 1.001,
  zeta_max = 15,
  tau_min = 0.001,
  tau_max = 100,
  num_gpts = 1000
)
```

## Arguments

- ts_list:

  A list `R` long containing the vectors of the stationary time series
  of potentially different lengths.

- B:

  An integer specifying the number of basis coefficients (not including
  the intercept basis coefficient \\\beta_0\\).

- iter:

  An integer specifying the number of iterations for the MCMC algorithm
  embedded in this function.

- burnin:

  An integer specifying the burn-in to be removed at the end of the
  sampling algorithm.

- sigmasquared_glob:

  A scalar specifying the variance of the prior
  (N(0,`sigmasquared_glob`)) intercept term for \\\beta^{glob}\_0\\.
  (default is `100` to ensure a diffuse prior).

- sigmasquared_loc:

  A scalar specifying the variance of the prior
  (N(0,`sigmasquared_loc`)) intercept term for \\\beta^{loc}\_0\\.
  (default is `0.1`).

- nu_tau:

  A scalar indicating the degrees of freedom for the prior on \\\tau\\.
  (default is `2`).

- tausquared:

  A scalar used as the initial value of `tausquared` that controls the
  global smoothing effect. (default is `10`).

- nu_zeta:

  A scalar indicating the degrees of freedom for the prior on \\\zeta\\.
  (default is `5`).

- zeta_min:

  A scalar controlling the smallest value \\\zeta\\ can take. So,
  `zeta_min`^2 is the smallest value `zetasquared` can take. (default is
  `1.001`).

- zeta_max:

  A scalar controlling the largest value \\\zeta\\ can take. So,
  `zeta_max`^2 is the largest value that `zetasquared` can take.
  (default is `15`).

- tau_min:

  A scalar controlling the smallest value \\\tau\\ can take. So,
  `tau_min`^2 is the smallest value `tausquared` can take. (default is
  `0.001`).

- tau_max:

  A scalar controlling the largest value \\\tau\\ can take. So,
  `tau_max`^2 is the largest value `tausquared` can take. (default is
  `100`).

- num_gpts:

  A scalar controlling the denseness of the grid during the sampling of
  both `tausquared` and `zetasquared`. (default is `1000`).

## Value

A list object with components:

|                   |                                                                                                          |
|-------------------|----------------------------------------------------------------------------------------------------------|
| `beta_loc_est`    | returns a `(iter - burnin` \\\times\\ `B+1` \\\times\\ `R)` array of \\\beta^{loc}\_{br}\\ estimates.    |
| `beta_glob_est`   | returns a `(iter - burnin` \\\times\\ `B+1)` array of \\\beta^{glob}\_{b}\\ estimates.                   |
| `zetasquared_est` | returns a `(iter - burnin` \\\times\\ `R)` array of \\\zeta^{2}\_{r}\\ estimates.                        |
| `tausquared_est`  | returns a `(iter - burnin` \\\times\\ `1)` array of \\\tau^{2}\\ estimates.                              |
| `perio_list`      | returns an `R` list of column matrices each storing a truncated/half periodogram.                        |
| `omega`           | returns an `R` list of column matrices each storing \\\omega\_{j}\\ see paper in references for details. |
| `D`               | returns a `B` vector that stores the prior variance for \\\beta\_{1}\\ through \\\beta\_{B}\\.           |

## References

Lee R, Coulter A, Siegle GJ, Bruce SA, Bhattacharya A (2025).
“Hierarchical Bayesian spectral analysis of multiple stationary time
series.”
[doi:10.48550/ARXIV.2511.19406](https://doi.org/10.48550/ARXIV.2511.19406)
, Version Number: 1, <https://arxiv.org/abs/2511.19406>.

## Examples

``` r
# To view the full explanation and examples, run:
if (FALSE) { # \dontrun{
vignette("HBEST_tutorial", package = "HBEST")} # }
```
