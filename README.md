# Dockerfile for GeoFlood

*TauDEM's InunMap & CatchHydroGeo is supported and compiles successfully by this Dockerfile.*

This [Dockerfile](https://github.com/dhardestylewis/geoflood_docker/blob/main/Dockerfile) and [dhardestylewis/taudem_docker](https://github.com/dhardestylewis/taudem_docker)'s [Dockerfile](https://github.com/dhardestylewis/taudem_docker/blob/main/Dockerfile) can be used as line-by-line
installation instructions for TauDEM and GeoFlood's software dependencies.

*Note*: this GeoFlood Docker image does not contain a copy of GeoFlood itself. This image provides
the software dependencies to GeoFlood. It will be necessary to separately install GeoFlood, whether
within a GeoFlood container or separately on the host computer.

The general installation steps to get GeoFlood going:
- Pull the GeoFlood Docker image
- Clone the GeoFlood repository
- Initiate a GeoFlood container, mounting the location of the GeoFlood repository and the parent GeoFlood input/output directories
- Run GeoFlood and TauDEM functions from within the GeoFlood container


**The following instructions are for Docker. Instructions for Singularity are be
low**.

*Note*: In these instructions, we assume the current working directory ($PWD) contains the cloned GeoFlood repository and the parent GeoFlood input/output directories.

GeoFlood commands may be run as one-off commands using this Docker image using the
 following shell command as a template:

```
docker run --name geoflood_bash --rm -i -t --mount type=bind,sour
ce="$(pwd)",target="/mnt/host" dhardestylewis/geoflood_docker python3 pygeonet_nonlinear_filter.py
fel.tif
```

or multiple GeoFlood commands may be run in sequence bringing up the Docker image 
once for all commands using the following shell command as a template:

```
docker run --name geoflood_bash --rm -i -t --mount type=bind,source="$(pwd)
",target="/mnt/host" dhardestylewis/geoflood_docker bash geoflood_commands.sh
```

where `geoflood_commands.sh` is written according to this template:

```
#!/bin/bash
python3 pygeonet_nonlinear_filter.py
```


**Singularity instructions.**

The Singularity pull command is similar to the Docker pull command:

```
singularity pull \
    --name geoflood.sif \
    docker://dhardestylewis/geoflood_docker:latest
```

Once pulled, a one-off GeoFlood command using Singularity can be issued:

```
singularity exec \
    geoflood.sif \
    python3 pygeonet_nonlinear_filter.py
```

An interactive shell in the Singularity container may be used for troubleshooting or debugging:

```
singularity exec \
    geoflood.sif \
    bash
```


**GeoFlood combined with other commands in a shell script**


*Note*: In these instructions, we assume the current working directory ($PWD) contains the cloned GeoFlood repository and the parent GeoFlood input/output directories.

GeoFlood may be wrapped in a shell script and run using Docker:

```
docker run \
    --name geoflood_bash \
    --rm \
    -i \
    -t \
    dhardestylewis/geoflood_docker:latest \
    --mount type=bind,source="$(pwd)",target="/mnt/host" \
    bash -c './geoflood_commands.sh'
```

where the file `geoflood_commands.sh` may be written as:

```
#!/bin/bash

## Execute GeoFlood
python3 pygeonet_nonlinear_filter.py
```

To do the same using Singularity, execute:

```
singularity exec \
    geoflood.sif \
    bash -c './geoflood_commands.sh'
```    

where `geoflood_commands.sh` is written as above.



