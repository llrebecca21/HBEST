
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HBEST

<!-- badges: start -->

<!-- badges: end -->

`HBEST` is an `R` package that implements the nonparametric hierarchical
Bayesian spectral analysis method known as HBEST. The details of this
method can be found in Lee et al. (2025). A detailed example using the
function `HBEST()` can be found in the vignette.

A GitHub Pages static site is available to preview the documentation and
vignettes: [GitHub Page](https://llrebecca21.github.io/HBEST/).

The GitHub repository contains a Dockerfile to allow users familiar with
Docker to run RStudio in a local browser with `HBEST` already installed.

## RStudio Installation

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
slightly faster implementation. Both functions are made available to
users since `HBEST()` is the code used in the publication Lee et al.
(2025). The vignette `HBEST_tutorial` contains a simple walk through of
the `HBEST()` function. The data generation functions are also available
to users and details of these functions can be found in the vignette
`Data_generation_tutorial`.

## Docker Instructions

This section will walk through the steps of how to: install Docker
Desktop (if user does not already have it installed); download the
package repository; build the Docker image locally; run the container;
open RStudio in a browser; and access the package and vignettes.

The steps below are described for MAC and Windows OS. Where steps
differ, a note has been made.

### Download Docker Desktop

If you do not already have Docker Desktop installed on your local
computer, you can download the installer at:

- [Windows
  users](https://docs.docker.com/desktop/setup/install/windows-install/)

- [Mac](https://docs.docker.com/desktop/setup/install/mac-install/)

For Windows users, during installation ensure WSL 2 backend is enabled
when prompted.

Restart your computer if prompted and start Docker Desktop.

In your terminal (Mac) or PowerShell (Windows) check that docker is
installed:

``` bash
docker --version
```

The links above walk through local installation of Docker Desktop and
must be completed prior to the next steps. The creators of this project
will not assist in technical issues that may arise with Docker Desktop
installation or use.

### Download Package Repository from GitHub

Assuming the user has already installed Docker/Docker Desktop on their
local computer (only needs to be installed once), one can follow these
steps to build and run a local Docker Container so that RStudio can be
run through a browser with HBEST and other dependent libraries already
installed.

1.  Download or clone the **entire** zipped repository `HBEST` from
    <https://github.com/llrebecca21/HBEST>, i.e., Code \> Download Zip.
    Save the zipped `HBEST` folder to someplace you can navigate to
    easily with terminal commands.

For Windows users you *must* unzip the folder before moving to the next
step.

2.  In your local terminal or PowerShell, navigate to where the unzipped
    repository folder is saved. i.e.,

``` bash
cd yourfilepath
```

replace `yourfilepath` above with your file path.

3.  Check you are in the correct directory.

``` bash
ls
```

You are in the correct directory if you see the items:

- Dockerfile
- DESCRIPTION
- R/
- vignettes/

### Build the local Docker Image

4.  Build the Docker image locally:

``` bash
docker build -t hbest-rstudio .
```

This may take a couple of minutes. This step copies the package source
into the container, installs all dependencies, and builds the vignettes.

The build was successful if you see `* DONE (HBEST)`.

### Run the Docker Container

5.  Run the container:

Run the following code below. It is IMPORTANT to change the *changeme*
to a password you will remember. If you want to use the Docker container
for creating a volume to have files saved after container stops, you
will need to adjust the run commands shown below. This is left for the
user to investigate.

The code below will allow the user to have a container that persists
(can restart the container again).

In terminal (Mac) or PowerShell (Windows- remove the `\` to avoid
errors):

``` bash
docker run -d\
  --name hbest-rs \
  -p 8787:8787 \
  -e PASSWORD=changeme \
  hbest-rstudio
```

### Open the Connection to RStudio

6.  Open **Docker Desktop** and find the container running `hbest-rs`,
    click the port link `8787:8787`. It is important that you are using
    a browser that supports http connections. If the port 8787 is
    already taken on your local computer, you will need to go into the
    Dockerfile and modify the last line `EXPOSE 8787` to another port
    number.

7.  Login to RStudio with:

`username: rstudio`

`password: the password you created when running step 4 above.`

You will need to login everytime you run the container.

8.  Check the package is installed by running the following code in the
    RStudio session:

``` r
library(HBEST)
# Call the help page for the HBEST function
?HBEST::HBEST
```

You can also view vignettes:

``` r
vignette("HBEST_tutorial")
# or
vignette("Data_generation_tutorial")
```

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-lee_hierarchical_2025" class="csl-entry">

Lee, Rebecca, Alexander Coulter, Greg J. Siegle, Scott A. Bruce, and
Anirban Bhattacharya. 2025. “Hierarchical Bayesian Spectral Analysis of
Multiple Stationary Time Series.” arXiv.
<https://doi.org/10.48550/ARXIV.2511.19406>.

</div>

</div>
