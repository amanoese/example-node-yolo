FROM ww24/deep-learning

MAINTAINER amanoese

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

#compile darknet
RUN git clone https://github.com/OrKoN/darknet /var/darknet
WORKDIR /var/darknet
RUN sed -i -e 's/GPU=./GPU=1/' -e 's/OPENCV=./OPENCV=1/' -e 's/OPENMP=./OPENMP=1/' Makefile
RUN make && make OPENCV=1 OPENMP=1 && make install

# install yolo-node
RUN . $HOME/.bashrc && yarn global add @moovel/yolo

# install ffmpeg
WORKDIR /tmp

RUN apt-get -y install software-properties-common \
    && add-apt-repository ppa:mc3man/trusty-media \
    && apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg

WORKDIR /var/app

ENTRYPOINT . $HOME/.bashrc && node index.js
