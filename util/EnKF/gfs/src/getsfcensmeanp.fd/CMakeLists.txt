cmake_minimum_required(VERSION 2.6)
if(BUILD_UTIL)
  file(GLOB LOCAL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.f90)
  set_source_files_properties( ${LOCAL_SRC} PROPERTIES COMPILE_FLAGS ${UTIL_Fortran_FLAGS} )
  add_executable( getsfcensmeanp.x  ${LOCAL_SRC} )
  set_target_properties(  getsfcensmeanp.x PROPERTIES COMPILE_FLAGS ${UTIL_Fortran_FLAGS} )
  SET( CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_Fortran_FLAGS}" )
  include_directories( ${NEMSIOINC} ${SFCIOINC} ${NETCDF_INCLUDES}  ${FV3GFS_NCIO_INCS}) 
  target_link_libraries( getsfcensmeanp.x ${BACIO_LIBRARY} ${NEMSIO_LIBRARY} ${BACIO_LIBRARY} ${SFCIO_LIBRARY} ${W3NCO_4_LIBRARY} ${MPI_Fortran_LIBRARIES} ${NETCDF_LIBRARIES_F90} ${NETCDF_LIBRARIES}  ${FV3GFS_NCIO_LIBRARIES} )
endif()
