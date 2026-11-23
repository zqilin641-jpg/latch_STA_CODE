# CMake generated Testfile for 
# Source directory: /mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests
# Build directory: /mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/build_howard_tests
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(howard_validation "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/build_howard_tests/howard_validation_tests" "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/fixtures/self.out")
set_tests_properties(howard_validation PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;15;add_test;/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;0;")
add_test(howard_graphs "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/build_howard_tests/howard_graph_tests")
set_tests_properties(howard_graphs PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;21;add_test;/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;0;")
add_test(howard_s27_baseline "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/build_howard_tests/howard_benchmark_validation" "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/../benchmark/s27.blif.out" "baseline")
set_tests_properties(howard_s27_baseline PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;30;add_test;/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;0;")
add_test(howard_s27_duty "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/build_howard_tests/howard_benchmark_validation" "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/../benchmark/s27.blif.out" "duty")
set_tests_properties(howard_s27_duty PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;30;add_test;/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;0;")
add_test(howard_s27_nonzero "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/build_howard_tests/howard_benchmark_validation" "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/../benchmark/s27.blif.out" "nonzero")
set_tests_properties(howard_s27_nonzero PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;30;add_test;/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;0;")
add_test(howard_s27_override "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/build_howard_tests/howard_benchmark_validation" "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/../benchmark/s27.blif.out" "override")
set_tests_properties(howard_s27_override PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;30;add_test;/mnt/e/大四上/曦源项目/现LatchSTA_Code/LatchSTA_Code/latch-STA/tests/CMakeLists.txt;0;")
