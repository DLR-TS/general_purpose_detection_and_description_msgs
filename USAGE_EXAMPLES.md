# Usage Examples

This document provides practical examples for publishing detection messages using `ros2 topic pub`. All examples assume the package is built and sourced.

## Table of Contents

- [Basic Traffic Sign Detection](#basic-traffic-sign-detection)
- [Moving Vehicle Detection](#moving-vehicle-detection)
- [Pedestrian Detection](#pedestrian-detection)
- [Multi-Object Intersection Scenario](#multi-object-intersection-scenario)
- [High-Precision Sensor Fusion](#high-precision-sensor-fusion)
- [Minimal 2.5D Detection](#minimal-25d-detection)

---

## Basic Traffic Sign Detection

Publishes a speed limit sign (50 km/h) detected 15 meters ahead by a camera. This is a static object with no velocity, typical for traffic sign recognition systems.

**Scenario**: Camera-based sign detection system identifies a speed limit sign on the right side of the road.

```bash
ros2 topic pub /detected_objects general_purpose_detection_and_description_msgs/msg/DetectedObjectArray "{
  header: {
    sec: 1706400000,
    nanosec: 456789012,
    frame_id: 'camera_front'
  },
  objects: [{
    id: 100,
    object_class: 'SIGN',
    score: 0.92,
    pose: {
      x: 15.0,
      y: 0.5,
      z: 2.2,
      yaw: 0.0,
      roll: 0.0,
      pitch: 0.0,
      covariance: [0.2, 0.1, 0.05]
    },
    size: {
      l: 0.8,
      w: 0.8,
      h: 0.1
    },
    velocity: {
      vx: 0.0,
      vy: 0.0,
      vz: 0.0,
      rx: 0.0,
      ry: 0.0,
      rz: 0.0,
      covariance: []
    },
    label: {
      text: '50',
      value: 50.0
    }
  }]
}"
```

**Field Explanation**:
- `frame_id: 'camera_front'`: Detection is in the front camera's coordinate frame
- `x: 15.0, y: 0.5, z: 2.2`: Sign is 15m ahead, 0.5m to the right, 2.2m high
- `yaw: 0.0`: Sign faces the vehicle directly
- `covariance: [0.2, 0.1, 0.05]`: 2.5D uncertainty (σ_x≈0.45m, σ_y≈0.32m, σ_yaw≈0.22rad)
- `label.value: 50.0`: Speed limit of 50 km/h

---

## Moving Vehicle Detection

Publishes a car detected by radar moving at highway speed. Includes velocity with covariance for tracking and prediction.

**Scenario**: Radar detects a vehicle in the adjacent lane traveling faster than ego vehicle.

```bash
ros2 topic pub /detected_objects general_purpose_detection_and_description_msgs/msg/DetectedObjectArray "{
  header: {
    sec: 1706400001,
    nanosec: 123456789,
    frame_id: 'base_link'
  },
  objects: [{
    id: 42,
    object_class: 'CAR',
    score: 0.97,
    pose: {
      x: 25.0,
      y: -3.5,
      z: 0.0,
      yaw: 0.05,
      roll: 0.0,
      pitch: 0.0,
      covariance: [0.04, 0.09, 0.001]
    },
    size: {
      l: 4.5,
      w: 1.8,
      h: 1.5
    },
    velocity: {
      vx: 30.0,
      vy: 0.5,
      vz: 0.0,
      rx: 0.0,
      ry: 0.0,
      rz: 0.02,
      covariance: [0.25, 0.04, 0.0001]
    },
    label: {
      text: '',
      value: 0.0
    }
  }]
}"
```

**Field Explanation**:
- `frame_id: 'base_link'`: Detection is in vehicle body frame
- `x: 25.0, y: -3.5`: Vehicle is 25m ahead, 3.5m to the left (adjacent lane)
- `yaw: 0.05`: Slight angle (~3°) indicating lane change intent
- `vx: 30.0`: Moving at 30 m/s (108 km/h) forward
- `vy: 0.5`: Slight lateral movement toward ego lane
- `rz: 0.02`: Small yaw rate confirming lane change maneuver
- `velocity.covariance: [0.25, 0.04, 0.0001]`: σ_vx≈0.5m/s, σ_vy≈0.2m/s, σ_rz≈0.01rad/s

---

## Pedestrian Detection

Publishes a pedestrian crossing the road detected by a camera-lidar fusion system. Pedestrians have high uncertainty and unpredictable motion.

**Scenario**: Pedestrian detected stepping off curb into crosswalk.

```bash
ros2 topic pub /detected_objects general_purpose_detection_and_description_msgs/msg/DetectedObjectArray "{
  header: {
    sec: 1706400002,
    nanosec: 500000000,
    frame_id: 'map'
  },
  objects: [{
    id: 7,
    object_class: 'PEDESTRIAN',
    score: 0.85,
    pose: {
      x: 12.0,
      y: 4.0,
      z: 0.0,
      yaw: -1.57,
      roll: 0.0,
      pitch: 0.0,
      covariance: [0.15, 0.15, 0.1]
    },
    size: {
      l: 0.5,
      w: 0.5,
      h: 1.75
    },
    velocity: {
      vx: 0.3,
      vy: -1.2,
      vz: 0.0,
      rx: 0.0,
      ry: 0.0,
      rz: 0.0,
      covariance: [0.04, 0.04, 0.01]
    },
    label: {
      text: '',
      value: 0.0
    }
  }]
}"
```

**Field Explanation**:
- `score: 0.85`: Lower confidence typical for pedestrian detection
- `yaw: -1.57`: Facing perpendicular to road (-90°), crossing direction
- `size: 0.5x0.5x1.75`: Typical adult pedestrian dimensions
- `vx: 0.3, vy: -1.2`: Walking across road at ~1.2 m/s with slight forward component
- `covariance: [0.15, 0.15, 0.1]`: Higher position uncertainty than vehicles

---

## Multi-Object Intersection Scenario

Publishes multiple objects at a busy intersection: a car, truck, pedestrian, and stop sign. Demonstrates real-world sensor fusion output.

**Scenario**: Approaching a 4-way stop with traffic from multiple directions.

```bash
ros2 topic pub /detected_objects general_purpose_detection_and_description_msgs/msg/DetectedObjectArray "{
  header: {
    sec: 1706400003,
    nanosec: 789012345,
    frame_id: 'map'
  },
  objects: [
    {
      id: 1,
      object_class: 'CAR',
      score: 0.97,
      pose: {
        x: 12.3,
        y: -3.2,
        z: 0.0,
        yaw: 1.57,
        roll: 0.0,
        pitch: 0.0,
        covariance: [0.02, 0.03, 0.005]
      },
      size: {l: 4.8, w: 1.9, h: 1.6},
      velocity: {
        vx: 8.5,
        vy: -0.3,
        vz: 0.0,
        rx: 0.0,
        ry: 0.0,
        rz: 0.05,
        covariance: [0.01, 0.02, 0.008]
      },
      label: {text: '', value: 0.0}
    },
    {
      id: 2,
      object_class: 'TRUCK',
      score: 0.91,
      pose: {
        x: 25.1,
        y: 1.5,
        z: 0.0,
        yaw: 3.14,
        roll: 0.0,
        pitch: 0.0,
        covariance: [0.08, 0.1, 0.02]
      },
      size: {l: 8.5, w: 2.5, h: 2.8},
      velocity: {
        vx: 3.2,
        vy: 0.1,
        vz: 0.0,
        rx: 0.0,
        ry: 0.0,
        rz: 0.0,
        covariance: [0.05, 0.06, 0.01]
      },
      label: {text: '', value: 0.0}
    },
    {
      id: 3,
      object_class: 'PEDESTRIAN',
      score: 0.88,
      pose: {
        x: 8.0,
        y: 5.5,
        z: 0.0,
        yaw: -0.78,
        roll: 0.0,
        pitch: 0.0,
        covariance: [0.15, 0.15, 0.1]
      },
      size: {l: 0.4, w: 0.4, h: 1.8},
      velocity: {
        vx: 1.2,
        vy: 0.8,
        vz: 0.0,
        rx: 0.0,
        ry: 0.0,
        rz: 0.0,
        covariance: [0.1, 0.1, 0.05]
      },
      label: {text: '', value: 0.0}
    },
    {
      id: 200,
      object_class: 'SIGN',
      score: 0.96,
      pose: {
        x: 5.0,
        y: -6.0,
        z: 2.0,
        yaw: 0.0,
        roll: 0.0,
        pitch: 0.0,
        covariance: [0.05, 0.05, 0.02]
      },
      size: {l: 0.9, w: 0.9, h: 0.9},
      velocity: {
        vx: 0.0,
        vy: 0.0,
        vz: 0.0,
        rx: 0.0,
        ry: 0.0,
        rz: 0.0,
        covariance: []
      },
      label: {text: 'STOP', value: 0.0}
    }
  ]
}"
```

**Field Explanation**:
- **Car (id=1)**: Crossing perpendicular at 8.5 m/s, yaw=1.57 rad (90°), slight turning (rz=0.05)
- **Truck (id=2)**: Approaching from opposite direction (yaw=π), slow-moving at 3.2 m/s, larger covariance due to size
- **Pedestrian (id=3)**: Walking diagonally across intersection at ~1.4 m/s combined velocity
- **Stop Sign (id=200)**: Static regulatory sign, label.text='STOP' for planner interpretation

---

## High-Precision Sensor Fusion

Publishes a vehicle detection with full 6x6 covariance matrix from a high-end sensor fusion system. Used for precise tracking and prediction.

**Scenario**: Multi-sensor fusion (camera + lidar + radar) tracking a vehicle with correlated uncertainties.

```bash
ros2 topic pub /detected_objects general_purpose_detection_and_description_msgs/msg/DetectedObjectArray "{
  header: {
    sec: 1706400004,
    nanosec: 100000000,
    frame_id: 'map'
  },
  objects: [{
    id: 55,
    object_class: 'CAR',
    score: 0.99,
    pose: {
      x: 18.5,
      y: -1.8,
      z: 0.15,
      yaw: 0.12,
      roll: 0.01,
      pitch: -0.02,
      covariance: [
        0.01, 0.002, 0.0, 0.0, 0.0, 0.001,
        0.002, 0.015, 0.0, 0.0, 0.0, 0.002,
        0.0, 0.0, 0.05, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.001, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.001, 0.0,
        0.001, 0.002, 0.0, 0.0, 0.0, 0.0005
      ]
    },
    size: {
      l: 4.7,
      w: 1.85,
      h: 1.45
    },
    velocity: {
      vx: 15.2,
      vy: 0.08,
      vz: 0.0,
      rx: 0.0,
      ry: 0.0,
      rz: 0.015,
      covariance: [
        0.04, 0.005, 0.0, 0.0, 0.0, 0.002,
        0.005, 0.02, 0.0, 0.0, 0.0, 0.003,
        0.0, 0.0, 0.01, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0001, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0001, 0.0,
        0.002, 0.003, 0.0, 0.0, 0.0, 0.0004
      ]
    },
    label: {text: '', value: 0.0}
  }]
}"
```

**Field Explanation**:
- `score: 0.99`: Very high confidence from multi-sensor fusion
- Full 6DOF pose including z=0.15m (slight elevation), roll and pitch from road grade
- **36-element covariance**: Full 6x6 matrix capturing correlations
  - Off-diagonal terms (0.002, 0.001) show x-y and x-yaw correlations
  - This enables optimal Kalman filter updates
- `vx: 15.2`: ~55 km/h, typical urban driving speed
- `rz: 0.015`: Small yaw rate indicating gentle curve following

---

## Minimal 2.5D Detection

Publishes a simple detection using only required fields with 2.5D covariance. Useful for basic detectors or resource-constrained systems.

**Scenario**: Simple radar detection with minimal data.

```bash
ros2 topic pub /detected_objects general_purpose_detection_and_description_msgs/msg/DetectedObjectArray "{
  header: {
    sec: 1706400005,
    nanosec: 0,
    frame_id: 'radar_front'
  },
  objects: [{
    id: 1,
    object_class: 'UNKNOWN',
    score: 0.7,
    pose: {
      x: 30.0,
      y: 0.0,
      z: 0.0,
      yaw: 0.0,
      roll: 0.0,
      pitch: 0.0,
      covariance: [1.0, 0.5, 0.1]
    },
    size: {
      l: 2.0,
      w: 2.0,
      h: 1.5
    },
    velocity: {
      vx: -5.0,
      vy: 0.0,
      vz: 0.0,
      rx: 0.0,
      ry: 0.0,
      rz: 0.0,
      covariance: [0.5, 0.2, 0.05]
    },
    label: {text: '', value: 0.0}
  }]
}"
```

**Field Explanation**:
- `object_class: 'UNKNOWN'`: Radar cannot classify object type
- `score: 0.7`: Moderate confidence typical for radar-only detection
- `covariance: [1.0, 0.5, 0.1]`: Compact 2.5D format (σ_x=1m, σ_y≈0.7m, σ_yaw≈0.3rad)
- `size: 2.0x2.0x1.5`: Default bounding box when actual size unknown
- `vx: -5.0`: Approaching ego vehicle (closing velocity of 5 m/s)
- Large covariance reflects radar's lower spatial precision vs lidar

---

## Continuous Publishing

To publish messages continuously for testing, add the `--rate` flag:

```bash
ros2 topic pub --rate 10 /detected_objects general_purpose_detection_and_description_msgs/msg/DetectedObjectArray "{...}"
```

This publishes at 10 Hz, typical for perception systems.

## Echoing Messages

To verify messages are being published:

```bash
ros2 topic echo /detected_objects
```

To see message structure:

```bash
ros2 interface show general_purpose_detection_and_description_msgs/msg/DetectedObjectArray
```
