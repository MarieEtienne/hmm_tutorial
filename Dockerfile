FROM rocker/geospatial:latest
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y pandoc \
    pandoc-citeproc
RUN R -e "install.packages(c('tidyverse','wesanderson','lubridate','rmarkdown', 'stringr','tinytex','RefManageR'))"
RUN R -e "install.packages(c('car', 'emmeans'))"
RUN R -e "install.packages(c('bibtex'))"
RUN R -e "install.packages('FactoMineR')"
RUN R -e "remotes::install_github('yihui/xaringan')"
RUN R -e "remotes::install_github('gadenbuie/xaringanExtra')"
RUN R -e "remotes::install_github('EvaMaeRey/flipbookr')"
RUN R -e "install.packages(c('palmerpenguins'))"
RUN R -e "install.packages(c('cowplot'))"
RUN R -e "install.packages(c('ggpubr'))"
RUN R -e "install.packages('GGally')"
RUN R -e "install.packages('gganimate')"
RUN R -e "install.packages('plotly')"
RUN R -e "install.packages('magick')"
RUN R -e "install.packages('ggfortify')"
RUN R -e "install.packages('CircStats')"
RUN R -e "remotes::install_github('MarieEtienne/coursesdata')"
RUN R -e "install.packages('moveHMM')"
RUN R -e "install.packages('animation')"
RUN R -e "install.packages('kableExtra')"





