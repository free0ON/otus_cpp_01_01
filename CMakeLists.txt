cmake_minimum_required(VERSION 3.2)

option(BOOST_TEST "Boost test" ON)
option(GOOGLE_TEST "Google test" ON)
option(CATCH2_TEST "Catch2 test" ON)

set(PATCH_VERSION "1" CACHE INTERNAL "Patch version")
message("PATCH_VERSION: ${PATCH_VERSION}")
set(PROJECT_VESRION 0.0.${PATCH_VERSION})
message("PROJECT_VESRION: ${PROJECT_VESRION}")
message(${PROJECT_VESRION})

if (GITHUB_RUN_NUMBER)
	project(helloworld VERSION 0.0.$ENV{GITHUB_RUN_NUMBER})
	message("PROJECT_VERSION_PATCH: ${PROJECT_VERSION_PATCH}")
else()
	project(helloworld VERSION ${PROJECT_VESRION})
	message("PROJECT_VERSION_PATCH: ${PROJECT_VERSION_PATCH}")
endif(GITHUB_RUN_NUMBER)

configure_file(version.h.in version.h)
add_library(helloworld lib.cpp)
add_executable(helloworld_cli main.cpp)
set_target_properties(helloworld_cli helloworld PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
)
target_include_directories(helloworld
    PRIVATE "${CMAKE_BINARY_DIR}"
)

target_link_libraries(helloworld_cli PRIVATE
    helloworld
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
        helloworld)
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
        helloworld)
    enable_testing()
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
        helloworld)
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
    target_compile_options(helloworld_cli PRIVATE
        /W4
    )
    target_compile_options(helloworld PRIVATE
        /W4
    )
    target_compile_options(boost_test_version PRIVATE
        /W4
    )
    target_compile_options(google_test_version PRIVATE
        /W4
    )
else ()
    target_compile_options(helloworld_cli PRIVATE
        -Wall -Wextra -pedantic -Werror
    )
    target_compile_options(helloworld PRIVATE
        -Wall -Wextra -pedantic -Werror
    )


endif()



install(TARGETS helloworld_cli RUNTIME DESTINATION bin)

set(CPACK_GENERATOR DEB)
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

set(CPACK_PACKAGE_CONTACT Dmitrii.Lozovoi@yandex.ru)

include(CPack)



