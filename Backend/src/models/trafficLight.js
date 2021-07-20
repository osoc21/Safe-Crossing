const mongoose = require('mongoose');
const objectId = mongoose.Types.ObjectId;

const trafficLightSchema = new mongoose.Schema
({
  id: objectId,
  coordinates: {
    latitude: 0,
    longitude: 0
  },
  pozyx: {
    x: 0,
    y: 0
  },
  state: String,
  duration: 0
});

module.exports = mongoose.model('TrafficLight', trafficLightSchema);
