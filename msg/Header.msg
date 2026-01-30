# Header for detection messages
# Contains global metadata for all objects in the message
# Compatible with std_msgs/Header semantics

# Unix timestamp seconds (e.g. 1706400000)
uint32 sec

# Sub-second nanoseconds (e.g. 123456789)
uint32 nanosec

# Coordinate frame identifier (e.g. "map", "camera", "base_link")
string frame_id
