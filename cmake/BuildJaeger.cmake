function(build_jaeger)
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
  set(Jaeger_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/")
  set(Jaeger_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/Jaeger")
  set(Jaeger_ROOT_DIR "${CMAKE_CURRENT_BINARY_DIR}/Jaeger")
  set(Jaeger_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/Jaeger/install")

  set(Jaeger_CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON)
  list(APPEND Jaeger_CMAKE_ARGS -DBUILD_SHARED_LIBS=ON)
  list(APPEND Jaeger_CMAKE_ARGS -DHUNTER_ENABLED=OFF)
  list(APPEND Jaeger_CMAKE_ARGS -DBUILD_TESTING=OFF)
  list(APPEND Jaeger_CMAKE_ARGS --DCMAKE_INSTALL_PREFIX=<Jaeger_INSTALL_DIR>)

  include(BuildOpenTracing)
  build_opentracing()
  include(Buildthrift)
  build_thrift()
  find_package(yaml-cpp REQUIRED)

  if(CMAKE_MAKE_PROGRAM MATCHES "make")
    # try to inherit command line arguments passed by parent "make" job
    set(make_cmd $(MAKE) Jaeger)
  else()
    set(make_cmd ${CMAKE_COMMAND} --build <BINARY_DIR> --target Jaeger)
  endif()

  include(ExternalProject)
  ExternalProject_Add(Jaeger
    GIT_REPOSITORY "https://github.com/jaegertracing/jaeger-client-cpp.git"
    GIT_TAG "origin/v0.5.0"
    UPDATE_COMMAND "" #disables update on each run
    DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}
    SOURCE_DIR ${Jaeger_SOURCE_DIR}
    PREFIX ${Jaeger_ROOT_DIR}
    CMAKE_ARGS ${Jaeger_CMAKE_ARGS}
    BINARY_DIR ${Jaeger_BINARY_DIR}
    BUILD_COMMAND ${make_cmd}
    BUILD_ALWAYS TRUE
    INSTALL_COMMAND "true"
    DEPENDS OpenTracing thrift #yaml-cpp nlohmann-json
    )
endfunction()
