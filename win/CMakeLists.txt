cmake_minimum_required(VERSION 3.5)

include(ExternalProject)

project(ExternalLibs)

enable_language(C)

find_program(NMAKE nmake)

set(INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install)
set(TCLTK_INSTALL_DIR ${INSTALL_DIR}/tcltk)
set(ZLIB_INSTALL_DIR ${INSTALL_DIR}/zlib)

file(GLOB TCL_INT_HEADERS
	${CMAKE_CURRENT_SOURCE_DIR}/tcl/*/tcl*Int*.h
	${CMAKE_CURRENT_SOURCE_DIR}/tcl/*/tcl*Port*.h
)
file(GLOB TK_INT_HEADERS
	${CMAKE_CURRENT_SOURCE_DIR}/tk/*/tk*Int*.h
	${CMAKE_CURRENT_SOURCE_DIR}/tk/*/tk*Port*.h
	${CMAKE_CURRENT_SOURCE_DIR}/tk/win/tkWin.h
)

ExternalProject_Add(tcl_project
	SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tcl/win
	BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tcl/win
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ${NMAKE} -f makefile.vc INSTALLDIR=${TCLTK_INSTALL_DIR}
	INSTALL_COMMAND ${NMAKE} -f makefile.vc install INSTALLDIR=${TCLTK_INSTALL_DIR}
	COMMAND ${CMAKE_COMMAND} -E copy ${TCL_INT_HEADERS} ${TCLTK_INSTALL_DIR}/include/
)

ExternalProject_Add(tk_project
	DEPENDS tcl_project
	SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tk/win
	BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tk/win
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ${NMAKE} -f makefile.vc INSTALLDIR=${TCLTK_INSTALL_DIR} TCLDIR=${CMAKE_CURRENT_SOURCE_DIR}/tcl
	INSTALL_COMMAND ${NMAKE} -f makefile.vc install INSTALLDIR=${TCLTK_INSTALL_DIR} TCLDIR=${CMAKE_CURRENT_SOURCE_DIR}/tcl
	COMMAND ${CMAKE_COMMAND} -E copy ${TK_INT_HEADERS} ${TCLTK_INSTALL_DIR}/include/
)

add_custom_target(zip_tcltk ALL
	DEPENDS tk_project
	COMMAND ${CMAKE_COMMAND} -E tar "cfv"
	"${CMAKE_INSTALL_PREFIX}/tcltk_win64.zip" --format=zip
	bin include lib
	WORKING_DIRECTORY ${TCLTK_INSTALL_DIR}
)

ExternalProject_Add(zlib_project
	SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/zlib
	BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/zlib
	CMAKE_GENERATOR ${CMAKE_GENERATOR}
	CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ZLIB_INSTALL_DIR}
)

add_custom_target(zip_zlib ALL
	DEPENDS zlib_project
	COMMAND ${CMAKE_COMMAND} -E tar "cfv"
	"${CMAKE_INSTALL_PREFIX}/zlib_win64.zip" --format=zip
	bin include lib
	WORKING_DIRECTORY ${ZLIB_INSTALL_DIR}
)

