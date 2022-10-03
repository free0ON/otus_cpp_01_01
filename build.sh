mkdir build
cd build
cmake .. -DPRJ_CMAKE_MIN_VERSION="3.3" -DPRJ_NAME=helloworld \
-DPRJ_VERSION_MAJOR=0 -DPRJ_VERSION_MINOR=0 -DPRJ_VERSION_PATCH=77 \
-DPRJ_DESCRIPTION="Test program" \
-DPRJ_HOMEPAGE_URL="https://github.com/free0ON/otus_cpp_01_01" \
-DEMAIL_CONTACT=dmitrii.lozovoi@yandex.ru \
-DGOOGLE_TEST=ON -DBOOST_TEST=ON -DCATCH2_TEST=ON
cmake --build . 
cmake --build . --target test
cmake --build . --target package
helloworld_cli