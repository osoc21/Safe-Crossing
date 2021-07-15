import random
import json

while True:
    tag_location = [
        
            {
                "version": "1",
                "tagId": "24576",
                "success": True,
                "timestamp": 1524496105.895,
                "data": {
                    "tagData": {
                        "gyro": {
                            "x": 0,
                            "y": 0,
                            "z": 0
                        },
                        "magnetic": {
                            "x": 0,
                            "y": 0,
                            "z": 0
                        },
                        "quaternion": {
                            "x": 0,
                            "y": 0,
                            "z": 0,
                            "w": 0
                        },
                        "linearAcceleration": {
                            "x": 0,
                            "y": 0,
                            "z": 0
                        },
                        "pressure": 0,
                        "maxLinearAcceleration": 0
                    },
                    "anchorData": [],
                    "coordinates": {
                        "x": random.randint(1000,5000),
                        "y": random.randint(1000,5000),
                        "z": 0
                    },
                    "acceleration": {
                        "x": 0,
                        "y": 0,
                        "z": 0
                    },
                    "orientation": {
                        "yaw": 0,
                        "roll": 0,
                        "pitch": 0
                    },
                    "metrics": {
                        "latency": 2.1,
                        "rates": {
                            "update": 52.89,
                            "success": 52.89
                        }
                    }
                }
            }
        ]
    print(json.dumps(tag_location))
