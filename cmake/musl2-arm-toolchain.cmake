### options for particular usages

option(MUSL_ARM_STATIC_TRY_COMPILE
	   "Set try_compile target type" OFF)
option(MUSL_ARM_FORCE_USE_COMPILER_RT
	   "Append linker flags to compiler flags, so that clang will use llvm's components." OFF)

### basic cmake options

set(CMAKE_SYSTEM_NAME Linux) # CMAKE_CROSSCOMPILING is set to ON automatically by this
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# switch the try_compile mode, try this option when you meet errors during cmake configuring
if(MUSL_ARM_STATIC_TRY_COMPILE)
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY) # magic option...
endif()

### set sysroot, it's expected with /usr/arm-linux-musleabihf
if(DEFINED CMAKE_SYSROOT)
	# get from command arguments
	message("CMAKE_SYSROOT is set directly: ${CMAKE_SYSROOT}")
elseif((EXISTS $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT}) AND
	   (IS_DIRECTORY $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT}))
	# get from environment, your own CMAKE_SYSROOT may be discarded when compiling qt
	set(CMAKE_SYSROOT $ENV{MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT})
	message("CMAKE_SYSROOT is set from env: ${CMAKE_SYSROOT}")
else()
	# sysroot is REQUIRED
	message(FATAL_ERROR [[
		No 'CMAKE_SYSROOT' has been set yet!
		If you have already set the 'CMAKE_SYSROOT' before but no effect,
		You can try to set the environment variable 'MUSL_ARM_EXPLICIT_SET_CMAKE_SYSROOT'.
	]])
endif()

# limit the search path of programs and libraries
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH) # BOTH to enable find_package to search CMAKE_PREFIX_PATH

### set compiler as Clang

set(CMAKE_ASM_COMPILER /bin/clang)
set(CMAKE_C_COMPILER   /bin/clang)
set(CMAKE_CXX_COMPILER /bin/clang++)

# compiler target triple
set(CLANG_TARGET_TRIPLE "arm-linux-musleabihf")
set(CMAKE_ASM_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})
set(CMAKE_C_COMPILER_TARGET   ${CLANG_TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})

# let CMake use -std=c++** instead of -std=gnu++**
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)

### variables to form the flags

# specify cpu infos of target platform
set(CLANG_PLATFORM_FLAGS "-mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard")

# set include directories
#   Note: Headers from C++ standard library should be included BEFORE those from C standard library.
#   For example, 'signbit'(in math.h) is required to be a macro in C standard.
#   However, by writing another math.h as an overlay header, libc++ made it be a template,
#   and use 'include_next' to import C 'math.h' for compatiable.
set(MUSL_ARM_LIBCXX_INCLUDE_DIR  ${CMAKE_SYSROOT}/include/c++/v1)
set(MUSL_ARM_CUSTOM_INCLUDE_DIR  ${CMAKE_SYSROOT}/include)
set(MUSL_ARM_SYSTEM_INCLUDE_DIR  ${CMAKE_SYSROOT}/../include)
cmake_path(NORMAL_PATH MUSL_ARM_SYSTEM_INCLUDE_DIR)
set(CLANG_USE_LIBCXX_COMPILER_FLAGS
	"-nostdlib++ \
	 -isystem${MUSL_ARM_LIBCXX_INCLUDE_DIR} \
	 -isystem${MUSL_ARM_CUSTOM_INCLUDE_DIR} \
	 -isystem${MUSL_ARM_SYSTEM_INCLUDE_DIR}"
)
# C compiler should not search for C++ headers
set(CLANG_USE_MUSL_COMPILER_FLAGS
	"-isystem${MUSL_ARM_CUSTOM_INCLUDE_DIR} \
	 -isystem${MUSL_ARM_SYSTEM_INCLUDE_DIR}"
)

# library search directories
set(MUSL_ARM_CUSTOM_LIB_DIR ${CMAKE_SYSROOT}/lib)

# indicate clang to use llvm's components when linking
set(CLANG_USE_LLVM_LINKER_FLAGS
	"-fuse-ld=lld -rtlib=compiler-rt -unwindlib=libunwind")

### final flags
set(CLANG_C_COMPILER_FLAGS   "${CLANG_PLATFORM_FLAGS} ${CLANG_USE_MUSL_COMPILER_FLAGS}")
set(CLANG_CXX_COMPILER_FLAGS "${CLANG_PLATFORM_FLAGS} ${CLANG_USE_LIBCXX_COMPILER_FLAGS}")
set(CLANG_LINKER_FLAGS "${CLANG_USE_LLVM_LINKER_FLAGS} -L ${MUSL_ARM_CUSTOM_LIB_DIR} -lc++")

# append link flags to compile flags if need
if(MUSL_ARM_FORCE_USE_COMPILER_RT)
	# this will force clang to use compiler-rt, but may generate too many warnings.
	set(CLANG_C_COMPILER_FLAGS   "${CLANG_C_COMPILER_FLAGS}   ${CLANG_LINKER_FLAGS} -Wno-unused-command-line-argument")
	set(CLANG_CXX_COMPILER_FLAGS "${CLANG_CXX_COMPILER_FLAGS} ${CLANG_LINKER_FLAGS} -Wno-unused-command-line-argument")
endif()

set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${CLANG_COMPILER_FLAGS}")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${CLANG_C_COMPILER_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_CXX_COMPILER_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    ${CLANG_LINKER_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${CLANG_LINKER_FLAGS}")

### add addition toolchain
if(MUSL_ARM_CHAINLOAD_TOOLCHAIN_FILE)
    include(${MUSL_ARM_CHAINLOAD_TOOLCHAIN_FILE})
endif()
