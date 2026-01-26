
# -------------------------------------------------------------------
# HBEST RStudio Server Docker Image (multi-arch compatible)
# Works on macOS (Intel/Apple Silicon) and Windows via Docker Desktop
# -------------------------------------------------------------------

FROM rocker/rstudio:4.5.0

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# System dependencies for common R packages and vignette building
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    pandoc \
    git \
    build-essential \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Base R packages used to install deps and build vignettes
RUN R -e "install.packages(c('remotes','knitr','rmarkdown'), repos='https://cloud.r-project.org')"

# Set working directory and copy your R package source
WORKDIR /app/HBEST
COPY . /app/HBEST

# Install package dependencies (Imports + Suggests) from DESCRIPTION
RUN R -e "remotes::install_deps(dependencies = TRUE, repos='https://cloud.r-project.org')"

# Install your package and build vignettes (HTML using rmarkdown + pandoc)
RUN R -e "remotes::install_local('.', build_vignettes = TRUE)"

# Run RStudio Server as non-root for better security
USER rstudio

# RStudio Server port
EXPOSE 8787
