FROM nvidia/cuda:11.4.2-cudnn8-runtime-ubuntu20.04

# to skip questions/dialogs during apt-get install
ARG DEBIAN_FRONTEND=noninteractive

#dockerizing ssh https://dev.to/s1ntaxe770r/how-to-setup-ssh-within-a-docker-container-i5i
#create a user called duckie and add it to the sudo group; sets the password for the user duckie to duckduck
#start the ssh service and listen on port 22 
RUN apt update && apt install  openssh-server sudo -y
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 duckie  
RUN  echo 'duckie:duckduck' | chpasswd
RUN echo 'root:duckduck' | chpasswd
RUN service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

#https://github.com/duckietown/gym-duckietown/blob/daffy/docker/standalone/Dockerfile
RUN apt-get update -y && apt-get install -y  \
    freeglut3-dev \
    python3.6 \
    python3-pip \
    python3-numpy \
    python3-scipy \
    wget curl vim git \
    nano \
    xvfb \
    && \
    rm -rf /var/lib/apt/lists/*
    
#copy gym-duckietown to container   |  #git clone https://github.com/duckietown/gym-duckietown.git #cd gym-duckietown
WORKDIR /home/duckie/gym-duckietown
COPY gym-duckietown/. .

#WORKDIR /gym-duckietown/src
RUN pip3 install pyglet==1.5.15
RUN python3 --version
#RUN python3 -c "from gym_duckietown import *"

#----NOTE for me-------
#workdir: changes folder in the dockercontainer
#copy : COPY <src-path(host)> <destination-path (dockercontainer)>
