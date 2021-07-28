const express = require('express');
const router = express.Router();
const createError = require('http-errors');
const anchorRoutes = require('./anchors');
const mongoose = require('mongoose');
const trafficLightRoutes = require('./trafficLights');

// this is the model we'll be using
let trafficLight = mongoose.model('TrafficLight');

router.get('/', (req, res, next) => {
  res.sendFile('Server works!');
});

router.use('/anchors', anchorRoutes);
router.use('/trafficLights', trafficLightRoutes);

module.exports = router;
