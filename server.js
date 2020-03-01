const express = require('express');
const multer = require('multer');
const app = express();
const fs = require('fs');
var bodyParser = require('body-parser');
const { TesseractWorker } = require('tesseract.js');
const worker = new TesseractWorker({
    logger: m => console.log(m)
});
//var textract = require('textract');

//middlewares
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json());

const PORT = process.env.PORT | 5000;

var Storage = multer.diskStorage({
  destination: (req, file, callback) => {
    callback(null, './Images');
  },
  filename: (req, file, callback) => {
    callback(null, file.originalname);
  }
});

var upload = multer({
  storage: Storage
}).single('image');

app.set("view engine", "ejs");

//route
app.get('/', (req, res) => {
    res.render('index');
  });
// app.get("/", (req, res) => {
//     res.sendFile(__dirname + "/index.html");
// });

app.post('/upload', function(req, res) {
  upload(req, res, err => {
    fs.readFile(`./Images/${req.file.originalname}`, (err, data)=> {
    if (err) {
      console.log(err);
      return res.end('Something went wrong');
}
    worker.recognize(data, "eng", {tessjs_create_pdf: '1'})
             .progress(progress => {
                 console.log(progress)
             })
    .then(result => {
        res.send(result.text);
    })
    .finally(() => worker.terminate());
        
    });
  });
});

// app.get('/showdata', (req, res) => {
//     var image = fs.readFileSync(
//         __dirname + req.file.filename,
//         {
//           encoding: null
//         }
//       );

//       textract.fromFileWithPath('/seca2.png', function( error, text ) {console.log(text)})
//     //   Tesseract.recognize(image)
//     //   .progress(function(p) {
//     //     console.log('progress', p);
//     //   })
//     //     .then(function(result) {
//     //       res.end(result.html);
//     //     });

// });



app.listen(PORT, () => {
  console.log(`Server running on Port ${PORT}`);
});