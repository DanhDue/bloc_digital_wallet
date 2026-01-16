cmake_minimum_required(VERSION 3.10.2)

project(native_security VERSION 1.0.0 LANGUAGES CXX)

add_library(native_security SHARED
  ../ios/Classes/native_security.cpp
)
