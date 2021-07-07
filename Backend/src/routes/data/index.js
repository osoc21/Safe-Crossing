const express = require('express');
const router = express.Router();
const createError = require('http-errors');
const multer = require('multer');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'src/python_tools/uploads');
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  }
})

const upload = multer({ storage: storage });

module.exports = router

  .get('/', (req, res, next) => {
    res.send('This is the Data route in the API!');
  })

  .post('/', upload.single('image'), (req, res, next) => {
    // req.file is the `image` file
    // req.body will hold the text fields, if there were any

    console.log(JSON.stringify(req.file));
    res.send('Image uploaded!');
  });
