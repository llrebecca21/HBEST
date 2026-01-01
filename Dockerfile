
# RStudio Server base (includes RStudio, default port 8787)
FROM rocker/rstudio:4.5.0

# System libs your package/deps may need
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
    pandoc git build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install package dependencies and your package from local source
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org')"

# Copy your package into the image
WORKDIR /app/HBEST
COPY . /app/HBEST

# Install dependencies declared in DESCRIPTION (Imports/Suggests)
RUN R -e "remotes::install_deps(dependencies = TRUE, repos='https://cloud.r-project.org')"

# Install the package from source
RUN R -e "install.packages('.', repos=NULL, type='source')"

# EXPOSE is optional; it's documentation only
EXPOSE 8787

