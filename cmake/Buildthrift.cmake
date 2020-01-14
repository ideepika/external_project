#This module builds thrift
#HINT: THRIFT_J: integer(default 1)

function(build_thrift)
  set(THRIFT_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/thrift")
  set(THRIFT_ROOT_DIR "${CMAKE_CURRENT_BINARY_DIR}/src/thrift")
  set(THRIFT_INSTALL_DIR "${THRIFT_ROOT_DIR}/install")
  set(THRIFT_BINARY_DIR "${THRIFT_ROOT_DIR}/build")

  set(THRIFT_CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON)
  list(APPEND THRIFT_CMAKE_ARGS -DBUILD_SHARED_LIBS=ON)

  if(CMAKE_MAKE_PROGRAM MATCHES "make")
    # try to inherit command line arguments passed by parent "make" job
    set(make_cmd $(MAKE))
  else()
    set(make_cmd ${CMAKE_COMMAND} --build <BINARY_DIR> --target thrift)
  endif()

  include(ExternalProject)
  ExternalProject_Add(thrift
    URL http://archive.apache.org/dist/thrift/0.11.0/thrift-0.11.0.tar.gz
    DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/src
    SOURCE_DIR ${THRIFT_SOURCE_DIR}
    CONFIGURE_COMMAND ./bootstrap.sh && ./configure --prefix=<INSTALL_DIR>
    CMAKE_ARGS ${THRIFT_CMAKE_ARGS}
    BUILD_IN_SOURCE 1
    BUILD_COMMAND ${make_cmd}
    INSTALL_COMMAND make install
    )
endfunction()
