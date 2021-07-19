module.exports = (req, res, next) => {
  //
  try {
    const createError = require('http-errors');
    const { PythonShell } = require('python-shell');

    const options = {
      scriptPath: '../Pozyx/',
    };

    let data = {};
    let parsedJson = {};
    const pyScript = new PythonShell('pozyx_mqtt_simulation.py', options);

    console.log('before pyScript');
    //res.set('Content-Type', 'application/json');
    //res.sendFile(__dirname + '/index.html');

    pyScript.on('message', (message) => {
      // console.log('during pyScript');
      parsedJson = JSON.parse(message);
      data.id = parsedJson[0].tagId;
      data.coordinates = {};
      data.coordinates.long = parsedJson[0].data.coordinates.x;
      data.coordinates.lat = parsedJson[0].data.coordinates.y;
      // console.log(data);
      res.write(JSON.stringify(data));
      res.write('\r\n');
      //req.io.emit('chat message', data);
    });

    // end the input stream and allow the process to exit
    pyScript.end((err, code, signal) => {
      if (err) throw new createError(500, err);

      console.log('The exit code was: ' + code);
      console.log('The exit signal was: ' + signal);
      console.log('finished');
    });
    console.log('after pyScript');

    //res.end(JSON.stringify(data));
  } catch (err) {
    console.log(err);
    next(err);
  }
};
