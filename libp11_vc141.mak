ComponentName = libp11
CMakeExe = .\BuildTools\cmake\bin\cmake.exe
BuildDir = buildDir
InstallPrefix = $(BuildDir)\_local_export
OpenSSLRoot32 = .\openssl-1.1.1l\openssl-1.1\x86
OpenSSLRoot64 = .\openssl-1.1.1l\openssl-1.1\x64

all: v1032 v1064 v1432 v1464 changelog remove_dependencies fini

init:
  cd $(ComponentName)
  if not exist $(BuildDir) mkdir $(BuildDir)
  $(CMakeExe) --version

v1032: init
  @echo "Build solution $(ComponentName) ($@)"
  $(CMakeExe) -G "Visual Studio 15 2017" -A "Win32" -T v100 -S. -B$(BuildDir)\$@ -DCMAKE_CTEST_ARGUMENTS=--extra-verbose -DCMAKE_INSTALL_PREFIX=$(InstallPrefix) -DOPENSSL_ROOT_DIR=$(OpenSSLRoot32)
  $(CMakeExe) --build $(BuildDir)\$@ --config Debug --target install $(CMAKE_TARGET)
  $(CMakeExe) --build $(BuildDir)\$@ --config Release --target install $(CMAKE_TARGET)

v1064: init
  @echo "Build solution $(ComponentName) ($@)"
  $(CMakeExe) -G "Visual Studio 15 2017" -A "x64" -T v100 -S. -B$(BuildDir)\$@ -DCMAKE_CTEST_ARGUMENTS=--extra-verbose -DCMAKE_INSTALL_PREFIX=$(InstallPrefix) -DOPENSSL_ROOT_DIR=$(OpenSSLRoot64)
  $(CMakeExe) --build $(BuildDir)\$@ --config Debug --target install $(CMAKE_TARGET)
  $(CMakeExe) --build $(BuildDir)\$@ --config Release --target install $(CMAKE_TARGET)

v1432: init
  @echo "Build solution $(ComponentName) ($@)"
  $(CMakeExe) -G "Visual Studio 15 2017" -A "Win32" -T v141 -S. -B$(BuildDir)\$@ -DCMAKE_CTEST_ARGUMENTS=--extra-verbose -DCMAKE_INSTALL_PREFIX=$(InstallPrefix) -DOPENSSL_ROOT_DIR=$(OpenSSLRoot32)
  $(CMakeExe) --build $(BuildDir)\$@ --config Debug --target install $(CMAKE_TARGET)
  $(CMakeExe) --build $(BuildDir)\$@ --config Release --target install $(CMAKE_TARGET)

v1464: init
  @echo "Build solution $(ComponentName) ($@)"
  $(CMakeExe) -G "Visual Studio 15 2017" -A "x64" -T v141 -S. -B$(BuildDir)\$@ -DCMAKE_CTEST_ARGUMENTS=--extra-verbose -DCMAKE_INSTALL_PREFIX=$(InstallPrefix) -DOPENSSL_ROOT_DIR=$(OpenSSLRoot64)
  $(CMakeExe) --build $(BuildDir)\$@ --config Debug --target install $(CMAKE_TARGET)
  $(CMakeExe) --build $(BuildDir)\$@ --config Release --target install $(CMAKE_TARGET)

changelog: init
  git log --no-merges --date=short --pretty=format:"## %%cd %%cn %%n %%s%%n" >$(ComponentName)_changelog.md

remove_dependencies: init
  build\dependency_eater.cmd $(ComponentName)_vc141

fini: init
  cd ..