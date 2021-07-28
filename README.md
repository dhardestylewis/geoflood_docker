# Dockerfile for GeoFlood



**The following instructions are for Docker. Instructions for Singularity are be
low**.

GeoFlood commands may be run as one-off commands using this Docker image using the
 following shell command as a template:

```
docker run --name geoflood_bash --rm -i -t --mount type=bind,sour
ce="$(pwd)",target="/mnt/host" dhardestylewis/geoflood_docker:tacc python3 pygeonet_nonlinear_filter.py
fel.tif
```

or multiple GeoFlood commands may be run in sequence bringing up the Docker image 
once for all commands using the following shell command as a template:

```
docker run --name geoflood_bash --rm -i -t --mount type=bind,source="$(pwd)
",target="/mnt/host" dhardestylewis/geoflood_docker:tacc bash geoflood_commands.sh
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
    docker://dhardestylewis/geoflood_docker:tacc
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

GeoFlood may be wrapped in a shell script and run using Docker:

```
docker run \
    --name geoflood_bash \
    --rm \
    -i \
    -t \
    dhardestylewis/geoflood_docker:tacc \
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



