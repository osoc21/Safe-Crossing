const express = require('express');
const router = express.Router();
const createError = require('http-errors');
const dataRoutes = require('./data');

router.get('/', (req, res, next) => {
  res.send('Server works!');
});

router.use('/data', dataRoutes);

module.exports = router;
