FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04

MAINTAINER amanoese

# upgrade packages and install dependent packages
## for https://hub.docker.com/r/ww24/deep-learning/dockerfile/
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl wget git vim-nox nano build-essential libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-dev libatlas-base-dev python-dev libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler

# set env
ENV CPATH=/usr/local/cuda/include:$CPATH
ENV LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV PATH=$GOPATH/bin:/usr/local/cuda/bin:/root/caffe/build/tools:$PATH
ENV PYTHONPATH=/root/caffe/python:$PYTHONPATH

RUN apt-get install -y imagemagick python-pip python-numpy python-opencv gfortran && \
    pip install --upgrade pip scipy pydot

# nodebrew + nodejs latest
RUN curl -L git.io/nodebrew | perl - setup

ENV PATH=$HOME/.nodebrew/current/bin:$PATH

RUN echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> $HOME/.bash_profile
RUN . $HOME/.bash_profile && nodebrew install latest && nodebrew use latest

#install yarn
RUN apt-get update && apt-get install apt-transport-https -y

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install yarn -y

## install darknet and darknet.js
RUN git clone https://github.com/bennetthardwick/darknet.js.git /var/darknet
WORKDIR /var/darknet

ARG OPENMP=1
ARG GPU=0
ARG CUDNN=0

ENV DARKNET_BUILD_WITH_OPENMP=$OPENMP
ENV DARKNET_BUILD_WITH_GPU=$GPU
ENV DARKNET_BUILD_WITH_CUDNN=$CUDNN
RUN . $HOME/.bash_profile && npm install && ./install-script.sh

WORKDIR /var/app

#ENTRYPOINT
RUN echo '#!/bin/bash      \n\
set -eux                   \n\
. $HOME/.bash_profile      \n\
exec "$@"                  \n\
' >> /docker-entrypoint.sh

RUN chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

## CMD
CMD bash
