// import { Darknet } from 'darknet';
const { Darknet } = require('darknet');
const fs = require('fs')
const Canvas = require('canvas')
 
console.log(__dirname)
// Init
let darknet = new Darknet({
    weights: __dirname + '/yolov3-tiny.weights',
    config: __dirname + '/yolov3-tiny.cfg',
    namefile: __dirname + '/coco.names'
});

let filename = __dirname + '/dog.jpg'
console.log(darknet.detect(filename));

let data = fs.readFileSync(filename)

// データをcanvasのcontextに設定
var img = new Canvas.Image();
img.src = data;

console.log(img, 0, 0, img.width, img.height);

var canvas = Canvas.createCanvas(img.width, img.height);
var ctx = canvas.getContext('2d');
ctx.drawImage(img, 0, 0, img.width, img.height);

for (let i = 0; i <img.width; i+=100){
 ctx.strokeStyle = "rgb(0, 0, 200)";
 ctx.strokeRect(i,0,i,img.height);
}
let scaleX =  416 /img.width
let scaleY = 416 / img.height

darknet.detect(filename).map(({ name, box : {x,y,w,h} })=>{
 ctx.strokeStyle = "rgb(200, 0, 0)";
 ctx.strokeRect(x * scaleX,y * scaleY, w * scaleX,h * scaleY);
 ctx.fillText(name,x,y)
})

const out = fs.createWriteStream(__dirname + '/out.png')
const stream = canvas.createPNGStream()
stream.pipe(out)
out.on('finish', () =>  console.log('The PNG file was created.'))
