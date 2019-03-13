#!/bin/sh

cd $(dirname $0)

wget -nc https://pjreddie.com/media/files/yolov3.weights
wget -nc https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3.cfg
wget -nc https://raw.githubusercontent.com/pjreddie/darknet/master/data/coco.names

