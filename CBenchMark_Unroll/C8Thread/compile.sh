rm -f mpbenchmark
gcc -O2 -funroll-loops -mcpu=cortex-a53 -fopenmp -o mpbenchmark mpbenchmark.c
