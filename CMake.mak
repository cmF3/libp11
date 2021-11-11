BuildDir = buildDir
InstallPrefix = $(BuildDir)/_local_export

all: debug release

debug:
	cmake -G "Unix Makefiles" -S. -B$(BuildDir)/$@ -DCMAKE_BUILD_TYPE=DEBUG -DCMAKE_INSTALL_PREFIX=$(InstallPrefix)/$@
	cmake --build $(BuildDir)/$@ --target install $(CMAKE_TARGET)

release:
	cmake -G "Unix Makefiles" -S. -B$(BuildDir)/$@ -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=$(InstallPrefix)/$@
	cmake --build $(BuildDir)/$@ --target install $(CMAKE_TARGET)
