cmake_minimum_required(VERSION 3.4.1)  # for example

add_library( images_filter

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ../ios/Classes/images_filter.cpp )