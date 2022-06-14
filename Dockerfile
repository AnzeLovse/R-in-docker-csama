FROM rocker/rstudio:4.2.0

# Provide metadata about the image.
LABEL name="example" \
      version="1.0.0" \
      url="https://github.com/AnzeLovse/reprodicible-R-csama" \
      maintainer="myname@email.com" \
      description="Description of my image" \
      license="MIT"

# Install system depencencies and clean up unnecessary files afterwards.
# For demonstration purposes we will install build-essentials although
# they are not required. When creating a real image, you should remove
# unnecessary packages with apt-get remove.
RUN apt-get update && \
    apt-get install -y \
        build-essential \
    && apt-get clean all && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Install renv which will be used to install other R packages.
RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"

# Copy the list of R packages to be installed to the container.
COPY r-packages.txt var/r-packages.txt

# Use the list of R packages to install them.
# The list of R packages contains comments lines and we will remove them
# with sed before passing them to renv::install.
RUN sed -e 's/^#.*$//g' -e '/^$/d' var/r-packages.txt | \
    Rscript --slave --no-save --no-restore-history -e \
    "options(repos = c(CRAN = 'https://cloud.r-project.org')); \
    renv::install(readLines('stdin'))"
