# CMake minimum version
set(PRJ_CMAKE_MIN_VERSION 3.2 CACHE INTERNAL "CMake version")
cmake_minimum_required(VERSION ${PRJ_CMAKE_MIN_VERSION})
# Project information
set(PRJ_NAME "helloworld" CACHE INTERNAL "Project name")
set(PRJ_VERSION_MAJOR "0" CACHE INTERNAL "Minor version")
set(PRJ_VERSION_MINOR "0" CACHE INTERNAL "Major version")
set(PRJ_VERSION_PATCH "1" CACHE INTERNAL "Patch version")
set(PRJ_DESCRIPTION "Helloworld project" CACHE INTERNAL "Project description")
set(PRJ_HOMEPAGE_URL "https://github.com/free0ON/otus_cpp_01_01" CACHE INTERNAL "Project URL")
set(EMAIL_CONTACT "dmitrii.lozovoi@yandex.ru" CACHE INTERNAL "Email contact")

# Test options
option(BOOST_TEST "Boost test" ON)
option(GOOGLE_TEST "Google test" OFF)
option(CATCH2_TEST "Catch2 test" OFF)

project(${PRJ_NAME} VERSION ${PRJ_VERSION_MAJOR}.${PRJ_VERSION_MINOR}.${PRJ_VERSION_PATCH} DESCRIPTION "${PRJ_DESCRIPTION}" HOMEPAGE_URL "${PRJ_HOMEPAGE_URL}")
message("PROJECT_NAME: ${PROJECT_NAME} VERSION: ${PROJECT_VERSION}")
message("BOOST_TEST: ${BOOST_TEST} GOOGLE_TEST: ${GOOGLE_TEST} CATCH2_TEST: ${CATCH2_TEST}")
message("DESCRIPTION: ${PRJ_DESCRIPTION}")
message("HOMEPAGE_URL: ${PRJ_HOMEPAGE_URL}")
message("CMAKE_MINIMUM_REQUIRED_VERSION: ${CMAKE_MINIMUM_REQUIRED_VERSION}")

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
set(CPACK_PACKAGE_VERSION_MAJOR "${PRJ_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PRJ_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PRJ_VERSION_PATCH}")

set(CPACK_PACKAGE_CONTACT "${EMAIL_CONTACT}")

include(CPack)
