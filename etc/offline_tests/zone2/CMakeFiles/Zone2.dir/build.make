# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.2

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /src/ax/etc/offline_tests/zone2

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /src/ax/etc/offline_tests/zone2

# Include any dependencies generated for this target.
include CMakeFiles/Zone2.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Zone2.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Zone2.dir/flags.make

CMakeFiles/Zone2.dir/zone2.cpp.o: CMakeFiles/Zone2.dir/flags.make
CMakeFiles/Zone2.dir/zone2.cpp.o: zone2.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /src/ax/etc/offline_tests/zone2/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/Zone2.dir/zone2.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/Zone2.dir/zone2.cpp.o -c /src/ax/etc/offline_tests/zone2/zone2.cpp

CMakeFiles/Zone2.dir/zone2.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Zone2.dir/zone2.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /src/ax/etc/offline_tests/zone2/zone2.cpp > CMakeFiles/Zone2.dir/zone2.cpp.i

CMakeFiles/Zone2.dir/zone2.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Zone2.dir/zone2.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /src/ax/etc/offline_tests/zone2/zone2.cpp -o CMakeFiles/Zone2.dir/zone2.cpp.s

CMakeFiles/Zone2.dir/zone2.cpp.o.requires:
.PHONY : CMakeFiles/Zone2.dir/zone2.cpp.o.requires

CMakeFiles/Zone2.dir/zone2.cpp.o.provides: CMakeFiles/Zone2.dir/zone2.cpp.o.requires
	$(MAKE) -f CMakeFiles/Zone2.dir/build.make CMakeFiles/Zone2.dir/zone2.cpp.o.provides.build
.PHONY : CMakeFiles/Zone2.dir/zone2.cpp.o.provides

CMakeFiles/Zone2.dir/zone2.cpp.o.provides.build: CMakeFiles/Zone2.dir/zone2.cpp.o

# Object files for target Zone2
Zone2_OBJECTS = \
"CMakeFiles/Zone2.dir/zone2.cpp.o"

# External object files for target Zone2
Zone2_EXTERNAL_OBJECTS =

Zone2: CMakeFiles/Zone2.dir/zone2.cpp.o
Zone2: CMakeFiles/Zone2.dir/build.make
Zone2: CMakeFiles/Zone2.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable Zone2"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Zone2.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Zone2.dir/build: Zone2
.PHONY : CMakeFiles/Zone2.dir/build

CMakeFiles/Zone2.dir/requires: CMakeFiles/Zone2.dir/zone2.cpp.o.requires
.PHONY : CMakeFiles/Zone2.dir/requires

CMakeFiles/Zone2.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Zone2.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Zone2.dir/clean

CMakeFiles/Zone2.dir/depend:
	cd /src/ax/etc/offline_tests/zone2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /src/ax/etc/offline_tests/zone2 /src/ax/etc/offline_tests/zone2 /src/ax/etc/offline_tests/zone2 /src/ax/etc/offline_tests/zone2 /src/ax/etc/offline_tests/zone2/CMakeFiles/Zone2.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Zone2.dir/depend

