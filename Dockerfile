FROM ubuntu:22.04
ARG USERNAME=wayming
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DEBIAN_FRONTEND=noninteractive
ENV HOME /home/${USERNAME}

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3-pip
ENV SHELL /bin/bash


RUN apt-get install software-properties-common -y
RUN add-apt-repository universe
RUN apt-get update && apt-get install curl -y && apt-get install wget -y

#gazebo simulator
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update -y
RUN apt-get install ignition-fortress -y
#RUN apt-get install ros-humble-turtlebot4-simulator -y

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
COPY ./myrobot.sdf $HOME/myrobot.sdf


CMD ["/bin/bash"]