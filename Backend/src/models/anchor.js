// Pozyx anchor model
const mongoose = require('mongoose');

const anchorSchema = new mongoose.Schema
({
  _id: { type : String, required: true},
  anchorPos: {
    x: 0,
    y: 0,
    z: 0
  }
});

module.exports = mongoose.model('Anchor', anchorSchema);
