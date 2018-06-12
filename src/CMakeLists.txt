# Create Constants.vala
configure_file (${CMAKE_CURRENT_SOURCE_DIR}/configs/Constants.vala.cmake ${CMAKE_CURRENT_SOURCE_DIR}/configs/Constants.vala)

INCLUDE (ValaPrecompile)
VALA_PRECOMPILE (VALA_C ${LIBNAME}
    configs/Constants.vala
    configs/Properties.vala
    utils/QuoteClient.vala
    widgets/Toolbar.vala
    widgets/QuoteStack.vala
    MainWindow.vala
    Application.vala

PACKAGES
    ${APPLICATION_DEPS}

GENERATE_VAPI
    ${LIBNAME}
GENERATE_HEADER
    ${LIBNAME}
GENERATE_INTERNAL_VAPI
    ${LIBNAME}_internal
GENERATE_INTERNAL_HEADER
    ${LIBNAME}_internal
)

SET (LIBS ${DEPS_LIBRARIES} -lm)
SET (LIB_PATHS ${DEPS_LIBRARY_DIRS})
LINK_DIRECTORIES (${LIB_PATHS})

SET (LIB_FILES ${C_SOURCES} ${VALA_C})

ADD_LIBRARY (${LIBNAME} STATIC
    ${LIB_FILES}
)

TARGET_LINK_LIBRARIES (${LIBNAME} ${LIBS})
