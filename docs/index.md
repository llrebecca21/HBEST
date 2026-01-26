# HBEST

`HBEST` is an `R` package that implements the nonparametric hierarchical
Bayesian spectral analysis method known as HBEST. The details of this
method can be found in Lee et al. (2025). A detailed example using the
function
[`HBEST()`](https://llrebecca21.github.io/HBEST/reference/HBEST.md) can
be found in the vignette.

The GitHub repository contains a Dockerfile to allow users to run
RStudio in a local browser with `HBEST` already installed.

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

This package contains user functions
[`HBEST()`](https://llrebecca21.github.io/HBEST/reference/HBEST.md) and
[`HBEST_fast()`](https://llrebecca21.github.io/HBEST/reference/HBEST_fast.md).
Both functions implement the same method, but the
[`HBEST_fast()`](https://llrebecca21.github.io/HBEST/reference/HBEST_fast.md)
function has slightly faster implementation. Both functions are made
available to users since
[`HBEST()`](https://llrebecca21.github.io/HBEST/reference/HBEST.md) is
the code used in the publication Lee et al. (2025). The vignette
`HBEST_tutorial` contains a simple walk through of the
[`HBEST()`](https://llrebecca21.github.io/HBEST/reference/HBEST.md)
function. The data generation functions are also available to users and
details of these functions can be found in the vignette.

## Docker Instructions

Assuming the user has already installed Docker/Docker Desktop on their
local computer, one can follow these steps to build and run a local
Docker Container so that RStudio can be run through a browser with HBEST
and other dependent libraries already installed.

1.  Download the **entire** zipped repository `HBEST` from
    <https://github.com/llrebecca21/HBEST>, i.e., Code \> Download Zip.
    Save the zipped `HBEST` folder to someplace you can navigate to
    easily with terminal commands.

2.  In your local terminal, navigate to where the repository folder is
    saved. i.e., `cd yourfilepath`

3.  Run: `docker build -t hbest-rstudio .` to build the Docker container
    locally. This may take a couple of minutes.

4.  Run the following code below and it is IMPORTANT to change the
    *changeme* to a password you will remember.

``` bash
docker run -d \
  --name hbest-rs \
  -p 8787:8787 \
  -e PASSWORD='changeme' \
  hbest-rstudio
```

5.  Open Docker Desktop and find the container running `hbest-rs`, click
    the port link `8787:8787`. It is important that you are using a
    browser that supports http connections. If the port 8787 is already
    taken on your local computer, you will need to go into the
    Dockerfile and modify the last line `EXPOSE 8787` to another port
    number.

6.  Login to RStudio with:

`username: rstudio`

`password: the password you created when running step 4 above.`

7.  Check the package is installed by running:

``` r
library(HBEST)
# Call the help page for the HBEST function
?HBEST::HBEST
```

Lee, Rebecca, Alexander Coulter, Greg J. Siegle, Scott A. Bruce, and
Anirban Bhattacharya. 2025. “Hierarchical Bayesian Spectral Analysis of
Multiple Stationary Time Series.” arXiv.
<https://doi.org/10.48550/ARXIV.2511.19406>.
