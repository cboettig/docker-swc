## Emacs, make this -*- mode: makefile; -*-
## Provides RStudio-server on 8787 and IPython-notebooks on 8888

## Run in deamon mode for RStudio or unencrypted ipython:
##     docker run -d -p 8787:8787 8888:8888 swc

## For encrypted ipython, run an interactive bash shell (still exporting port 8888),
## and run `setup_ipython_notebook`, then run `ipython notebook`
##     docker run --rm -it -p 8888:8888 swc bash
##     setup_ipython_notebook
##     ipython notebook 


FROM rocker/rstudio
MAINTAINER Carl Boettiger cboettig@ropensci.org

## Packages 
RUN apt-get update && apt-get install -y --no-install-recommends \ 
    ipython \
    ipython-notebook \
    python \
    python-matplotlib \
    python-numpy \
    python-scipy \
    python-statsmodels \
    sqlite3 

## Additional packages as recommended from: https://gist.github.com/jiffyclub/5512074
RUN apt-get update && apt-get install -y --no-install-recommends \
    emacs \
    dnsutils \
    dkms \
    gcc \
    gedit \
    make \
    mercurial \
    nano \
    subversion \
    r-cran-ggplot2 \
    r-cran-plyr \
    r-cran-rcurl \ 
    r-cran-reshape2 \
    r-cran-xml \ 
    vim 

COPY setup_ipython_notebook.sh /usr/bin/setup_ipython_notebook
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## Create a user 
RUN adduser --disabled-password --gecos '' swc
RUN adduser swc sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown swc:swc /var/log/supervisor 
RUN chown swc:swc /usr/bin/ipython

# Expose the iPython Notebook port. 8787 already exposed for RStudio
EXPOSE 8888

## Switch to user and working directory
WORKDIR /home/swc

## To have a container run multiple & persistent tasks, we use 
## the very simple supervisord as recommended in Docker documentation.
CMD ["/usr/bin/supervisord"] 


