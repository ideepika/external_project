#This module builds opentracing
function(build_opentracing)
  set(OpenTracing_DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/src")
  set(OpenTracing_ROOT_DIR "${CMAKE_CURRENT_BINARY_DIR}/OpenTracing")
  set(OpenTracing_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/opentracing-cpp")
  set(OpenTracing_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/OpenTracing")

  set(OpenTracing_CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON)

  if(CMAKE_MAKE_PROGRAM MATCHES "make")
    # try to inherit command line arguments passed by parent "make" job
    set(make_cmd "$(MAKE)")
  else()
    set(make_cmd ${CMAKE_COMMAND} --build <BINARY_DIR> --target opentracing-cpp)
  endif()

  include(ExternalProject)
  ExternalProject_Add(OpenTracing
    GIT_REPOSITORY "https://github.com/opentracing/opentracing-cpp.git"
    GIT_TAG "v1.5.0"
    UPDATE_COMMAND "" #disables update on each run
    DOWNLOAD_DIR ${OpenTracing_DOWNLOAD_DIR}
    SOURCE_DIR ${OpenTracing_SOURCE_DIR}
    PREFIX ${OpenTracing_ROOT_DIR}
    CMAKE_ARGS ${OpenTracing_CMAKE_ARGS}
    BINARY_DIR ${OpenTracing_BINARY_DIR}
    BUILD_COMMAND ${make_cmd}
    INSTALL_COMMAND "true"
    )
endfunction()
