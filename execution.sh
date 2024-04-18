#--------------------------------------#
echo "ADA"
sleep 2
#--------------------------------------#
cd AdaBenchMark/Ada1/

count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0 ./mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value
#sleep 5
cd ..
cd Ada2/

count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,2 ./mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value
#sleep 5
cd ..
cd Ada4/
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,1,2,3 ./mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

cd ..
cd ..
#--------------------------------------#
echo "CBUnroll"
sleep 2
#--------------------------------------#
cd CBenchMark_Unroll/C1Thread/

count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0 ./mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value
#sleep 5

#-----------------------------------------------------
cd ..
cd C2Thread/

count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,2 ./mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#sleep 5

#------------------------------------------------------
cd ..
cd C4Thread/
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,1,2,3 ./mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#------------------------------------------------------
cd ..
cd ..

#--------------------------------------#
echo "Java"
sleep 2
#--------------------------------------#

cd JavaBenchMark/JB1Thread

count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0 java mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#sleep 5

#-----------------------------------------------

cd ..
cd JB2Thread

count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,2 java mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value
#sleep 5

#------------------------------------------------
cd ..
cd JB4Thread

count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,1,2,3 java mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#sleep 5


#------------------------------------------------
cd ..
cd ..

#--------------------------------------#
echo "Java Fork"
sleep 2
#--------------------------------------#
cd JavaForkJoinBenchMark/JF1Thread
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0 java mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#sleep 5

#-------------------------------------------------
cd ..
cd JF2Thread
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,2 java mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#sleep 5

#-------------------------------------------------
cd ..
cd JF4Thread
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,1,2,3 java mpbenchmark
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value


#------------------------------------------------
cd ..
cd ..

#--------------------------------------#
echo "CSharp"
sleep 2
#--------------------------------------#
cd CSharpBenchmark/CSharp1
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0 mono mpbenchmark.exe
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#sleep 5
cd ..
cd CSharp2
#-------------------------------------
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,2 mono mpbenchmark.exe
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value

#sleep 5
cd ..
cd CSharp4
#---------------------------------------
count=1
#echo 0 > /sys/class/gpio/gpio538/value
while [ $count -le 13 ]; do
    taskset -c 0,1,2,3 mono mpbenchmark.exe
    count=$((count + 1))
done
#echo 1 > /sys/class/gpio/gpio538/value
cd ..
cd ..

