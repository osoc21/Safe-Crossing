const mongoose = require('mongoose');
const objectId = mongoose.Types.ObjectId;

const trafficLightSchema = new mongoose.Schema
({
  id: objectId,
  latitude: 0,
  longitude: 0,
  state: String,
  duration: 0
});

module.exports = mongoose.model('TrafficLight', trafficLightSchema);
