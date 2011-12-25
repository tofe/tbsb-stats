INPUTLOG=ukirsbl4_bw_jmx_stats__170813_15122011.log
BWHOSTNAME=ukirsbl4
DATEOFTEST=15122011
TEST=GetSCV


#Get Time Stamps
for i in `egrep '[0-9][0-9]:[0-9][0-9]' $INPUTLOG`; do echo $i"," ; done >> timestamps.txt


# Take relevent fields
grep -A 4 ^HeapMemoryUsage $INPUTLOG | egrep '(committed|init|max|used)' >> HeapMemory.txt
grep -A 6 Threading $INPUTLOG  | grep -v \# | grep -v \- | grep -v "^$"  >> Threading.txt
grep -A 1 OperatingSystem $INPUTLOG  | grep -v \-  | grep Free >> OperatingSystem.txt
grep Threads $INPUTLOG  | grep -v max | grep -v current | grep -v min >> threads.txt
grep -A 7 GetMemoryUsage $INPUTLOG | egrep '(FreeBytes|PercentUsed|TotalBytes|UsedBytes)' >> GetMemoryUsage.txt
grep -A 3 Connector $INPUTLOG  | egrep '(acceptCount|maxThreads)' >> TomCatConnector.txt

# Parse Timestamps to CSV
cat timestamps.txt | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> TimeStamps.csv

#Collect  "Time, CommittedBytes, InitialBytes, MaxBytes, Used" >> GetHeapMemoryUsage.csv
cat TimeStamps.csv >> GetHeapMemoryUsage.csv.tmp
grep committed HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetHeapMemoryUsage.csv.tmp
grep init HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetHeapMemoryUsage.csv.tmp
grep max HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetHeapMemoryUsage.csv.tmp
grep used HeapMemory.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetHeapMemoryUsage.csv.tmp

#Collect  "Time, Total Bytes, Free Bytes, UsedBytes, PercentUsed" >> GetMemoryUsage.csv
cat TimeStamps.csv >> GetMemoryUsage.csv.tmp
grep TotalBytes GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp
grep FreeBytes GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp
grep UsedBytes GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp
grep PercentUsed GetMemoryUsage.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetMemoryUsage.csv.tmp

#Collect "FreePhysicalMemorySize" >> GetOperatingSystem.csv
cat TimeStamps.csv >> GetOperatingSystem.csv.tmp
grep FreePhysicalMemorySize OperatingSystem.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetOperatingSystem.csv.tmp

#Collect "PeakThreadCount, DaemonThreadCount" >> GetThreading.csv
cat TimeStamps.csv >> GetThreading.csv.tmp
grep PeakThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetThreading.csv.tmp
grep DaemonThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> GetThreading.csv.tmp

#Turn rows in to CSV columns
echo "Time, CommittedBytes, InitialBytes, MaxBytes, Used" >> $BWHOSTNAME"_HeapMemoryUsage.csv"
./awks.sh GetHeapMemoryUsage.csv.tmp $BWHOSTNAME"_HeapMemoryUsage.csv"

echo "Time, Total Bytes, Free Bytes, UsedBytes, PercentUsed" >>  $BWHOSTNAME"_MemoryUsage.csv"
./awks.sh GetMemoryUsage.csv.tmp $BWHOSTNAME"_MemoryUsage.csv"

echo "Time,FreePhysicalMemorySize" >> $BWHOSTNAME"_OperatingSystem.csv"
./awks.sh GetOperatingSystem.csv.tmp $BWHOSTNAME"_OperatingSystem.csv"

echo "Time, PeakThreadCount, DaemonThreadCount" >> $BWHOSTNAME"_Threading.csv"
./awks.sh  GetThreading.csv.tmp $BWHOSTNAME"_Threading.csv"


#clean up
rm -f *.tmp
rm -f *.txt
rm -f TimeStamps.csv

