# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.13

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


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
CMAKE_SOURCE_DIR = /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build

# Include any dependencies generated for this target.
include CMakeFiles/serial.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/serial.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/serial.dir/flags.make

CMakeFiles/serial.dir/src/serial.cc.o: CMakeFiles/serial.dir/flags.make
CMakeFiles/serial.dir/src/serial.cc.o: ../src/serial.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/serial.dir/src/serial.cc.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/serial.dir/src/serial.cc.o -c /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/serial.cc

CMakeFiles/serial.dir/src/serial.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/serial.dir/src/serial.cc.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/serial.cc > CMakeFiles/serial.dir/src/serial.cc.i

CMakeFiles/serial.dir/src/serial.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/serial.dir/src/serial.cc.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/serial.cc -o CMakeFiles/serial.dir/src/serial.cc.s

CMakeFiles/serial.dir/src/impl/unix.cc.o: CMakeFiles/serial.dir/flags.make
CMakeFiles/serial.dir/src/impl/unix.cc.o: ../src/impl/unix.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/serial.dir/src/impl/unix.cc.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/serial.dir/src/impl/unix.cc.o -c /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/impl/unix.cc

CMakeFiles/serial.dir/src/impl/unix.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/serial.dir/src/impl/unix.cc.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/impl/unix.cc > CMakeFiles/serial.dir/src/impl/unix.cc.i

CMakeFiles/serial.dir/src/impl/unix.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/serial.dir/src/impl/unix.cc.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/impl/unix.cc -o CMakeFiles/serial.dir/src/impl/unix.cc.s

CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.o: CMakeFiles/serial.dir/flags.make
CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.o: ../src/impl/list_ports/list_ports_linux.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.o -c /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/impl/list_ports/list_ports_linux.cc

CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/impl/list_ports/list_ports_linux.cc > CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.i

CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/src/impl/list_ports/list_ports_linux.cc -o CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.s

# Object files for target serial
serial_OBJECTS = \
"CMakeFiles/serial.dir/src/serial.cc.o" \
"CMakeFiles/serial.dir/src/impl/unix.cc.o" \
"CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.o"

# External object files for target serial
serial_EXTERNAL_OBJECTS =

devel/lib/libserial.so: CMakeFiles/serial.dir/src/serial.cc.o
devel/lib/libserial.so: CMakeFiles/serial.dir/src/impl/unix.cc.o
devel/lib/libserial.so: CMakeFiles/serial.dir/src/impl/list_ports/list_ports_linux.cc.o
devel/lib/libserial.so: CMakeFiles/serial.dir/build.make
devel/lib/libserial.so: CMakeFiles/serial.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX shared library devel/lib/libserial.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/serial.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/serial.dir/build: devel/lib/libserial.so

.PHONY : CMakeFiles/serial.dir/build

CMakeFiles/serial.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/serial.dir/cmake_clean.cmake
.PHONY : CMakeFiles/serial.dir/clean

CMakeFiles/serial.dir/depend:
	cd /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build /home/yujie6/Music/CSAPP/Arch2019/RiscV-CPU/serial/build/CMakeFiles/serial.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/serial.dir/depend

