
# #--------------------------------------#
# echo "C"
# sleep 2
# #--------------------------------------#

# cd CBenchMark/C1Thread/
# sh compile.sh

# cd ..
# cd C2Thread/
# sh compile.sh

# cd ..
# cd C4Thread/
# sh compile.sh

# cd ..
# cd C8Thread/
# sh compile.sh

# cd ..
# cd ..

#--------------------------------------#
echo "CBUnroll"
sleep 2
#--------------------------------------#

cd CBenchMark_Unroll/C1Thread/
sh compile.sh

cd ..
cd C2Thread/
sh compile.sh

cd ..
cd C4Thread/
sh compile.sh

cd ..
cd C8Thread/
sh compile.sh

cd ..
cd ..


# #--------------------------------------#
# echo "CFloat"
# sleep 2
# #--------------------------------------#

# cd CBenchMark_Float/C1Thread/
# sh compile.sh

# cd ..
# cd C2Thread/
# sh compile.sh

# cd ..
# cd C4Thread/
# sh compile.sh

# cd ..
# cd C8Thread/
# sh compile.sh

# cd ..
# cd ..

#--------------------------------------#
echo "C_SIMD_DP"
sleep 2
#--------------------------------------#

cd CBenchMark_SIMD_DP/C1Thread/
sh compile.sh

cd ..
cd C2Thread/
sh compile.sh

cd ..
cd C4Thread/
sh compile.sh

cd ..
cd C8Thread/
sh compile.sh

cd ..
cd ..

#--------------------------------------#
echo "C_SIMD_SP"
sleep 2
#--------------------------------------#

cd CBenchMark_SIMD_SP/C1Thread/
sh compile.sh

cd ..
cd C2Thread/
sh compile.sh

cd ..
cd C4Thread/
sh compile.sh

cd ..
cd C8Thread/
sh compile.sh

cd ..
cd ..
#--------------------------------------#
echo "Java"
sleep 2
#--------------------------------------#

cd JavaBenchMark/JB1Thread
sh compile.sh

cd ..
cd JB2Thread
sh compile.sh

cd ..
cd JB4Thread
sh compile.sh

cd ..
cd JB8Thread
sh compile.sh

cd ..
cd ..

#--------------------------------------#
echo "Java Fork"
sleep 2
#--------------------------------------#
cd JavaForkJoinBenchMark/JF1Thread
sh compile.sh

cd ..
cd JF2Thread
sh compile.sh

cd ..
cd JF4Thread
sh compile.sh

cd ..
cd JF8Thread
sh compile.sh

cd ..
cd ..
