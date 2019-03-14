#!/bin/bash

set -eux

cd $(dirname $0)/..

mkdir -p data
cd data

wget -nc https://pjreddie.com/media/files/yolov3.weights
wget -nc https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3.cfg
wget -nc https://raw.githubusercontent.com/pjreddie/darknet/master/data/coco.names

wget -nc https://github.com/pjreddie/darknet/raw/master/data/dog.jpg
