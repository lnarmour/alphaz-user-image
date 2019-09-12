## Run AlphaZ from a docker container

This process details how to run an Eclipse instance from within a docker container.

> **NOTE**: You need root/administrator privileges to do the following.  These steps have only been tested on Mac and Linux but the concepts still hold true for Windows.

### Setup

1. Install Docker.
    1. Mac or Windows: use Docker Desktop
        1. https://docs.docker.com/docker-for-mac/install/
        1. https://docs.docker.com/docker-for-windows/install/
    1. Linux: use Docker Server Community Edition (CE)
        1. https://docs.docker.com/v17.12/install/#server
2. Start the Docker daemon, see the getting start guides if needed:
    1. https://docs.docker.com/docker-for-mac/
    1. https://docs.docker.com/docker-for-windows/
3. Grab the latest `alphaz-user-image` image from docker hub with the command:
   ``` 
   $ docker pull narmour/alphaz-user-image:latest
   ```
   
   It may take a few minutes to download the image since it's ~1GB in size.  Once this is complete, you should be able to see it locally on your machine with the following command:
   ``` 
   $ docker images
   REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
   narmour/alphaz-user-image   latest              5d01e8e8a169        3 days ago          1.03GB
   ``` 

### Quick overview of docker

There are **images** and there are **containers**. An image is static, it's just bits in a file. A container is a running image.

Think of a container as an isolated and segmented system with its own runtime and file system.  Processes run within a container have no knowledge that they are in a container and by default, the state of a container only persists as long as the container exists (whether it is running or not).  When the container is removed, any new files created within the container are also removed.

However, when running a container you can create mount points between the file system within the container and the host machine on which the container is running. For example, one way to run a container is:
```
$ docker run -v /host/file/path:/home/userA my-cool-image
```  

This mounts the file path inside the container called `/home/userA`, onto the file path on the host called `/host/file/path`.  If a process running in the container then writes to a file in the directory `/home/userA`, then that write will persist even after the container is stopped and removed.

When the `alphaz-user-image` image is started with the provided `run.sh` script, the default Eclipse workspace is mounted outside the container like this. The idea being that you may want your code changes to persist but everything about the runtime infrastructure to be independently restartable.


### Run the alphaz-user-image

##### Verify that your host can do X11 forwarding

* Mac: 
  * If you're using a Mac for example, make sure the application **XQuartz** is installed.  If not, then install it from here: https://www.xquartz.org/
  * Edit XQuartz > Preferences > Security > enable the "Allow Connections From Network Clients" setting 

* Windows:
  > **NOTE**: This part is untested at the moment, you'll need to do some troubleshooting to get it to work in the current state of things. But free Windows applications like MobaXterm should support X11 forwarding. 

##### Run the container

If you're using Mac or Linux, then just invoke the provided `run.sh` script.  If everything is working then you should see Eclipse start up successfully.

Now you can pick up with the rest of the AlphaZ documentation from here: https://www.cs.colostate.edu/AlphaZ/wiki/doku.php 