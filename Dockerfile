# Dockerfile (local source build)

# 1) Base R image
FROM rocker/r-ver:4.5.0

# 2) Install Linux system libraries needed by common R packages
# - Rdpack uses Rd macros (no special syslibs needed)
# - rmarkdown/knitr need pandoc (the rocker images include pandoc via rstudio, but r-ver does not)
#   We'll install pandoc + basic build tools to be safe.
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    pandoc \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 3) Install a dependency resolver. remotes is simple; pak is faster.
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org')"

# 4) Copy your package source into the image
#    Replace `HBEST` with your actual local folder name that contains DESCRIPTION, NAMESPACE, R/, etc.
COPY ~/Documents/R_Projects/HBEST
WORKDIR ~/Documents/R_Projects/HBEST

# 5) Install dependencies from DESCRIPTION
#    dependencies = TRUE includes Depends, Imports, LinkingTo, and Suggests.
#    If you want to EXCLUDE Suggests to keep the image slim, use:
#    dependencies = c('Depends','Imports','LinkingTo')
RUN R -e "remotes::install_deps(dependencies = TRUE, repos='https://cloud.r-project.org')"

# 6) (Optional) Install vignettes (requires knitr, rmarkdown; you already list them in Suggests)
#    If you don’t build vignettes, you can skip these two lines.
# RUN R -e "install.packages(c('knitr','rmarkdown'), repos='https://cloud.r-project.org')"
# RUN R -e "remotes::install_local('.', build_vignettes = TRUE)"

# 7) Install the package from source (without building vignettes)
RUN R -e "install.packages('.', repos=NULL, type='source')"

# 8) Default command when container runs
CMD ["R"]
