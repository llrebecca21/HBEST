# RStudio Server base (includes RStudio, default port 8787)
FROM rocker/rstudio:4.5.0

# System libs and pandoc (required for HTML vignette rendering)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
    pandoc git build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install remotes and vignette packages
RUN R -e "install.packages(c('remotes','knitr','rmarkdown'), repos='https://cloud.r-project.org')"

# Copy your package into the image
WORKDIR /app/HBEST
COPY . /app/HBEST

# Install dependencies declared in DESCRIPTION (Imports + Suggests)
RUN R -e "remotes::install_deps(dependencies = TRUE, repos='https://cloud.r-project.org')"

# Install the package and BUILD VIGNETTES (HTML via rmarkdown + pandoc)
RUN R -e "remotes::install_local('.', build_vignettes = TRUE)"

# Documented port for RStudio
EXPOSE 8787
