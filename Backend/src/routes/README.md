# Routes
Most of these routes are for testing purposes only.

We have a database with made up trafficlight and anchor data. Here are the following routes and their responses:

## Traffic Light Routes

**Request**
````
GET /trafficLights/
````
**Response**
```json
{
  "coordinates": {
    "latitude": 11,
    "longitude": 10
  },
  "pozyx": {
    "x": 0,
    "y": 0
  },
  "_id": "60f58d873472f42f28d9844c",
  "state": "Red",
  "duration": 0,
  "__v": 0
}
```
The id is generated automatically by mongodb, so we don't need to put it in.

**Request**

The following route uses query parameters and not path parameters.
````
GET /trafficLights/findByLatLon/?latitude=11&longitude=10
````
**Response**
```json
{
  "coordinates": {
    "latitude": 11,
    "longitude": 10
  },
  "pozyx": {
    "x": 0,
    "y": 0
  },
  "_id": "60f58d873472f42f28d9844c",
  "state": "Red",
  "duration": 0,
  "__v": 0
}
```
**Request**
````
POST /api/trafficLights/
Body:
{
	"coordinates": {
		"latitude": 11,
		"longitude":10
	},
	"pozyx": {
		"x": 0,
		"y": 0
	},
	"state": "Red",
	"duration": 0
}
````
**Response**
```json
{
  "coordinates": {
    "latitude": 11,
    "longitude": 10
  },
  "pozyx": {
    "x": 0,
    "y": 0
  },
  "_id": "60f58d873472f42f28d9844c",
  "state": "Red",
  "duration": 0,
  "__v": 0
}
```
**Request**
````
PUT /api/trafficLights/id=60f58d873472f42f28d9844c
Body:
{
	"coordinates": {
		"latitude": 11,
		"longitude":10
	},
	"pozyx": {
		"x": 0,
		"y": 0
	},
	"state": "Red",
	"duration": 0
}
````
You can change only one value of the object if you'd like.
Make sure to write the object inside of the body if you want to change a property inside of the object 'coordinates' or 'pozyx'. Example:
````
Body:
{
  "coordinates": {
    "latitude": 11
  }
}
````
This will only modify the latitude and leave every other value the way it is.

**Response**
```json
{
  "coordinates": {
    "latitude": 11,
    "longitude": 10
  },
  "pozyx": {
    "y": 0,
    "x": 0
  },
  "_id": "60f58d873472f42f28d9844c",
  "state": "Red",
  "duration": 0,
  "__v": 0
}
```
