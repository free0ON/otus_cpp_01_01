cmake_minimum_required(VERSION 3.2)

# Project innformation
set(PRJ_NAME "helloworld" "Project name")
set(PRJ_VERSION "0.0.1" "Project version")
set(EMAIL_CONTACT "dmitrii.lozovoi@yandex.ru" "Email contact")
unset(PROJECT_VERSION)
unset(PROJECT_MAJOR_VERSION)
unset(PROJECT_MINOR_VERSION)
unset(PROJECT_PATCH_VERSION)

unset(PROJECT_NAME)


# Test options
option(BOOST_TEST "Boost test" ON)
option(GOOGLE_TEST "Google test" OFF)
option(CATCH2_TEST "Catch2 test" OFF)

project(${PRJ_NAME} VERSION ${PRJ_VERSION} LANGUAGES CXX)
message("PROJECT_NAME: ${PRJ_NAME} VERSION: ${PRJ_VERSION}")
configure_file(version.h.in version.h)
add_library(${PRJ_NAME} lib.cpp)
add_executable(${PRJ_NAME}_cli main.cpp)
set_target_properties(${PRJ_NAME}_cli ${PRJ_NAME} PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
)
target_include_directories(${PRJ_NAME}
    PRIVATE "${CMAKE_BINARY_DIR}"
)

target_link_libraries(${PRJ_NAME}_cli PRIVATE
    ${PRJ_NAME}
)
if(BOOST_TEST)
    find_package(Boost COMPONENTS unit_test_framework REQUIRED)
    add_executable(boost_test_version test_version.cpp)
    set_target_properties( boost_test_version PROPERTIES
        CXX_STANDARD 14
        CXX_STANDARD_REQUIRED ON
    )
    set_target_properties(
        boost_test_version PROPERTIES
        COMPILE_DEFINITIONS BOOST_TEST_DYN_LINK)   
    target_link_libraries(
        boost_test_version
        ${Boost_LIBRARIES}
        ${PRJ_NAME})
    enable_testing()
    add_test(boost_test_version boost_test_version)
    if (MSVC)
        target_compile_options(boost_test_version PRIVATE  /W4)
    else()
        target_compile_options(
            boost_test_version PRIVATE
            -Wall -Wextra -pedantic -Werror)
    endif(MSVC)
endif(BOOST_TEST)
if(GOOGLE_TEST)
    find_package(GTest REQUIRED)
    add_executable(google_test_version google_test_version.cpp)
    set_target_properties(google_test_version PROPERTIES
        CXX_STANDARD 14
        CXX_STANDARD_REQUIRED ON
    )
    target_link_libraries(
        google_test_version 
        gtest gtest_main 
        ${PRJ_NAME})
    #enable_testing()
    include(GoogleTest)
    add_test(google_test_version google_test_version)
    if (MSVC)
        target_compile_options(google_test_version PRIVATE  /W4)
    else()
        target_compile_options(
            google_test_version PRIVATE
            -Wall -Wextra -pedantic -Werror)
    endif(MSVC)
endif(GOOGLE_TEST)
if(CATCH2_TEST)
    find_package(Catch2 REQUIRED)
    add_executable(catch2_test_version catch2_test_version.cpp)
    set_target_properties(catch2_test_version PROPERTIES
        CXX_STANDARD 14
        CXX_STANDARD_REQUIRED ON
    )
    target_link_libraries(
        catch2_test_version 
        PRIVATE Catch2::Catch2 Catch2::Catch2WithMain 
        ${PRJ_NAME})
    enable_testing()
    include(Catch)
    include(CTest)
    add_test(catch2_test_version catch2_test_version)
    if (MSVC)
        target_compile_options(catch2_test_version PRIVATE  /W4)
    else()
        target_compile_options(
            catch2_test_version PRIVATE
            -Wall -Wextra -pedantic -Werror)
    endif(MSVC)
endif(CATCH2_TEST)

if (MSVC)
    target_compile_options(${PRJ_NAME}_cli PRIVATE
        /W4
    )
    target_compile_options(${PRJ_NAME} PRIVATE
        /W4
    )
else ()
    target_compile_options(${PRJ_NAME}_cli PRIVATE
        -Wall -Wextra -pedantic -Werror
    )
    target_compile_options(${PRJ_NAME} PRIVATE
        -Wall -Wextra -pedantic -Werror
    )
endif(MSVC)

install(TARGETS ${PRJ_NAME}_cli RUNTIME DESTINATION bin)

set(CPACK_GENERATOR DEB)
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

set(CPACK_PACKAGE_CONTACT "${EMAIL_CONTACT}")

include(CPack)
