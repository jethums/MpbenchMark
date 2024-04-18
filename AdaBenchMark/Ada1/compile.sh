rm -f *.o
rm -f *.ali
gnatmake -O2 -funroll-loops -march=native mpbenchmark.adb
rm -f *.o
rm -f *.ali