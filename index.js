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

let filename = __dirname + '/img.jpg'

console.log(darknet.detect(filename));

let data = fs.readFileSync(filename)

// データをcanvasのcontextに設定
var img = new Canvas.Image();
img.src = data;

console.log(img, 0, 0, img.width, img.height);

var canvas = Canvas.createCanvas(img.width, img.height);
var ctx = canvas.getContext('2d');
ctx.drawImage(img, 0, 0, img.width, img.height);

darknet.detect(filename).map(({ name, box : {x,y,w,h} })=>{
  let stroke_x = x - (w / 2)
  let stroke_y = y - (h / 2)

  ctx.strokeStyle = "rgb(200, 0, 0)";
  ctx.lineWidth = 5;
  ctx.strokeRect(stroke_x ,stroke_y, w,h);

  let font_size = 20
  ctx.fillStyle = "rgb(200, 0, 0)";
  ctx.font = `600 ${font_size}px sans-serif`
  ctx.fillRect(stroke_x ,stroke_y, ctx.measureText(name).width,font_size + font_size / 4 );

  ctx.fillStyle = "rgb(255, 255, 255)";
  ctx.fillText(name,stroke_x,stroke_y + font_size)
})

const out = fs.createWriteStream(__dirname + '/out.png')
const stream = canvas.createPNGStream()
stream.pipe(out)
out.on('finish', () =>  console.log('The PNG file was created.'))
