mkdir build
cd build
cmake .. -DGOOGLE_TEST=OFF -DCATCH2_TEST=OFF -DPATCH_VERSION=10
cmake --build . 
cmake --build . --target test
cmake --build . --target package
helloworld_cli
