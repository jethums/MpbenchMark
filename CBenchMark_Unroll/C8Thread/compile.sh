rm -f mpbenchmark
gcc -O2 -funroll-loops -fopenmp -o mpbenchmark mpbenchmark.c
