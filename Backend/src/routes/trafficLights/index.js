const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const createError = require('http-errors');

// this is the model we'll be using
let trafficLight = mongoose.model('TrafficLight');

// Here we are using promises to have only one error handler
// when doing mongoose queries

module.exports = router

  .get('/', (req, res, next) => {
    trafficLight.find().exec()
      .then((t) => {
        res.send(t);
      }).catch(err => {
        console.log(err);
        next(err);
      });
  })

  .get('/findByLatLon/:latitude?:longitude?', (req, res, next) => {
    let lat = Number(req.query.latitude);
    let lon = Number(req.query.longitude);

    trafficLight.findOne({'coordinates.latitude': lat, 'coordinates.longitude': lon}).exec()
      .then((found) => {
        console.log(found);
        if(found) {
          res.send(found);
        }
        else throw new createError(400, 'Traffic light does not exist!');
      }).catch((err) => {
        console.log(err);
        next(err);
      })
  })

  .post('/', (req, res, next) => {
    let tempTF = new trafficLight(req.body);
    trafficLight.findOne({'coordinates': tempTF.coordinates}).exec()
      .then((found) => {
        if (found) {
          throw new createError(400, 'Traffic light already exists!');
        }
        return tempTF.save();
      }).then((savedTF) => {
        res.send (savedTF);
      })
      .catch((err) => {
        console.log(err);
        next(err);
      })
  })
