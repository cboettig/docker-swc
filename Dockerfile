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

## Adapted from https://github.com/ipython/docker-notebook ##
VOLUME /notebooks
WORKDIR /notebooks
EXPOSE 8888

## You can mount your own SSL certs as necessary here
ENV PEM_FILE /key.pem
# $PASSWORD will get `unset` within notebook.sh, turned into an IPython style hash
ENV PASSWORD Dont make this your default

ADD notebook.sh /usr/bin/notebook.sh
RUN chmod u+x /usr/bin/notebook.sh


############## 

## To have a container run multiple & persistent tasks, we use 
## the very simple supervisord as recommended in Docker documentation.
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"] 


