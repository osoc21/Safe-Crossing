// this 'requires' all the models (mongoose Schemas) we created in the model directory
require('./models');

const express = require('express');
const bodyParser = require('body-parser');
const createError = require('http-errors');
const routes = require('./routes');
const cors = require('cors');
const callPythonScript = require('./utils/call_python_script.js');

// Mongoose setup
const mongoose = require('mongoose');
const dotenv = require('dotenv').config();
const dbUrl = process.env.DB_URL;
mongoose.Promise = global.Promise
// Mongoose setup

// TODO: setup mongoose
const app = express();
const port = 3000;
const http = require('http');
const server = http.createServer(app);
const socketIO = require('socket.io');
const io = socketIO(server);

// Mongoose connection
if(!dbUrl) {
  console.log('Please insert DB_URL in .env file');
  process.exit();
}
// establish connection with the database
mongoose.connect(dbUrl,{ useNewUrlParser: true, useUnifiedTopology: true });
mongoose.connection.on("open", (ref) => {
  console.log("Connected to mongodb server");
});
// Mongoose connection

io.on('connection', (main_socket) => {
  console.log('a user connected!');
  main_socket.on('disconnect', () => {
    console.log('user disconnected');
  });

  main_socket.on('run script', (socket) => {
    callPythonScript(main_socket);
  });
});

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

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`http://localhost:${port}/`);
});

//error handler
app.use((err, req, res, next) => {
  res.status(err.status || 500);
  res.json(err.message);
});

module.exports = app;
