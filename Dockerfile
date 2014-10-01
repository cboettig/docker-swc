## Emacs, make this -*- mode: makefile; -*-
## Provides RStudio-server on 8787 and IPython-notebooks on 8888

FROM eddelbuettel/debian-rstudio
MAINTAINER Carl Boettiger cboettig@ropensci.org

## Remain current
RUN apt-get update -qq \
&& apt-get dist-upgrade -y

## Packages 
RUN apt-get install -y --no-install-recommends python ipython \
ipython-notebook python-matplotlib python-numpy python-scipy \
python-statsmodels git sqlite3 

## More packages from: https://gist.github.com/jiffyclub/5512074
RUN apt-get install -y --no-install-recommends nano gcc gedit make \
mercurial nano subversion vim emacs dkms r-cran-plyr r-cran-reshape2 \
r-cran-ggplot2 r-cran-rcurl r-cran-xml 


# iPython Notebook port
EXPOSE 8888
## We need a modifed supervisord.conf to run ipython on the container 
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## Create a user 
RUN adduser --disabled-password --gecos '' swc
RUN adduser swc sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown swc:swc /var/log/supervisor 
USER swc
WORKDIR /home/swc

## To have a container run multiple & persistent tasks, we use the very simple supervisord as recommended in Docker documentation.
ENTRYPOINT ["/usr/bin/sudo"]
CMD ["/usr/bin/supervisord"] 



