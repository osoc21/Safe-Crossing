const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const createError = require('http-errors');
// multer will help us upload multipart/form-data
// more info at https://github.com/expressjs/multer
const multer = require('multer');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'src/python_tools/uploads');
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  }
});

const upload = multer({ storage: storage });

// this is the model we'll be using
const anchor = mongoose.model('Anchor');

module.exports = router

  .get('/', (req, res, next) => {
    res.send('This is the Data route in the API!');
  })
    console.log(JSON.stringify(req.file));
    res.send('Image uploaded!');
  })

  .get('/getAnchors', (req, res, next) => {
    anchor.find().exec()
      .then((t) => {
        res.send(t);
      }).catch(err => {
        console.log(err);
        next(err);
      });
  })

  .post('/postAnchor', (req, res, next) => {
    let tempAnchor = new anchor(req.body);
    anchor.findOne({anchorPos: tempAnchor.anchorPos}).exec()
      .then((found) => {
        if (found) {
          throw new createError(400, 'This pozyx anchor already exists!');
        }
        return tempAnchor.save();
      }).then((savedAnchor) => {
        res.send (savedAnchor);
      })
      .catch((err) => {
        console.log(err);
        next(err);
      })
  });
