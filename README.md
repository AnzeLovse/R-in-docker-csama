# Making your R analyses more reproducible

## Putting an end to "It works on my machine"

This short guide aims to help you make your R analyses more reproducible and inspire you to integrate Docker in your workflow. Why even bother with Docker?

Have you ever had to run your R analysis on a machine that is not yours or tried to run the same analysis after a few months? Doing your analysis in an isolated environment makes it easier to share it with you colleagues, rerun it later and work across different operating systems.

If you have not heard about Docker yet, it allows you to package an application and its dependencies in a virtual container that can run on almost any operating system. The two crucial components of a Docker container are the image and the container. The image is the software packaged in the container and is used to store the application. The container is the actual virtual machine that runs the image and forms an encapsulated environment. For more information about Docker, check out the [Docker documentation](https://docs.docker.com/).

Since R is best coupled with RStudio, we will use it in our example. Conveniently the [Rocker Project](https://www.rocker-project.org/) provides Docker containers for the R Environment, and they have an RStudio image available.

## Three steps to get you up and running

1. Make sure you have Docker installed on your machine. Otherwise, follow the [official guide](https://docs.docker.com/install/) to install it.
2. Download (pull) the Docker image:

   ```docker pull rocker/rstudio:4.2.0```

3. Run the container:

    ```
    docker run --rm \  # Remove the container when it exits.
        --name my-r-studio \  # Use a recognizable name.
        -p 127.0.0.1:8787:8787 \  # Map the port 8787 to the host port 8787.
        --env PASSWORD=password \  # Set up a password for the RStudio server.
        --volume local/data:container/path \  # Map the local directory to the container path.
        rocker/rstudio:4.2.0
    ```

    The container will be running on port 8787. You can access it by opening a browser and typing http://localhost:8787. Login with: username `rstudio` and the selected password. If you are doing this on your private machine, you can use use `--env DISABLE_AUTH=true` to avoid authentication.

You can now follow your usual RStudio workflow. If you have installed packages and want to use them later, you can use `docker commit my-r-studio my/rstudio:1.0.0`. Even though this is a convenience command, it is not recommended to use to share the code as it lacks transparency.

## Building your own Docker image

Docker images are created from Docker files which contain the instructions to build the image. This makes the whole process more transparent because we know which packages and files are included in the image. An example Docker file is saved in this repository as [Dockerfile](Dockerfile). In the demonstration we will set up an environment with RStudion and `edgeR` package installed.

In the Docker file we have specified `FROM` which image to start from. We have also specified `RUN` commands which will be executed when the image is created and install the system dependencies and R packages. To make installing packages easier we have also specified `COPY` command which will copy the list of required packages and install them using [renv](https://rstudio.github.io/renv/articles/renv.html) package manager. Finally some metadata is added to the image using the `LABEL` command.

The image can be built using the `docker build` command.

```
docker build . -t example:1.0.0
```

This guide is far from exhaustive, but I hope it will be enough to get you up and running with Docker. For more additional information, check out other resources on the topic.

Official resources
- Getting started with Docker https://docs.docker.com/get-started/
- Manuals on the https://www.rocker-project.org/
- Docker guide on Bioconductor http://bioconductor.org/help/docker/


Community creators
- Dave Tang’s blog with tips and tricks https://davetang.org/muse/2021/04/24/running-rstudio-server-with-docker/
- Roman Lustrik’s post on pinned versions https://biolitika.si/pin-r-package-versions-using-docker-and-renv.html


