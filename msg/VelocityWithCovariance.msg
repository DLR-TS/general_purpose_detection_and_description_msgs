# 6DOF Velocity with covariance for sensor fusion
# Supports 2.5D (vx, vy, rz) up to full 6DOF

# Forward velocity in m/s
float64 vx 0.0

# Lateral velocity in m/s
float64 vy 0.0

# Vertical velocity in m/s (default: 0)
float64 vz 0.0

# Roll rate in rad/s (default: 0)
float64 rx 0.0

# Pitch rate in rad/s (default: 0)
float64 ry 0.0

# Yaw rate in rad/s (default: 0)
float64 rz 0.0

# Velocity covariance matrix (row-major order)
# Length 3 for 2.5D [var_vx, var_vy, var_rz]
# Length 6 for diagonal [var_vx, var_vy, var_vz, var_rx, var_ry, var_rz]
# Length 36 for full 6x6 covariance matrix
# Units: (m/s)^2 for linear, (rad/s)^2 for angular
float64[] covariance
