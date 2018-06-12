SET (TEST_EXEC_NAME ${APP_ID}-tests)

# files we want to compile
INCLUDE (ValaPrecompile)
VALA_PRECOMPILE (VALA_C ${TEST_EXEC_NAME}
    TestCase.vala
    ConstantsTest.vala
    TestMain.vala

# tell what libraries to use when compiling
PACKAGES
    ${APPLICATION_DEPS}

CUSTOM_VAPIS
    ${CMAKE_BINARY_DIR}/${LIBRARY_PATH}/${LIBNAME}_internal.vapi
)

# tell cmake what to call the executable we just made
ADD_EXECUTABLE (${TEST_EXEC_NAME} ${VALA_C})
ADD_DEPENDENCIES (${TEST_EXEC_NAME} ${LIBNAME})
TARGET_LINK_LIBRARIES (${TEST_EXEC_NAME} ${DEPS_LIBRARIES} ${LIBNAME})

SET_TARGET_PROPERTIES (${TEST_EXEC_NAME} PROPERTIES
    INCLUDE_DIRECTORIES ${CMAKE_BINARY_DIR}/${LIBRARY_PATH}
)
