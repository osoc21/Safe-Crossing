module.exports = (socket) => {
  //
  try {
    console.log('running python script');
    const createError = require('http-errors');
    const { PythonShell } = require('python-shell');
    const jsonFile = './Pozyx/pozyx_kit_info.json';
    const mongoose = require('mongoose');
    const trafficLight = mongoose.model('TrafficLight');
    let tmp = {};

    //  Available PythonShell options:
    //  let options = {
    //    mode: 'text',
    //    pythonPath: 'path/to/python',
    //    pythonOptions: ['-u'], // get print results in real-time
    //    scriptPath: 'path/to/my/scripts',
    //    args: ['value1', 'value2', 'value3']
    //    };

    const options = {
      scriptPath: './Pozyx/',
      args: [jsonFile],
    };

    const pyScript = new PythonShell('pozyx_localize.py', options);

    socket.on('stop script', (socket) => {
      console.log('stop python script');
      return;
    });

    // we get what the python script prints
    // if it's not 'null' then it's a traffic light id
    // we then search that traffic light in the mongodb database and
    // send the status of the traffic light (red or green) to the frontend
    pyScript.on('message', (message) => {
      console.log(message);
      if (message != 'Not Close') {
        trafficLight
          .findById(message, 'state')
          .exec()
          .then((state) => {
            // tmp.id = message;
            // tmp.state = state;
            socket.emit('pozyx_data', state.state);
          })
          .catch((err) => {
            console.log('Null');
          });
      } else {
        socket.emit('pozyx_data', message);
      }
    });

    // end the input stream and allow the process to exit
    pyScript.end((err, code, signal) => {
      if (err) throw new createError(500, err);

      console.log('The exit code was: ' + code);
      console.log('The exit signal was: ' + signal);
      console.log('finished');
    });
  } catch (err) {
    console.log(err);
    throw new createError(500, err);
  }
};
