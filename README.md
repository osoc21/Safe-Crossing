# Safe Crossing
This project is about determining which crosswalk a pedestrian is about to cross with a mobile phone and optionally hardware devices installed on the intersection. Pedestrians and specially blind people are the target audience for this project. Here is the [link](https://osoc21.github.io/Safe-Crossing/) to our website.  

## Overview
In this project, we use the Pozyx kit in order to determine the precise location of the user and if the user is close to a traffic light, we send the status of the traffic light to user's smart phone.  

## Structure of the project and repository
This project has three main parts: 
- A backend written in NodeJS. The Backend folder also has a sub folder named Pozyx that contains the necessary code for precise localization. 
- A Frontend written in Flutter. 
- ARKit development and experimentation. This part is completely separate from the backend and frontend parts.

## Documentation
Here are the links to the documentation:  
- [Backend documentation](https://github.com/osoc21/Safe-Crossing/blob/master/Backend/README.md)
    - [API routes documentation](https://github.com/osoc21/Safe-Crossing/blob/master/Backend/src/routes/README.md)
    - [Utilities documentation](https://github.com/osoc21/Safe-Crossing/blob/master/Backend/src/utils/README.md)
  - [Pozyx Documentation](https://github.com/osoc21/Safe-Crossing/blob/master/Backend/Pozyx/README.md)
- [Frontend documentation](https://github.com/osoc21/Safe-Crossing/blob/master/Frontend/README.md)
- [ARKit documentation](https://github.com/osoc21/Safe-Crossing/blob/master/ARKit-Drawing/README.md)

## Contributors

<a href="https://github.com/osoc21/Safe-Crossing/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=osoc21/Safe-Crossing" />
</a>

## Licence 
This project is under MIT licence.