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

set (LIBS ${DEPS_LIBRARIES} -lm)
set (LIB_PATHS ${DEPS_LIBRARY_DIRS})
link_directories (${LIB_PATHS})

set (LIB_FILES ${C_SOURCES} ${VALA_C})

add_library (${LIBNAME} STATIC
    ${LIB_FILES}
)

target_link_libraries (${LIBNAME} ${LIBS})
