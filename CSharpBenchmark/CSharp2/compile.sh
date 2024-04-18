#!/bin/bash

# Compila os arquivos .cs com o compilador Mono (mcs)
mcs mpbenchmark.cs Worker.cs Utilities.cs configuration_data.cs rtPerformancedata.cs
