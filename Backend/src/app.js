const express = require('express');
const bodyParser = require('body-parser');
const createError = require('http-errors');
const routes = require('./routes');
const cors = require('cors');
// TODO: setup mongoose

const app = express();
const port = 3000;

// bodyparser parses the request body and transforms it into a js object for easy operation
app.use(bodyParser.json({}));
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(cors({origin: "*"}));

// router
app.use('/api', routes);

// catch 404 and forward to error handler
app.use((req, res, next) => {
  next(createError(404));
});

//error handler
app.use((err, req, res, next) => {
  res.status(err.status || 500);
  res.json(err.message);
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`http://localhost:${port}/`);
});

module.exports = app;
