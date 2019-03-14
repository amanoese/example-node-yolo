// import { Darknet } from 'darknet';
const { Darknet } = require('darknet');
const fs = require('fs')
const crypto = require('crypto');
const Canvas = require('canvas')
 
console.log(__dirname)
// Init
let darknet = new Darknet({
    weights: __dirname + '/data/yolov3.weights',
    config: __dirname + '/data/yolov3.cfg',
    namefile: __dirname + '/data/coco.names'
});

let filename = __dirname + '/data/img.jpg'

console.log(darknet.detect(filename));

let data = fs.readFileSync(filename)

// データをcanvasのcontextに設定
var img = new Canvas.Image();
img.src = data;

console.log(img, 0, 0, img.width, img.height);

var canvas = Canvas.createCanvas(img.width, img.height);
var ctx = canvas.getContext('2d');
ctx.drawImage(img, 0, 0, img.width, img.height);

let strToMd5Hex = text => crypto.createHash('md5').update(text).digest('hex')

darknet.detect(filename).map(({ name, box : {x,y,w,h} })=>{
  let stroke_x = x - (w / 2)
  let stroke_y = y - (h / 2)

  ctx.strokeStyle = '#' + strToMd5Hex(name).slice(-6).toUpperCase()
  ctx.lineWidth = 5;
  ctx.strokeRect(stroke_x ,stroke_y, w,h);

  let font_size = 20
  ctx.fillStyle = '#' + strToMd5Hex(name).slice(-6).toUpperCase()
  ctx.font = `600 ${font_size}px sans-serif`
  ctx.fillRect(stroke_x ,stroke_y, ctx.measureText(name).width,font_size + font_size / 4 );

  ctx.fillStyle = "rgb(255, 255, 255)";
  ctx.fillText(name,stroke_x,stroke_y + font_size)
})

const out = fs.createWriteStream(__dirname + '/out.png')
const stream = canvas.createPNGStream()
stream.pipe(out)
out.on('finish', () =>  console.log('The PNG file was created.'))
