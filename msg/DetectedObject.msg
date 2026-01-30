# Single detected object with classification and kinematic data
# Compatible with ASAM OSI DetectedObject + TrafficSign semantics

# Object Classification Constants
string CLASS_UNKNOWN=UNKNOWN
string CLASS_CAR=CAR
string CLASS_TRUCK=TRUCK
string CLASS_BUS=BUS
string CLASS_MOTORCYCLE=MOTORCYCLE
string CLASS_BIKE=BIKE
string CLASS_PEDESTRIAN=PEDESTRIAN
string CLASS_ANIMAL=ANIMAL
string CLASS_SIGN=SIGN
string CLASS_TRAFFIC_LIGHT=TRAFFIC_LIGHT
string CLASS_BARRIER=BARRIER
string CLASS_CONE=CONE

# Stable tracking ID across frames (e.g. 42)
int32 id

# Object classification (e.g. CAR, TRUCK, PEDESTRIAN, SIGN, UNKNOWN)
# Use CLASS_* constants or custom strings
string object_class

# Detection confidence score [0.0, 1.0]
float64 score

# 6DOF pose with covariance (x, y required; z, roll, pitch optional)
PoseWithCovariance pose

# Bounding box dimensions (length, width, height in meters)
ObjectSize size

# 6DOF velocity with covariance (optional, for dynamic objects)
VelocityWithCovariance velocity

# Traffic sign label (optional, for SIGN class objects)
SignLabel label
