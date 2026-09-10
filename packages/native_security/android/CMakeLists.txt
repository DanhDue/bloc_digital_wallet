cmake_minimum_required(VERSION 3.10.2)

project(native_security VERSION 1.0.0 LANGUAGES CXX)

add_library(native_security SHARED
  ../ios/native_security/Sources/native_security_ffi/native_security.cpp
)

target_include_directories(native_security PRIVATE
  ../ios/native_security/Sources/native_security_ffi/include
)
