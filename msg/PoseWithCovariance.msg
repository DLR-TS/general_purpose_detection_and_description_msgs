# 6DOF Pose with covariance for sensor fusion
# Supports 2.5D (x, y, yaw) up to full 6DOF

# Forward position in meters (required)
float64 x

# Lateral position in meters (required)
float64 y

# Vertical position in meters (default: 0)
float64 z 0.0

# Heading angle in radians (required)
float64 yaw

# Roll angle in radians (default: 0)
float64 roll 0.0

# Pitch angle in radians (default: 0)
float64 pitch 0.0

# Pose covariance matrix (row-major order)
# Length 3 for 2.5D [var_x, var_y, var_yaw]
# Length 6 for diagonal [var_x, var_y, var_z, var_roll, var_pitch, var_yaw]
# Length 36 for full 6x6 covariance matrix
# Units: m^2 for position, rad^2 for angles
float64[] covariance
