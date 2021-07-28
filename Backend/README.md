# Safe-Crossing Backend
REST API written in
<a href="https://nodejs.org/en/about/" target="_blank">Node.js</a>
 using the
 <a href="https://expressjs.com/" target="_blank">Express.js</a>
 web application framework and
 <a href="https://www.mongodb.com/" target="_blank">MongoDB</a>
 for our database.

Other services used include:
- <a href="https://www.mongodb.com/cloud/atlas" target="_blank">MongoDB Atlas</a>
for MongoDB database hosting.

## Config
Create `.env` file in the `Backend` folder with this content:
```sh
DB_URL="mongodb+srv://user:password@server"
```
To run the backend you have 2 choices:

### Docker
To run the docker container you have 2 choices:

- #### Manually
Build docker container:
```sh
docker build -t safe-crossing-backend .
```
Run docker container:
```sh
docker run -p 3000:3000 -p 8888:8888 safe-crossing-backend
```
or
```sh
docker run -p 3000:3000 -p 8888:8888 -d safe-crossing-backend
```
to run the docker container in detached mode (runs in background).

- #### Run Script
Simply type the following in your cmd:
```sh
# the run script builds and runs the docker container
sudo sh run.sh
```
or
```sh
# the run script builds and runs the docker container in detached mode
sudo sh run.sh -d
```
to run the docker container in detached mode (runs in background).

### Node
Install modules using npm:
```sh
npm install
```

You can then start your backend.
```sh
npm start
```

And access using your browser.
```
http://localhost:3000/api/
```

# Documentation

To read more about:
- MongoDB object modeling with
<a href="https://mongoosejs.com/" target="_blank">Mongoose</a>.

- Real-time, bidirectional, event-based communication with
<a href="https://socket.io/" target="_blank"> Socket.IO</a>.
