rm -f mpbenchmark
gcc -O2 -funroll-loops -march=native -fopenmp -o mpbenchmark mpbenchmark.c
