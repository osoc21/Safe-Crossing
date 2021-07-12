# Safe-Crossing Backend
REST API written in
<a href="https://nodejs.org/en/about/" target="_blank">Node.js</a>
 using the
 <a href="https://expressjs.com/" target="_blank">Express.js</a>
 web application framework and
 <a href="https://www.mongodb.com/" target="_blank">MongoDB</a>
 for our database.

Other services used include:
- <a href="https://mlab.com/" target="_blank">mLab</a>
for MongoDB database hosting.

## Config
Create `.env` file in the `switch_backend` folder with this content:
```sh
DB_URL="mongodb://user:password@server"
```

## First Steps
To install modules using npm:
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
- Uploading files with
<a href="https://github.com/expressjs/multer" target="_blank">Multer</a>.
- MongoDB object modeling with
<a href="https://mongoosejs.com/" target="_blank">Mongoose</a>.
