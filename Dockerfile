FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04

MAINTAINER amanoese

# upgrade packages and install dependent packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl wget git vim-nox nano build-essential libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-dev libatlas-base-dev python-dev libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler

# set env
ENV CPATH=/usr/local/cuda/include:$CPATH
ENV LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV PATH=$GOPATH/bin:/usr/local/cuda/bin:/root/caffe/build/tools:$PATH
ENV PYTHONPATH=/root/caffe/python:$PYTHONPATH

# nodebrew + nodejs latest
RUN curl -L git.io/nodebrew | perl - setup

ENV PATH $HOME/.nodebrew/current/bin:$PATH
RUN echo export 'PATH=$HOME/.nodebrew/current/bin:$PATH' >> $HOME/.bashrc
RUN . $HOME/.bashrc && nodebrew install latest && nodebrew use latest

#install yarn
RUN apt-get update && apt-get install apt-transport-https -y

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install yarn -y

# install yolo-node
#RUN . $HOME/.bashrc && yarn global add @moovel/yolo

# install ffmpeg
#WORKDIR /tmp

#RUN apt-get -y install software-properties-common \
#    && add-apt-repository ppa:mc3man/trusty-media \
#    && apt-get update \
#    && apt-get install -y --no-install-recommends ffmpeg

WORKDIR /var/app

#ENTRYPOINT . $HOME/.bashrc && node index.js
ENTRYPOINT . $HOME/.bashrc && bash
