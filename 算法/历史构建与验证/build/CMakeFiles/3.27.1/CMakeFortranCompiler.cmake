set(CMAKE_Fortran_COMPILER "/opt/GCC/GCC-9.4.0/bin/gfortran")
set(CMAKE_Fortran_COMPILER_ARG1 "")
set(CMAKE_Fortran_COMPILER_ID "GNU")
set(CMAKE_Fortran_COMPILER_VERSION "9.4.0")
set(CMAKE_Fortran_COMPILER_WRAPPER "")
set(CMAKE_Fortran_PLATFORM_ID "")
set(CMAKE_Fortran_SIMULATE_ID "")
set(CMAKE_Fortran_COMPILER_FRONTEND_VARIANT "GNU")
set(CMAKE_Fortran_SIMULATE_VERSION "")




set(CMAKE_AR "/usr/bin/ar")
set(CMAKE_Fortran_COMPILER_AR "/opt/GCC/GCC-9.4.0/bin/gcc-ar")
set(CMAKE_RANLIB "/usr/bin/ranlib")
set(CMAKE_TAPI "CMAKE_TAPI-NOTFOUND")
set(CMAKE_Fortran_COMPILER_RANLIB "/opt/GCC/GCC-9.4.0/bin/gcc-ranlib")
set(CMAKE_COMPILER_IS_GNUG77 1)
set(CMAKE_Fortran_COMPILER_LOADED 1)
set(CMAKE_Fortran_COMPILER_WORKS TRUE)
set(CMAKE_Fortran_ABI_COMPILED TRUE)

set(CMAKE_Fortran_COMPILER_ENV_VAR "FC")

set(CMAKE_Fortran_COMPILER_SUPPORTS_F90 1)

set(CMAKE_Fortran_COMPILER_ID_RUN 1)
set(CMAKE_Fortran_SOURCE_FILE_EXTENSIONS f;F;fpp;FPP;f77;F77;f90;F90;for;For;FOR;f95;F95;f03;F03;f08;F08)
set(CMAKE_Fortran_IGNORE_EXTENSIONS h;H;o;O;obj;OBJ;def;DEF;rc;RC)
set(CMAKE_Fortran_LINKER_PREFERENCE 20)
set(CMAKE_Fortran_LINKER_DEPFILE_SUPPORTED FALSE)
if(UNIX)
  set(CMAKE_Fortran_OUTPUT_EXTENSION .o)
else()
  set(CMAKE_Fortran_OUTPUT_EXTENSION .obj)
endif()

# Save compiler ABI information.
set(CMAKE_Fortran_SIZEOF_DATA_PTR "8")
set(CMAKE_Fortran_COMPILER_ABI "")
set(CMAKE_Fortran_LIBRARY_ARCHITECTURE "x86_64-linux-gnu")

if(CMAKE_Fortran_SIZEOF_DATA_PTR AND NOT CMAKE_SIZEOF_VOID_P)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_Fortran_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_Fortran_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_Fortran_COMPILER_ABI}")
endif()

if(CMAKE_Fortran_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "x86_64-linux-gnu")
endif()





set(CMAKE_Fortran_IMPLICIT_INCLUDE_DIRECTORIES "/opt/GCC/GCC-9.4.0/lib/gcc/x86_64-pc-linux-gnu/9.4.0/finclude;/home/kxzhu/Downloads/xtl/include;/home/kxzhu/Downloads/boost/include;/home/kxzhu/Downloads/xtensor-fftw/include;/home/kxzhu/Downloads/fftw/include;/home/kxzhu/Downloads/xtensor-blas/include;/home/kxzhu/Downloads/xtensor/include;/home/kxzhu/Downloads/lapack/lapack-3.11.0/LAPACKE/include;/home/kxzhu/Dixiao;/opt/GCC/GCC-9.4.0/lib/gcc/x86_64-pc-linux-gnu/9.4.0/include;/usr/local/include;/opt/GCC/GCC-9.4.0/include;/opt/GCC/GCC-9.4.0/lib/gcc/x86_64-pc-linux-gnu/9.4.0/include-fixed;/usr/include/x86_64-linux-gnu;/usr/include")
set(CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES "gfortran;m;gcc_s;gcc;quadmath;m;gcc_s;gcc;c;gcc_s;gcc")
set(CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES "/home/kxzhu/Downloads/ssl/lib;/opt/GCC/GCC-9.4.0/lib64;/opt/GCC/GCC-9.4.0/lib/gcc/x86_64-pc-linux-gnu/9.4.0;/lib/x86_64-linux-gnu;/lib64;/usr/lib/x86_64-linux-gnu;/opt/GCC/GCC-9.4.0/lib")
set(CMAKE_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
