FROM rocker/rstudio:4.2.0

LABEL name="example" \
      version="1.0.0" \
      url="https://github.com/AnzeLovse/reprodicible-R-csama" \
      maintainer="myname@email.com" \
      description="Description of my image" \
      license="MIT"

RUN apt-get update && \
    apt-get install -y \
        build-essential \
    && apt-get clean all && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"

COPY r-packages.txt var/r-packages.txt

RUN sed -e 's/^#.*$//g' -e '/^$/d' var/r-packages.txt | \
    Rscript --slave --no-save --no-restore-history -e \
    "options(repos = c(CRAN = 'https://cloud.r-project.org')); \
    renv::install(readLines('stdin'))"
