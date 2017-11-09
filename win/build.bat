cmake -E make_directory build
cmake -E make_directory packages
cd build
call "%VS140COMNTOOLS%\..\..\VC\vcvarsall" x64
cmake ..  -DCMAKE_INSTALL_PREFIX=..\packages -G "Visual Studio 14 2015 Win64"
cmake --build . --config Release
PAUSE
