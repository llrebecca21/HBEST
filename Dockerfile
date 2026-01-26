# -------------------------------------------------------------------
# HBEST RStudio Server Docker Image
# Multi-architecture compatible (amd64 + arm64)
# -------------------------------------------------------------------

# Use a pinned, multi-arch RStudio Server base image
FROM rocker/rstudio:4.5.0

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies required for R packages and vignettes
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    pandoc \
    git \
    build-essential \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install R packages needed to install dependencies and build vignettes
RUN R -e "install.packages( \
    c('remotes','knitr','rmarkdown'), \
    repos = 'https://cloud.r-project.org' \
  )"

# Set working directory for your package
WORKDIR /app/HBEST

# Copy the package source into the image
COPY . /app/HBEST

# Install package dependencies (Imports + Suggests)
RUN R -e "remotes::install_deps( \
    dependencies = TRUE, \
    repos = 'https://cloud.r-project.org' \
  )"

# Install the package and build vignettes
RUN R -e "remotes::install_local('.', build_vignettes = TRUE)"

# IMPORTANT: run RStudio Server as the non-root 'rstudio' user
USER rstudio

# RStudio Server listens on port 8787
EXPOSE 8787
