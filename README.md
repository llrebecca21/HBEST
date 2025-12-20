
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HBEST

<!-- badges: start -->

<!-- badges: end -->

`HBEST` is an `R` package that implements the nonparametric hierarchical
Bayesian spectral analysis method known as HBEST. The details of this
method can be found in Lee et al. (2025). A detailed example using the
function `HBEST()` can be found in the vignette.

## Installation

You can install the development version of HBEST from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("llrebecca21/HBEST")
```

``` r
library(HBEST)
```

## Functions

This package contains user functions `HBEST()` and `HBEST_fast()`. Both
functions implement the same method, but the `HBEST_fast()` function has
slightly faster implementation. The data generation functions are also
available to users and details of these functions can be found in the
vignette.

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-lee_hierarchical_2025" class="csl-entry">

Lee, Rebecca, Alexander Coulter, Greg J. Siegle, Scott A. Bruce, and
Anirban Bhattacharya. 2025. “Hierarchical Bayesian Spectral Analysis of
Multiple Stationary Time Series.”
<https://doi.org/10.48550/ARXIV.2511.19406>.

</div>

</div>
