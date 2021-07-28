# Safe Crossing
This project is about determining which crosswalk a pedestrian is about to cross with a mobile phone and optional hardware devices installed on the intersection. Pedestrians, specifically blind people, are the target audience for this project. Here is the [link](https://osoc21.github.io/Safe-Crossing/) to our website.

## Overview
In this project, we use a Pozyx kit in order to determine the precise location of the user and, if the user is close to a traffic light, we send the traffic light's status to the user's smartphone.

## Structure of the project and repository
This project has three main parts: 
- A backend written in NodeJS. The `Backend` folder also has a subfolder named `Pozyx` containing the necessary code for precise localization.
- A frontend written in Flutter. 
- ARKit development and experimentation. This part is completely separate from the backend and frontend parts.

## Documentation
We have a [Wiki](https://github.com/osoc21/Safe-Crossing/wiki) with a complete documentation of everything about this project.
If you want the documentation of a specific part of the project, here are the links to the documentation:  
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