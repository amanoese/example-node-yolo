example-node-yolo
===

For High Power of Sakura Internet Cloud.

## install (On GPU)

Setup Docker host with GPU

```bash
## if you have using curl 
$ bash <(curl -s https://raw.githubusercontent.com/amanoese/example-node-yolo/master/install)

##if you have using wget 
$ bash <(wget https://raw.githubusercontent.com/amanoese/example-node-yolo/master/install -nv -O-)
```

Build darknet container if you using GPU
```bash
$ docker build -t node-yolo . --build-arg GPU=1
```

## install (Using CPU)

Build darknet container if you using CPU
```bash
$ docker build -t node-yolo .
```
