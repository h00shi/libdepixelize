project(depixelize)

cmake_minimum_required(VERSION 2.8)
find_package(PkgConfig REQUIRED)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

pkg_check_modules(GDKMM REQUIRED gdkmm-2.4)
pkg_check_modules(2GEOM REQUIRED 2geom)
pkg_check_modules(GSL REQUIRED gsl)


add_subdirectory(src)
