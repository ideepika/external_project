function(build_thrift)
  set(THRIFT_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/thrift")
  set(THRIFT_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/thrift/install")
  set(THRIFT_BINARY_DIR "${THRIFT_SOURCE_DIR}/build")

  set(THRIFT_CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON)
  list(APPEND THRIFT_CMAKE_ARGS -DBUILD_SHARED_LIBS=ON)
  #  list(APPEND THRIFT_CMAKE_ARGS --DCMAKE_INSTALL_PREFIX=<THRIFT_INSTALL_DIR>)

  if(CMAKE_MAKE_PROGRAM MATCHES "make")
    # try to inherit command line arguments passed by parent "make" job
    set(make_cmd $(MAKE) thrift)
  else()
    set(make_cmd ${CMAKE_COMMAND} --build <BINARY_DIR> --target thrift)
  endif()

  include(ExternalProject)
  include(CheckIncludeFileCXX)
  ExternalProject_Add(thrift
    GIT_REPOSITORY "https://github.com/apache/thrift.git"
    GIT_TAG "origin/0.11.0"
    UPDATE_COMMAND "${THRIFT_SOURCE_DIR}/bootstrap.sh &&
    ${THRIFT_SOURCE_DIR}/configure" #disables update on each run
    DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/src
    SOURCE_DIR ${THRIFT_SOURCE_DIR}
    BINARY_DIR ${THRIFT_BINARY_DIR}
    CMAKE_ARGS ${THRIFT_CMAKE_ARGS}
    BUILD_COMMAND ${make_cmd}
    BUILD_ALWAYS TRUE
    INSTALL_COMMAND "true"
    )

  CHECK_INCLUDE_FILE_CXX("thrift/Thrift.h" HAVE_THRIFT)
endfunction()
