# Pozyx kit setup for Safe Crossing project

## Overview

This document explains the Pozyx code setup for Safe Crossing project. The code is written in Python and we recommend you to install `pip` so you can easily install the necessary packages.  
**Although this code is run by the backend server, it's possible to run it independently but you should follow all the steps explained blow to not encounter any error.** 

## Package Installation
All the required packages to run the code are listed on `requirements.txt` file. **Installation of these packages is necessary in order to run the code.** To install packages, you can simply run:  

```console
pip install -r requirements.txt
```

## Run the Code
The main script is named `pozyx_localize.py` and it takes a file name as its first argument. The file is a JSON file that contains necessary information regarding Pozyx anchors and tags and traffic lights position. More on this later. An example file `pozyx_kit_info.json` is provided in the Pozyx folder. 
Here is the command with which you can run the script:  

```console
python pozyx_localize.py /path/to/json/file
```

> The python script is run by the backend server automatically and you don't need to run it manually. It's possible to run it manually but it doesn't give you a lot of information. The most important thing is the JSON file that provides the necessary information for the script to calibrate the Pozyx kit.

## Pozyx kit JSON file
In order for the Pozyx kit to calibrate and localize the tags, you must provide the python script with necessary information about the position of anchors, tags and traffic lights. We put all of these information in a JSON file that we provide the path ro the python script as the first argument.  
**The format of the JSON file is really important and it should be exactly like we explain it here or the code won't work. An example file (`pozyx_kit_info.py`) is provided. It's recommended to use this file and change the values.**  
Here is the structure of this JSON file:  
```json
{
  "anchors": [
    {
      "id": "0x1234",
      "anchorPos": {
        "x": 4800,
        "y": 5500,
        "z": 750
      }
    },
    {
      "id": "0x1234",
      "anchorPos": {
        "x": 4800,
        "y": 5500,
        "z": 750
      }
    },
  ],
  "tags": [
    {
      "id": "0x1234"
    }
  ],
  "trafficLights": [
    {
      "id": "60f58d873472f42f28d9844c",
      "pos": {
        "x": 6700,
        "y": 3700.0
      }
    },
    {
      "id": "60f58d933472f42f28d98451",
      "pos": {
        "x": 800,
        "y": 6700
      }
    }
  ]
}
```

**All the distances in the JSON file and code should be in millimeters.**  

### **Anchors** 
For the anchors, you must chose one of the anchors as the $(0,0)$ position and set up the other anchors based on the chosen anchor. For more detail on this, refer to the [Pozyx Documentation](https://docs.pozyx.io/creator/latest/python/tutorial-2-ready-to-localize-python).  
For each anchor, you will need to enter the position of the anchor (in respect to the chosen $(0,0)$ anchor and distance measured in $mm$) and it's id like shown above.  

### **Tags**
The only thing needed for tags is the id of the tag. The id of the gateway (the tag connected to the device) is not needed as it's already hardcoded in the code. 

### **Traffic lights**
For the traffic lights, we will need the traffic light id that is in the backend database and it's $(x,y)$ Pozyx position. This position is different with the GPS coordinates of the traffic light. This $(x,y)$ position is based on the chosen anchor's $(0,0)$ position. 

## Possible errors 
Here is a list of things that might cause an error when you run the script:  
- The Pozyx gateway is not connected to the device that runs the script,.
- The format of the JSON file is not correct.
- The JSON file does not exist or the path to the file is not correct (the best way to avoid this is to give the absolute path to the file).
- A necessary package in the `requirements.txt` is not installed on your python installation.
- You don't have the permission to have access to ports of your computer (if on Linux, the solution would be to run the script with `sudo` privileges).

## Code Explained
As mentioned before, the most important part of the Pozyx code is the `pozyx_localize.py` script. This script is a modified version of the provided script by the [Pozyx documentation](https://docs.pozyx.io/creator/latest/python/tutorial-2-ready-to-localize-python).  
The provided script by the documentation was designed for multi tag localization and was only able to print out the position of the tags. We modified this script so that it can send us back the id of a traffic light if we are close to one or a "Not Close" string otherwise. This string is used by the backend to determine the status of the traffic light and after that the status is sent to the frontend. The script is basically an infinite loop.  

There are two methods that were added to the code provided by the documentation in order to take traffic lights into consideration:  
- `setup` : This method is used to read the JSON file and set up the anchors, tags and traffic lights information into the class. All this information is used afterward for tag localization. 
- `check_proximity` : This method takes a tag position as argument and checks if the tag is in the radius of a traffic light. It does this by checking all the traffic lights provided by the JSON file. The radius can be modified by changing the `TRAFFIC_LIGHT_RADIUS` class attribute. The method returns the id of the traffic light if the tag is inside (or on the edge) of a traffic light's radius or `None` otherwise.
- `loop`: This method is an infinite loop that checks the position of the tag in an interval of 1 second. The loop checks if a tag is in the radius of a traffic light and if this is the case, it prints out the id of that traffic light and if not, it prints out "Not Close" to the `stdout`. This output is used by the backend to determine the status of the traffic light and send the status to the frontend.
  
We removed most of the outputs from the code provided by the Pozyx documentation because they were not necessary and this helps to not overload the `stdout` of the backend server that runs the script.

The radius for traffic lights is set to $800 \; mm$ but it could be changes as needed. You only need to modify the `TRAFFIC_LIGHT_RADIUS` attribute.