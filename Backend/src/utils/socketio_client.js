// CommonJS
const io = require("socket.io-client"),
  ioClient = io.connect("http://localhost:3000");

  ioClient.emit('run script');

  ioClient.emit('stop script');

  ioClient.on("message", (data) => console.log(data));