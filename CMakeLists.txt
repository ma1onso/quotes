PROJECT (com.github.alonsoenrique.quotes)

CMAKE_MINIMUM_REQUIRED (VERSION 3.0)

LIST (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
LIST (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

SET (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
SET (PKGDATADIR, "${DATADIR}/com.github.alonsoenrique.quotes")

SET (APP_ID "com.github.alonsoenrique.quotes")
SET (EXEC_NAME "com.github.alonsoenrique.quotes")
SET (RELEASE_NAME "Quotes for daily inspiration")
SET (VERSION "0.5.6")
SET (VERSION_INFO "Initial release")

SET (APIVERSION 0)
SET (LIBNAME ${EXEC_NAME}-${APIVERSION})
SET (LIBVERSION "0")
SET (SOVERSION 0)

# The path where library files should be searched for
set (LIBRARY_PATH "src")

FIND_PACKAGE (PkgConfig)

PKG_CHECK_MODULES (DEPS REQUIRED gtk+-3.0 libsoup-2.4 json-glib-1.0)
SET(APPLICATION_DEPS
    gtk+-3.0>=3.12
    libsoup-2.4
    json-glib-1.0
)

ADD_DEFINITIONS (${DEPS_CFLAGS})
LINK_LIBRARIES (${DEPS_LIBRARIES})
LINK_DIRECTORIES (${DEPS_LIBRARIES_DIRS})

FIND_PACKAGE (Vala REQUIRED)
INCLUDE (ValaVersion)
ENSURE_VALA_VERSION ("0.26" MINIMUM)

add_subdirectory (src)

INCLUDE (ValaPrecompile)
VALA_PRECOMPILE (VALA_C ${EXEC_NAME}
    src/Main.vala

PACKAGES
    ${APPLICATION_DEPS}
    
CUSTOM_VAPIS
    ${CMAKE_BINARY_DIR}/${LIBRARY_PATH}/${LIBNAME}_internal.vapi
)

INCLUDE (GResource)

GLIB_COMPILE_RESOURCES (GLIB_RESOURCES_ICONS SOURCE data/images/icons/icons.gresource.xml)
GLIB_COMPILE_RESOURCES (GLIB_RESOURCES_CSS SOURCE data/css/css.gresource.xml)

INCLUDE (GSettings)
ADD_SCHEMA ("data/com.github.alonsoenrique.quotes.gschema.xml")

# tell cmake what to call the executable we just made
ADD_EXECUTABLE (${EXEC_NAME} ${VALA_C} ${GLIB_RESOURCES_ICONS} ${GLIB_RESOURCES_CSS})
add_dependencies (${EXEC_NAME} ${LIBNAME})
target_link_libraries (${EXEC_NAME} ${DEPS_LIBRARIES} ${LIBNAME})

set_target_properties (${EXEC_NAME} PROPERTIES
    INCLUDE_DIRECTORIES ${CMAKE_BINARY_DIR}/${LIBRARY_PATH}
)

INSTALL (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.alonsoenrique.quotes.desktop DESTINATION ${DATADIR}/applications/)
INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.alonsoenrique.quotes.appdata.xml DESTINATION ${DATADIR}/metainfo/)

INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/16/com.github.alonsoenrique.quotes.svg DESTINATION ${DATADIR}/icons/hicolor/16x16/apps/)
INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/24/com.github.alonsoenrique.quotes.svg DESTINATION ${DATADIR}/icons/hicolor/24x24/apps/)
INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/32/com.github.alonsoenrique.quotes.svg DESTINATION ${DATADIR}/icons/hicolor/32x32/apps/)
INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/48/com.github.alonsoenrique.quotes.svg DESTINATION ${DATADIR}/icons/hicolor/48x48/apps/)
INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/64/com.github.alonsoenrique.quotes.svg DESTINATION ${DATADIR}/icons/hicolor/64x64/apps/)
INSTALL (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/128/com.github.alonsoenrique.quotes.svg DESTINATION ${DATADIR}/icons/hicolor/128x128/apps/)

OPTION (BUILD_TESTS "Build a unit test executable." OFF)

if (BUILD_TESTS)
    add_subdirectory (tests)
endif (BUILD_TESTS)
