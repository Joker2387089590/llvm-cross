cmake_minimum_required(VERSION 3.22)
project(test)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -v")
add_executable(test main.cpp)
install(TARGETS test)
