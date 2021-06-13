FROM dhardestylewis/taudem_docker:tacc

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

RUN apt update -q && \
    apt install -q -y --no-install-recommends --fix-missing \
        grass \
        grass-doc \
        grass-dev && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

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

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

