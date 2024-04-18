#--------------------------------------#
echo "ADA"
sleep 2
#--------------------------------------#

cd AdaBenchMark/Ada1/
sh compile.sh

cd ..
cd Ada2/
sh compile.sh

cd ..
cd Ada4/
sh compile.sh

cd ..
cd ..

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
cd ..

#--------------------------------------#
echo "CSharp"
sleep 2
#--------------------------------------#
cd CSharpBenchmark/CSharp1
sh compile.sh

cd ..
cd CSharp2
sh compile.sh

cd ..
cd CSharp4
sh compile.sh

