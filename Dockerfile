###########################################
## Docker file to build corba omniORB-4.2.4
## Based on Miniconda 3
###########################################

FROM continuumio/miniconda3:latest as corba-omniorb-4.2.4-base

#Install gcc
RUN apt update
RUN apt install build-essential -y

COPY ./corba-omniorb/omniORB.cfg /etc/omniORB.cfg
COPY ./corba-omniorb/omniMapper.cfg /etc/omniMapper.cfg
ADD ./corba-omniorb/omniORB-4.2.4.tar.gz /tmp/omniORB-4.2.4
ADD ./corba-omniorb/omniORBpy-4.2.4.tar.gz /tmp/omniORBpy-4.2.4

# build and install c++ libraries first
RUN cd /tmp/omniORB-4.2.4/omniORB-4.2.4 && \
    mkdir build && cd build && \
    ../configure --prefix=/opt/conda && \
    make && make install

#build install python libraries
RUN cd /tmp/omniORBpy-4.2.4/omniORBpy-4.2.4 && \
    mkdir build && cd build && \
    ../configure --prefix=/opt/conda && \
    make && make install

#set dynamic library path
ENV LD_LIBRARY_PATH=/opt/conda/lib

#incase of omninames use
RUN mkdir /var/omninames