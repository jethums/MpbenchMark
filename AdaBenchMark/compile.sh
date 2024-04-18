rm -f *.o
rm -f *.ali
gnatmake -O2 -funroll-loops -mcpu=cortex-a53 mpbenchmark.adb
rm -f *.o
rm -f *.ali