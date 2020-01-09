function(build_opentracing)
  set(OpenTracing_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/opentracing-cpp")
  set(OpenTracing_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/OpenTracing")
  set(OpenTracing_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/OpenTracing/install")

  set(OpenTracing_CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON)
  list(APPEND OpenTracing_CMAKE_ARGS -DBUILD_SHARED_LIBS=ON)
  list(APPEND OpenTracing_CMAKE_ARGS --DCMAKE_INSTALL_PREFIX=<OpenTracing_INSTALL_DIR>)
  if(CMAKE_MAKE_PROGRAM MATCHES "make")
    # try to inherit command line arguments passed by parent "make" job
    set(make_cmd $(MAKE) OpenTracing)
  else()
    set(make_cmd ${CMAKE_COMMAND} --build <BINARY_DIR> --target OpenTracing)
  endif()

  include(ExternalProject)
  ExternalProject_Add(OpenTracing
    GIT_REPOSITORY "https://github.com/opentracing/opentracing-cpp.git"
    GIT_TAG "origin/v1.5.0"
    UPDATE_COMMAND "" #disables update on each run
    DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/src
    SOURCE_DIR ${OpenTracing_SOURCE_DIR}
    CMAKE_ARGS ${OpenTracing_CMAKE_ARGS}
    BINARY_DIR ${OpenTracing_BINARY_DIR}
    BUILD_COMMAND ${make_cmd}
    BUILD_ALWAYS TRUE
    INSTALL_COMMAND "true"
    LOG_BUILD TRUE)

  ExternalProject_Get_Property(OpenTracing SOURCE_DIR)
  message(STATUS "Source dir of OpenTracing is ${SOURCE_DIR}")
endfunction()
