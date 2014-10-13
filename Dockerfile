## Emacs, make this -*- mode: makefile; -*-
## Provides RStudio-server on 8787 and IPython-notebooks on 8888

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

## We need a modifed supervisord.conf to run ipython on the container 
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## Create a user 
RUN adduser --disabled-password --gecos '' swc

## Give user sudo privileges and write access to create log files
RUN adduser swc sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown swc:swc /var/log/supervisor 
RUN chown swc:swc /usr/bin/ipython

# Expose the iPython Notebook port
EXPOSE 8888

## Switch to user and working directory
WORKDIR /home/swc

## To have a container run multiple & persistent tasks, we use 
## the very simple supervisord as recommended in Docker documentation.
CMD ["/usr/bin/supervisord"] 


