cmake_minimum_required(VERSION 3.8)
project(general_purpose_detection_and_description_msgs)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/Header.msg"
  "msg/ObjectSize.msg"
  "msg/PoseWithCovariance.msg"
  "msg/VelocityWithCovariance.msg"
  "msg/SignLabel.msg"
  "msg/DetectedObject.msg"
  "msg/DetectedObjectArray.msg"
  DEPENDENCIES std_msgs geometry_msgs
)

ament_package()
