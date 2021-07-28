const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const createError = require('http-errors');

// this is the model we'll be using
const anchor = mongoose.model('Anchor');

module.exports = router

  .get('/', (req, res, next) => {
    anchor.find().exec()
      .then((t) => {
        res.send(t);
      }).catch(err => {
        console.log(err);
        next(err);
      });
  })

  .post('/', (req, res, next) => {
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
