INPUTLOG=ukirsbm1_pa_jmx_stats__170807_15122011_8590.log
BWHOSTNAME=ukirsbm1
PAPORT=8590
DATEOFTEST=15122011
TEST=GetSCV

#Get Time Stamps
#for i in `egrep '[0-9][0-9]:[0-9][0-9]' $INPUTLOG`; do echo $i"," ; done >> timestamps.txt
for i in `egrep '[0-9][0-9]:[0-9][0-9]' $INPUTLOG  | awk {'print $1'}`; do echo $i"," ; done >> timestamps.txt

# Take relevent fields
grep -A 4 ^HeapMemoryUsage $INPUTLOG | egrep '(committed|init|max|used)' >> HeapMemory.txt
grep -A 6 ThreadPool $INPUTLOG  | grep -v \# | grep -v \- | grep -v "^$"  >> ThreadPool.txt
grep -A 6 Threading $INPUTLOG  | grep -v \# | grep -v \- | grep -v "^$"  >> Threading.txt
grep -A 6 Connector $INPUTLOG  | grep -v \# | grep -v \- | grep -v "^$"  >> Connector.txt
#grep -A 1 OperatingSystem $INPUTLOG  | grep -v \-  | grep Free >> OperatingSystem.txt
#grep Threads $INPUTLOG  | grep -v max | grep -v current | grep -v min >> threads.txt
#grep -A 7 GetMemoryUsage $INPUTLOG | egrep '(FreeBytes|PercentUsed|TotalBytes|UsedBytes)' >> GetMemoryUsage.txt
#grep -A 3 Connector $INPUTLOG  | egrep '(acceptCount|maxThreads)' >> TomCatConnector.txt

## Parse Timestamps to CSV
cat timestamps.txt | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> TimeStamps.csv

##Collect  "Time, CommittedBytes, InitialBytes, MaxBytes, Used" >> GetHeapMemoryUsage.csv
cat TimeStamps.csv >> Get.csv.tmp
grep committed HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep init HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep max HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep used HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp

##Collect  "Time, Total Bytes, Free Bytes, UsedBytes, PercentUsed" >> GetMemoryUsage.csv
#cat TimeStamps.csv >> GetMemoryUsage.csv.tmp
#grep TotalBytes GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp
#grep FreeBytes GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp
#grep UsedBytes GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp
#grep PercentUsed GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp

##Collect "FreePhysicalMemorySize" >> GetOperatingSystem.csv
#cat TimeStamps.csv >> GetOperatingSystem.csv.tmp
#grep FreePhysicalMemorySize OperatingSystem.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetOperatingSystem.csv.tmp

#Collect "ThreadCount, PeakThreadCount, DaemonThreadCount" >> GetThreading.csv
#cat TimeStamps.csv >> GetThreading.csv.tmp
grep ^ThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep PeakThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep DaemonThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp

#Collect "CurrentThreadCount, CurrentThreadsBusy, maxThreads" >> GetThreadPool.csv.tmp
#cat TimeStamps.csv >> GetThreadPool.csv.tmp
grep currentThreadCount ThreadPool.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep currentThreadsBusy ThreadPool.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep maxThreads ThreadPool.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp

#Collect "acceptCount, maxThreads, minSpareThreads" >> GetConnector.csv.tmp
#cat TimeStamps.csv >> GetConnector.csv.tmp
grep acceptCount Connector.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep maxThreads Connector.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep minSpareThreads Connector.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp


##Turn rows in to CSV columns
echo "Time, CommittedHeap, InitialHeap, MaxHeap, UsedHeap, threadCount, peakThreadCount, DeamonThreadCount, CurrentThreadCount, CurrentThreadsBusy, MaxThreads, ConnectorAcceptCount, ConnectorMaxThreads, ConnectorMinSpareThreads" >> $BWHOSTNAME$PAPORT"_Totals.csv"
./awks.sh Get.csv.tmp $BWHOSTNAME$PAPORT"_Totals.csv"

#echo "Time, ThreadCount, PeakThreadCount, DaemonThreadCount" >> $BWHOSTNAME$PAPORT"_Threading.csv"
#./awks.sh  GetThreading.csv.tmp $BWHOSTNAME$PAPORT"_Threading.csv"

#echo "Time, CurrentThreadCount, currentThreadsBusy, maxThreads" >> $BWHOSTNAME$PAPORT"_ThreadPool.csv"
#./awks.sh  GetThreadPool.csv.tmp $BWHOSTNAME$PAPORT"_ThreadPool.csv"

#echo "Time, acceptCount, maxThreads, minSpareThreads" >> $BWHOSTNAME$PAPORT"_Connector.csv"
#./awks.sh  GetThreadPool.csv.tmp $BWHOSTNAME$PAPORT"_Connector.csv"

#echo "Time, Total Bytes, Free Bytes, UsedBytes, PercentUsed" >>  $BWHOSTNAME"_MemoryUsage.csv"
#./awks.sh GetMemoryUsage.csv.tmp $BWHOSTNAME"_MemoryUsage.csv"

#echo "Time,FreePhysicalMemorySize" >> $BWHOSTNAME"_OperatingSystem.csv"
#./awks.sh GetOperatingSystem.csv.tmp $BWHOSTNAME"_OperatingSystem.csv"
#clean up

rm -f *.tmp
rm -f *.txt
#rm -f *.csv

