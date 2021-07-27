const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const createError = require('http-errors');

// this is the model we'll be using
const trafficLight = mongoose.model('TrafficLight');

module.exports = router

  .get('/', (req, res, next) => {
    trafficLight.find().exec()
      .then((t) => {
        res.send(t);
      })
      .catch(err => {
        console.log(err);
        next(err);
      });
  })

  .get('/findByLatLon/:latitude?:longitude?', (req, res, next) => {
    if (!req.query.latitude || !req.query.longitude)
    {
      throw new createError(400, 'Required query params missing');
    }

    let lat = Number(req.query.latitude);
    let lon = Number(req.query.longitude);

    trafficLight.findOne({'coordinates.latitude': lat, 'coordinates.longitude': lon}).exec()
      .then((found) => {
        console.log(found);
        if(found) {
          res.send(found);
        }
        else throw new createError(400, 'Traffic light does not exist!');
      })
      .catch((err) => {
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

  .put('/:id', (req, res, next) => {
    let tempTF = new trafficLight(req.body);
    trafficLight.findById(req.params.id).exec()
      .then((found) => {
        if(!found) throw new createError(400, "Couldn't find traffic light: " + req.params.id);

        if(tempTF.coordinates.latitude != undefined)
          found.coordinates.latitude = tempTF.coordinates.latitude;

        if(tempTF.coordinates.longitude != undefined)
          found.coordinates.longitude = tempTF.coordinates.longitude;

        if(tempTF.pozyx.x != undefined)
          found.pozyx.x = tempTF.pozyx.x;

        if(tempTF.pozyx.y != undefined)
          found.pozyx.y = tempTF.pozyx.y;

        if(tempTF.state != undefined)
          found.state = tempTF.state;

        if(tempTF.duration != undefined)
          found.duration = tempTF.duration;

        return found.save();
      })
      .then((updatedTF) => {
        res.json(updatedTF);
      })
      .catch((err) => {
        console.log(err);
        next(err);
      })
  });
