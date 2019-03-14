#!/bin/bash

set -eux

cd $(dirname $0)/..
./scripts/download-weight.sh

docker run -it -v$PWD:/var/app node-yolo bash -c 'npm install && node index.js'
