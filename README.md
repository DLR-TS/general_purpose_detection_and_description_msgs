# general_purpose_detection_and_description_msgs

ROS2 message package for general-purpose object detection and description with 
sensor fusion support. Designed for autonomous driving perception pipelines 
compatible with the DLR ADORe framework and ASAM OSI semantics.

📖 **[See USAGE_EXAMPLES.md](USAGE_EXAMPLES.md) for complete `ros2 topic pub` examples with detailed explanations.**

## Overview

This package provides standardized ROS2 message types for representing detected
objects (vehicles, pedestrians, traffic signs) with kinematic data and 
uncertainty estimates. It bridges low-level sensor detections to high-level 
planning modules.

## Key Features

- **2.5D → 6D Flexible**: Position + orientation (2.5D default, up to full 6DOF)
- **Sensor Fusion Ready**: Covariance matrices for optimal (e.g., Kalman) filtering
- **Tracking Support**: Stable object IDs across frames
- **ROS2 Native**: Compatible with std_msgs/Header semantics
- **Extensible Classification**: Predefined constants with custom type support

## Message Types

### DetectedObjectArray
Primary container message for perception pipelines.

| Field | Type | Description |
|-------|------|-------------|
| header | Header | Timestamp and coordinate frame |
| objects | DetectedObject[] | Array of detected entities |

### DetectedObject
Single detected entity with classification and kinematic data.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | int32 | ✓ | Stable tracking ID |
| object_class | string | ✓ | Classification (CAR, TRUCK, PEDESTRIAN, etc.) |
| score | float64 | ✓ | Confidence [0.0, 1.0] |
| pose | PoseWithCovariance | ✓ | 6DOF position and orientation |
| size | ObjectSize | ✓ | Bounding box dimensions |
| velocity | VelocityWithCovariance | | Linear and angular velocity |
| label | SignLabel | | Traffic sign information |

#### Classification Constants
```
CLASS_UNKNOWN, CLASS_CAR, CLASS_TRUCK, CLASS_BUS, CLASS_MOTORCYCLE,
CLASS_BIKE, CLASS_PEDESTRIAN, CLASS_ANIMAL, CLASS_SIGN,
CLASS_TRAFFIC_LIGHT, CLASS_BARRIER, CLASS_CONE
```

### PoseWithCovariance
6DOF pose with uncertainty estimation.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| x | float64 | - | Forward position (m) |
| y | float64 | - | Lateral position (m) |
| z | float64 | 0.0 | Vertical position (m) |
| yaw | float64 | - | Heading (rad) |
| roll | float64 | 0.0 | Roll (rad) |
| pitch | float64 | 0.0 | Pitch (rad) |
| covariance | float64[] | [] | Covariance matrix (3, 6, or 36 elements) |

### VelocityWithCovariance
6DOF velocity with uncertainty estimation.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| vx | float64 | 0.0 | Forward velocity (m/s) |
| vy | float64 | 0.0 | Lateral velocity (m/s) |
| vz | float64 | 0.0 | Vertical velocity (m/s) |
| rx | float64 | 0.0 | Roll rate (rad/s) |
| ry | float64 | 0.0 | Pitch rate (rad/s) |
| rz | float64 | 0.0 | Yaw rate (rad/s) |
| covariance | float64[] | [] | Covariance matrix (3, 6, or 36 elements) |

### ObjectSize
Bounding box dimensions.

| Field | Type | Description |
|-------|------|-------------|
| l | float64 | Length (m) |
| w | float64 | Width (m) |
| h | float64 | Height (m) |

### SignLabel
Traffic sign information.

| Field | Type | Description |
|-------|------|-------------|
| text | string | Sign text (e.g., "50", "STOP") |
| value | float64 | Numeric value if applicable |

### Header
Message timestamp and coordinate frame.

| Field | Type | Description |
|-------|------|-------------|
| sec | uint32 | Unix timestamp (seconds) |
| nanosec | uint32 | Sub-second (nanoseconds) |
| frame_id | string | Coordinate frame (e.g., "map", "camera") |

## Covariance Usage

Covariance represents measurement uncertainty as squared variance (m² for position, rad² for angle).

**Compact 2.5D format (3 elements):**
```
covariance = [var_x, var_y, var_yaw]
```

**Diagonal format (6 elements):**
```
covariance = [var_x, var_y, var_z, var_roll, var_pitch, var_yaw]
```

**Full 6x6 matrix (36 elements, row-major):**
For correlated uncertainties in sensor fusion applications.

**Example interpretation:**
```
pose.covariance[0] = var_x = 0.02 m²
σ_x = √0.02 ≈ 0.14m
→ 68% of measurements within ±0.14m
```

## Installation

```bash
cd ~/ros2_ws/src
# Copy or clone this package
cd ..
colcon build --packages-select general_purpose_detection_and_description_msgs
source install/setup.bash
```

## Usage Examples

### Python Publisher
```python
import rclpy
from rclpy.node import Node
from general_purpose_detection_and_description_msgs.msg import (
    DetectedObjectArray, DetectedObject, Header, 
    PoseWithCovariance, ObjectSize, VelocityWithCovariance
)

class PerceptionPublisher(Node):
    def __init__(self):
        super().__init__('perception_publisher')
        self.publisher = self.create_publisher(
            DetectedObjectArray, 'detected_objects', 10
        )
    
    def publish_detection(self):
        msg = DetectedObjectArray()
        
        # Header
        msg.header.sec = 1706400000
        msg.header.nanosec = 123456789
        msg.header.frame_id = 'map'
        
        # Detected car
        car = DetectedObject()
        car.id = 1
        car.object_class = DetectedObject.CLASS_CAR
        car.score = 0.97
        car.pose.x = 12.3
        car.pose.y = -3.2
        car.pose.yaw = 1.57
        car.pose.covariance = [0.02, 0.03, 0.005]
        car.size.l = 4.8
        car.size.w = 1.9
        car.size.h = 1.6
        car.velocity.vx = 8.5
        car.velocity.vy = -0.3
        car.velocity.rz = 0.05
        car.velocity.covariance = [0.01, 0.02, 0.008]
        
        msg.objects.append(car)
        self.publisher.publish(msg)
```

### C++ Subscriber
```cpp
#include "general_purpose_detection_and_description_msgs/msg/detected_object_array.hpp"

using DetectedObjectArray = general_purpose_detection_and_description_msgs::msg::DetectedObjectArray;
using DetectedObject = general_purpose_detection_and_description_msgs::msg::DetectedObject;

void callback(const DetectedObjectArray::SharedPtr msg) {
    for (const auto& obj : msg->objects) {
        if (obj.object_class == DetectedObject::CLASS_CAR && obj.score > 0.9) {
            RCLCPP_INFO(get_logger(), "High-confidence car at (%.2f, %.2f)", 
                       obj.pose.x, obj.pose.y);
        }
    }
}
```

## JSON Schema Compatibility

This package implements the JSON schema defined in `Detection_Interface.json`. The mapping is:

| JSON Field | ROS2 Message |
|------------|--------------|
| header | Header.msg |
| objects[].id | DetectedObject.id |
| objects[].class | DetectedObject.object_class |
| objects[].score | DetectedObject.score |
| objects[].pose | PoseWithCovariance.msg |
| objects[].size | ObjectSize.msg |
| objects[].velocity | VelocityWithCovariance.msg |
| objects[].label | SignLabel.msg |

## License

Apache-2.0
