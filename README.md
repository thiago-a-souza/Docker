# Author
Thiago Alexandre Domingues de Souza

# Containers
Server virtualization is commonly associated with VMWare, but it all started in the 60’s when IBM introduced this concept to allow time-sharing mainframe resources. A few decades later, virtualization became a widespread solution in datacenters to use resources (e.g. CPU, memory, file storage, networking) more efficiently and reduce costs of dedicated servers. Virtualization also enabled isolating different operating systems on the same physical hardware, making it a compelling reason for security purposes, since it gives the illusion of dedicated machines. 

Virtual Machines (VMs) have played a key role to develop monolithic projects, where large and complex systems reside on a single server. Maintaining such complex systems is challenging not only due to increasing requirements and dependencies, but also replicating these changes across lower environments and local copies require a significant effort - and often causes different behaviors among environments, as result of missing or alternative configurations.  In an era that enforces a DevOps culture (e.g. Agile practices, continuous integration, release automation, testing and monitoring), this model represents a major bottleneck.

Today’s applications are based on several loosely coupled components, communicating via a neutral programming language architecture like REST and requiring a different set of dependencies. Running components on different virtual machines is impractical as result of the heavyweight nature of full-blown operating systems. Considering this scenario, containers were created to provide a lightweight solution to make it easier to build and ship applications along with corresponding dependencies in a completely isolated environment.

Three heavyweight VMs running their individual OS on top of a hypervisor (e.g. VMWare, VirtualBox, etc) which runs on top of the  host OS is illustrated in Figure 1(a). Containers, on the other hand, run on top of a Container Engine and each individual container requires only libraries and dependencies needed for their applications. This factor makes containers extremely lightweight and allows running dozens of containers at the same time on the same host [(1)](#references).


<div>
  <table border="0">
    <tr align="center">
      <td>
          <img src="https://github.com/thiago-a-souza/Docker/blob/master/figs/vm.png" height="35%" width="35%"> <br>
          (a)
      </td>
      <td>
        <img src="https://github.com/thiago-a-souza/Docker/blob/master/figs/container.png"  height="40%" width="40%"><br>
	  (b)
      </tr>
  </table>
	<p align="center"> Figure 1: Comparison between VMs and Containers 
		<a href="https://github.com/thiago-a-souza/Docker/blob/master/README.md#references">(1)</a> </p>   

</div>

# Docker
Despite the recent popularity, containers are not a new idea. UNIX introduced the *chroot* command to protect file system resources in the late 70's. In 2008, the LXC (Linux Containers) project introduced a mechanism for running containers on the same kernel, isolating and protecting resources from eight perspectives: PID (process namespace), UTS (host and domain namespace), MNT (mount namespace), IPC (interprocess communication namespace), NET (network namespace), USR (user namespace), *chroot* (changing root directory location) and *cgroups* (limiting resources). In 2013, Docker connected the dots and made it easier to use containers.

Docker provides three fundamental components:

### Docker image
A Docker image contains read-only layers representing file system differences. Layers are stacked on top of each other and have a reference to their parent images - the exception are base images, which have no parent images. Changes can be added only to the top most writable layer, and then can be committed to create a new image. A Docker image composed of layers on top of a base image is illustrated in Figure 2.

<p align="center">
<img src="https://github.com/thiago-a-souza/Docker/blob/master/figs/docker_image.png"  height="40%" width="40%"> <br>
Figure 2: A Docker image <a href="https://github.com/thiago-a-souza/Docker/blob/master/README.md#references">(2)</a> </p> 
</p>


### Docker container
As illustrated in Figure 2, a Docker container is the top most writable layer. Each container has its own layer, so multiple containers of the same image can be created, deleted or modified, without affecting the corresponding image. Using an analogy from object-oriented programming, an image represents a class and a container an instance.

### Docker Hub
A registry is responsible for indexing and distributing images. Docker Hub [(3)](#references) provides thousands of ready-to-use images and it's the default registry used by Docker, but it also supports alternative registries or even your own local registry.   

# Common Docker Commands

Docker provides a lot of commands and arguments for creating, running and managing containers. This section discusses the most frequently used commands. Since Docker is constantly evolving, for a complete and up-to-date reference check out the official documentation [(4)](#references).


## Working with images

- **Docker pull:** downloads an image from Docker Hub

   Downloading the latest ubuntu image:

   ```
   $ docker pull ubuntu
   ```

   Downloading a specific ubuntu image, provided by a tag that refers to the version (trusty):

   ```
   $ docker pull ubuntu:trusty
   ```

- **Docker images:** displays all downloaded images

   ```
   $ docker images
   REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
   ubuntu                         latest              c9d990395902        2 weeks ago         113MB
   ubuntu                         trusty              3b853789146f        2 weeks ago         223MB
   ```

- **Docker tag:** creates an alias to an image, keeping the same image id. Repository and tags can be created from: *docker tag, docker commit* or *docker build -t*

   ```
   $ docker tag ubuntu thiago/my_own_ubuntu:1.0 
   $ docker images
   REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
   ubuntu                         latest              c9d990395902        3 weeks ago         113MB
   thiago/my_own_ubuntu           1.0                 c9d990395902        3 weeks ago         113MB
   ```

- **Docker rmi:** removes an image using their short/long IDs or their names.

   ```
   $ docker rmi c9d
   $ docker rmi ubuntu:trusty
   ```

- **Docker history:** displays the history of an image

   ```
   $ docker history ubuntu:trusty
   IMAGE           CREATED          CREATED BY                                      SIZE         COMMENT
   3b853789146f    2 weeks ago      /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B              
   <missing>       2 weeks ago      /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B              
   <missing>       2 weeks ago      /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$…   2.76kB          
   <missing>       2 weeks ago      /bin/sh -c rm -rf /var/lib/apt/lists/*          0B              
   <missing>       2 weeks ago      /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   195kB           
   <missing>       2 weeks ago      /bin/sh -c #(nop) ADD file:6eca4ad395f3f9986…   223MB   
   ```

- **Docker commit:** creates an image from a container

   Creating an image from a modified container:

   ```
   $ docker run --name myalpine -d alpine touch /test.txt
   $ docker commit myalpine my_username/myalpine_image:my_tag
   ```


- **Docker push:** pushes an image to a registry - Docker Hub is default.

   Creating an image from a modified container and then pushing to Docker Hub:

   ```
   $ docker run  --name my_alpine_container -it alpine mkdir /thiago 
   $ docker commit my_alpine_container your_username/my_alpine_image:1.0
   $ docker push your_username/my_alpine_image:1.0
   ```


## Running containers

- **Docker run:** creates and starts a new container from an image and then run a command - it automatically pulls images not  downloaded previously. 

   Creating/starting a new ubuntu container in interactive mode (*-i* flag) with a TTY attached (*-t* flag):

   ```
   $ docker run -i -t ubuntu:trusty bash
   ```

   Creating/starting a new nginx container in background (*-d* for detached mode) and publishing port 8080 on the host to port 80 in the container (*-p* flag):
 
   ```
   $ docker run -p 8080:80 -d nginx
   b23728f1be217dae795b0277b0dbe47087c48835bdb31c80ec4169a17b877769
   ```

   Removing a new container when it exits:

   ```
   $ docker run -it --rm ubuntu:latest bash
   ```

## Managing containers

- **Docker exec:** runs a command in a running container. It's useful to connect to a container without using SSH.

   Running a command in a running container:

   ```
   $ docker run -d --name myubuntu ubuntu sh -c "while true; do sleep 1; done"
   $ docker exec -it myubuntu echo "hello"
   hello
   ```

   Accessing a running container:

   ```
   $ docker exec -it myubuntu bash
   root@93e384148c5e:/# 
   ```

- **Docker cp:** copies files/directories between a container and a host. It's useful for transfers without using SCP/SFTP.

   Creating a file in the *myubuntu* container and copying to the local host:

   ```
   $ docker exec -it myubuntu touch /arq1.txt
   $ docker cp myubuntu:/arq1.txt .
   ```

   Creating a file in the local host and copying to the *myubuntu* container:

   ```
   $ touch arq2.txt
   $ docker cp arq2.txt myubuntu:/home
   ```

- **Docker ps:** lists containers

   Listing all containers with *-a* flag:

   ```
   $ docker ps -a
   CONTAINER ID   IMAGE   COMMAND                  CREATED          STATUS          PORTS                  NAMES
   b23728f1be21   nginx   "nginx -g 'daemon of…"   15 minutes ago   Up 15 minutes   0.0.0.0:8080->80/tcp   cocky_curie
   ```

- **Docker diff:** displays file system differences between the image and the container

   Creating/starting a new container *myubuntu2* with a new file and checking their differences:

   ```
   $ docker run -d --name myubuntu2 ubuntu touch /testing.txt
   $ docker diff myubuntu2
   A /testing.txt
   ```

- **Docker logs:** shows everything written to STDOUT or STDERR from a container.

   ```
   $ docker run -d --name myubuntu3  ubuntu:latest sh -c "while true ; do  $(echo date);  sleep 1; done"
   $ docker logs -f myubuntu3
   ```

- **Docker port:** lists port mappings for the provided container

   ```
   $ docker run -p 8080:80 --name mynginx -d nginx
   $ docker port mynginx
   80/tcp -> 0.0.0.0:8080
   ```


- **Docker stop:** a container can be stopped by running the *docker stop* command or when main process terminates (normally or not).

   ```
   $ docker stop myubuntu3
   ```

   A container is created/started and when it completes printing "hello world" it stops:

   ```
   $ docker run --name ubuntu_test0 -it ubuntu echo "hello world"
   hello world
   
   $ docker ps -a | grep ubuntu_test0
   0dfb8a1c9f59   ubuntu   "echo 'hello world'"   Less than a second ago   Exited (0) 18 seconds ago   ubuntu_test0
   ```

- **Docker start:** starts a stopped container

   ```
   $ docker start cocky_curie
   cocky_curie
   
   $ docker ps 
   CONTAINER ID   IMAGE   COMMAND                  CREATED          STATUS          PORTS                  NAMES
   b23728f1be21   nginx   "nginx -g 'daemon of…"   15 minutes ago   Up 15 minutes   0.0.0.0:8080->80/tcp   cocky_curie
   ```


- **Docker attach:** *docker start* does not attach the container by default, so *docker attach* can attach the standard input, output and error streams to a running container. A running container can be attached multiple times, but the first session that terminates will stop the container.

   ```
   $ docker run --name ubuntu_test -it ubuntu:trusty bash
   root@de0d734b7b61:/# exit
   exit

   $ docker ps -a 
   CONTAINER ID   IMAGE           COMMAND   CREATED                  STATUS                     PORTS   NAMES
   de0d734b7b61   ubuntu:trusty   "bash"    Less than a second ago   Exited (0) 6 seconds ago           ubuntu_test

   $ docker start ubuntu_test
   ubuntu_test

   $ docker attach ubuntu_test
   root@de0d734b7b61:/#
   ```

- **Docker rm:** removes a container using their short/long IDs or their names

   ```
   $ docker rm ubuntu_test 0df
   ```

## Managing Volumes

Images are appropriate for storing static files like softwares or files that don't change often, so they are ready to be  packaged and distributed without any particular or sensitive information. Volumes enable creating modular architectures by  storing the data separately, outside the application scope. That is particular useful to store database data, log files, input/output data, etc [(5)](#references).


There are two types of volumes: bind and managed. Bind volumes point to the user-provided location on the local host. On the other hand, managed volumes point to a region created and managed by the Docker daemon. Both volume types can be created using the *-v* flag. A colon delimits the host path (left side) and the container path (right side). If the host path is omitted, it creates a managed volume. 


Creating a bind volume of a nginx container:

```
$ docker run --name mynginx -p 8080:80 -v ~/tmp:/usr/share/nginx/html -d nginx 
```

Creating a read-only bind volume by appending *:ro* the mapping:

```
$ docker run --name mynginx2 -p 8081:80 -v ~/tmp:/usr/share/nginx/html:ro -d nginx 
$ docker exec -it mynginx2 touch /usr/share/nginx/html/testing.txt
touch: cannot touch '/usr/share/nginx/html/testing.txt': Read-only file system
```

Creating a managed volume by omitting the host path:

```
$ docker run --name mynginx3 -p 8082:80 -v /usr/share/nginx/html -d nginx 
```

## Dockerfile

Dockerfiles are the best way for creating docker images. A Dockerfile allows automating the build process using a set of shell commands and instructions to  create the final image, making it easier to create and modify them, rather than creating an image from scratch and add dependencies manually. In addition to downloading and installing dependencies, these instructions can expose ports, copy data, run commands, set up users and environment variables, etc. As every instruction represents an image layer, it's recommended to combine instructions whenever possible to minimize the image size and keep the layer count within Docker limits. Another interesting feature about Dockerfiles is that instructions are cached, so it can skip instructions previously successfully executed, saving time to rebuild images.

### Dockerfile instructions

- **FROM:** the first and most important instruction, specifies the base image to create the new image. If a tag is not provided, then it uses latest as default.

   ```
   FROM ubuntu:trusty
   ```

- **RUN:** runs any shell command at the build time. It's recommended to execute multiple commands in a single RUN instruction to reduce the number of image layers. 

   ```
   RUN useradd -m thiago && \
       echo "alias l=\"ls -lrt\"" >> /home/thiago/.bashrc && \
       apt-get update && \
       apt-get install -y git && \
       apt-get clean
   ```

- **CMD:** allows defining a default shell command to be executed when starting up the container. However, the CMD command can be overridden if another command is passed as parameter to the *docker run* command. It's important to note that, Docker ignores multiple CMD instructions and only the last one is executed.

   ```
   CMD echo "hello world!!!"
   ```

- **ENTRYPOINT:** executes the provided command whenever an image is started. Unlike CMD, which is not executed if another command is passed as parameter to *docker run*, the ENTRYPOINT instruction always executes, unless the flag *--entrypoint* is specified to override the default command. The ENTRYPOINT makes the container an executable, terminating the container once the command completes.

   ```
   ENTRYPOINT for i in 3 2 1 ; do echo "Stopping this container in $i second(s)"; sleep 1; done
   ```

- **COPY:** copies files or directories from the host OS to the file system of the new Docker image.

   ```
   COPY my_file.txt /tmp
   ```

- **ADD:** similar to COPY, but also supports tar files and remote URLs. Remark: wget is preferred over ADD to prevent storing unnecessary files in image layers. As a rule of thumb, use COPY whenever possible.

- **ENV:** sets an environment variable in the resulting image

   ```
   ENV PS1 "[\h]@\w> "
   ```

- **USER:** by default, containers start up as root, but the USER instruction allows changing to a specific user name or id.

   ```
   USER nobody
   ```

- **WORKDIR:** changes the current directory to the path provided - useful to run commands from a specific path.

   ```
   WORKDIR /tmp
   ```

- **EXPOSE:** tells Docker that the container listens the specified port at runtime, but it does not publish the port. That way, it's used for documentation purposes. It can set TCP (default) or UDP protocols.

   ```
   EXPOSE 80/tcp
   ```

- **VOLUME:** creates a mount point for the new image.

   ```
   VOLUME /var/log
   ```

### Complete Dockerfile example

Create the Dockerfile:

```
FROM ubuntu:latest 
ENV PS1 "[\h]@\w> "
RUN useradd -m thiago && \
    echo "alias l=\"ls -lrt\"" >> /home/thiago/.bashrc 
USER thiago
WORKDIR /home/thiago
ENTRYPOINT for i in 3 2 1 ; do echo "Stopping this container in $i second(s)"; sleep 1; done
```

Build the image with a tag (*-t* flag):

```
$ docker build -t my_ubuntu:latest .
```

Run a new container:

```
$ docker run --rm -it my_ubuntu
```

## Creating Backups

Containers can be exported as a tar file using the *docker export* command and then imported as images using the *docker import* command. It's important to note that this solution flattens the container's file system into a single layer, losing all metadata, history, etc. Alternatively, an image (not a container) can be saved into a tar file with all metadata using the *docker save* and then restored with *docker load*. As result of that, a *docker export* produces a smaller tar file compared to the *docker save*.

Exporting a container as an image and importing the produced image:

```
docker run --name myalpine2 -d alpine touch /test_file.txt
docker export myalpine2 > myalpine2.tar
docker import myalpine2.tar myalpine_imported
```

Saving and loading and image:

```
docker run --name myalpine2 -d alpine touch /test_file.txt
docker commit myalpine2 myalpine2_image
docker save myalpine2_image > myalpine2_image.tar
docker rmi myalpine2_image
docker load < myalpine2_image.tar
```



# References

(1) Mouat, Adrian. Using Docker: Developing and deploying software with containers. O'Reilly Media, Inc., 2015.

(2) Chelladhurai, Jeeva S et al. Learning Docker. Packt Publishing Ltd, 2017.

(3) Docker Hub - https://hub.docker.com/

(4) Docker reference documentation - https://docs.docker.com/reference/

(5) Nickoloff, Jeff. Docker in action. Manning Publications Co., 2016.



