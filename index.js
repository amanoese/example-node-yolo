// import { Darknet } from 'darknet';
const { Darknet } = require('darknet');
const fs = require('fs')
const Canvas = require('canvas')
 
console.log(__dirname)
// Init
let darknet = new Darknet({
    weights: __dirname + '/yolov3.weights',
    config: __dirname + '/yolov3.cfg',
    namefile: __dirname + '/coco.names'
});

let filename = __dirname + '/img_01.jpg'
console.log(darknet.detect(filename));

let data = fs.readFileSync(filename)

// データをcanvasのcontextに設定
var img = new Canvas.Image();
img.src = data;

var canvas = Canvas.createCanvas(img.width, img.height);
var ctx = canvas.getContext('2d');
ctx.drawImage(img, 0, 0, img.width, img.height);

darknet.detect(filename).map(({ name, box : {x,y,w,h} })=>{
 ctx.strokeStyle = "rgb(200, 0, 0)";
 ctx.strokeRect(x,y,w,h);
 ctx.fillText(name,x,y)
})

const out = fs.createWriteStream(__dirname + '/out.png')
const stream = canvas.createPNGStream()
stream.pipe(out)
out.on('finish', () =>  console.log('The PNG file was created.'))
