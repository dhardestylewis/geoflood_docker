FROM dhardestylewis/taudem_docker:tacc

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

ENV DEBIAN_FRONTEND noninteractive
ENV DATA_DIR /data

RUN apt update -q && \
    apt install \
        -q \
        -y \
        --no-install-recommends \
        --fix-missing \
        --no-install-suggests \
        build-essential \
        libblas-dev \
        libbz2-dev \
        libcairo2-dev \
        libfftw3-dev \
        libfreetype6-dev \
        libgdal-dev \
        libgeos-dev \
        libglu1-mesa-dev \
        libgsl0-dev \
        libjpeg-dev \
        liblapack-dev \
        libncurses5-dev \
        libnetcdf-dev \
        libopenjp2-7 \
        libopenjp2-7-dev \
        libpdal-dev pdal \
        libpdal-plugin-python \
        libpng-dev \
        libpq-dev \
        libproj-dev \
        libreadline-dev \
        libsqlite3-dev \
        libtiff-dev \
        libxmu-dev \
        libzstd-dev \
        bison \
        flex \
        g++ \
        gettext \
        gdal-bin \
        language-pack-en-base \
        libfftw3-bin \
        make \
        ncurses-bin \
        netcdf-bin \
        proj-bin \
        proj-data \
        sqlite3 \
        subversion \
        unixodbc-dev \
        zlib1g-dev \
        python3-distutils && \
#        grass \
#        grass-doc \
#        grass-dev && \
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p $DATA_DIR

CMD [ "/bin/bash" ]

ARG GEOFLOOD_VERSION=tacc
ARG CONDA_ENV_GEOFLOOD=geoflood
ARG CONDA_ENV_GRASS=grass

RUN wget \
        https://raw.githubusercontent.com/dhardestylewis/geoflood_docker/${GEOFLOOD_VERSION}/environment-${CONDA_ENV_GEOFLOOD}.yml \
        -O /opt/${CONDA_ENV_GEOFLOOD}.yml && \
    wget \
        https://raw.githubusercontent.com/dhardestylewis/geoflood_docker/${GEOFLOOD_VERSION}/environment-${CONDA_ENV_GRASS}.yml \
        -O /opt/${CONDA_ENV_GRASS}.yml && \
    conda clean -y -a && \
    conda env create -f /opt/${CONDA_ENV_GEOFLOOD}.yml && \
    conda clean -y -a && \
    conda env create -f /opt/${CONDA_ENV_GRASS}.yml && \
    conda clean -y -a && \
    rm /opt/*.yml && \
    echo '. $(which env_parallel.bash)' >> ~/.bashrc && \
    echo "conda activate geoflood" >> ~/.bashrc

RUN echo LANG="en_US.UTF-8" > /etc/default/locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN mkdir /code
RUN mkdir /code/grass

COPY . /code/grass

WORKDIR /code/grass

ENV MYCFLAGS "-O2 -std=gnu99 -m64"
ENV MYLDFLAGS "-s"
ENV LD_LIBRARY_PATH "/usr/local/lib"
ENV LDFLAGS "$MYLDFLAGS"
ENV CFLAGS "$MYCFLAGS"
ENV CXXFLAGS "$MYCXXFLAGS"

ENV NUMTHREADS=2
RUN conda activate grass && \
    ./configure \
        --enable-largefile \
        --with-cxx \
        --with-nls \
        --with-readline \
        --with-sqlite \
        --with-bzlib \
        --with-zstd \
        --with-cairo \
        --with-cairo-ldflags=-lfontconfig \
        --with-freetype \
        --with-freetype-includes="/usr/include/freetype2/" \
        --with-fftw \
        --with-netcdf \
        --with-pdal \
        --with-proj \
        --with-proj-share=/usr/share/proj \
        --with-geos=/usr/bin/geos-config \
        --with-postgres \
        --with-postgres-includes="/usr/include/postgresql" \
        --with-opengl-libs=/usr/include/GL && \
    make -j $NUMTHREADS && \
    make install && \
    ldconfig

RUN ln -s /usr/local/bin/grass* /usr/local/bin/grass

RUN apt autoremove -y && \
    apt clean -y

ENV SHELL /bin/bash

RUN chmod -R a+rwx $DATA_DIR

RUN useradd -m -U grass

VOLUME $DATA_DIR
WORKDIR $DATA_DIR

RUN rm -rf /code/grass

USER grass

CMD ["/usr/local/bin/grass", "--versoin"]

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

