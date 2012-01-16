INPUTLOG=$1
HOSTNAME=$2
OUTPUTDIR=$3
#DATEOFTEST=15122011
#TEST=GetSCV

if [ -z "$1" ]
then
  echo "No input file"; echo "usage <script.sh> file_name host_name OUTPUT_DIR"
  exit
fi

if [ -z "$2" ]
then
  echo "No Host Name"; echo "usage <script.sh> file_name host_name OUTPUT_DIR"
  exit
fi

if [ -z "$3" ]
then
  echo "No Output Directory"; echo "usage <script.sh> file_name host_name OUTPUT_DIR"
  exit
fi

#Get Time Stamps
#for i in `egrep '[0-9][0-9]:[0-9][0-9]' $INPUTLOG`; do echo $i"," ; done >> timestamps.text
for i in `egrep '[0-9][0-9]:[0-9][0-9]' $INPUTLOG  | awk {'print $1'}`; do echo $i"," ; done >> timestamps.text
 
# Take relevent fields
grep -A 4 ^HeapMemoryUsage $INPUTLOG | egrep '(committed|init|max|used)' >> HeapMemory.text
grep -A 6 Threading $INPUTLOG  | grep -v \# | grep -v \- | grep -v "^$"  >> Threading.text
grep -A 1 OperatingSystem $INPUTLOG  | grep -v \-  | grep Free >> OperatingSystem.text
grep Threads $INPUTLOG  | grep -v max | grep -v current | grep -v min >> threads.text
grep -A 7 GetMemoryUsage $INPUTLOG | egrep '(FreeBytes|PercentUsed|TotalBytes|UsedBytes)' >> GetMemoryUsage.text
grep -A 3 Connector $INPUTLOG  | egrep '(acceptCount|maxThreads)' >> TomCatConnector.text
grep -A 6 ThreadPool $INPUTLOG  | grep -v \# | grep -v \- | grep -v "^$"  >> ThreadPool.text
 
# Parse Timestamps to CSV
cat timestamps.text | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> TimeStamps.csv
 
#Collect  "Time, CommittedBytes, InitialBytes, MaxBytes, Used" from HeapMemoryUsage MBEAN >> GetHeapMemoryUsage.csv
cat TimeStamps.csv >> BW.csv.tmp
grep committed HeapMemory.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep init HeapMemory.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep max HeapMemory.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep used HeapMemory.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
 
#Collect  "Time, Total Bytes, Free Bytes, UsedBytes, PercentUsed" from BW Engine MBEAN >> GetMemoryUsage.csv
#cat TimeStamps.csv >> GetMemoryUsage.csv.tmp
grep TotalBytes GetMemoryUsage.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep FreeBytes GetMemoryUsage.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep UsedBytes GetMemoryUsage.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep PercentUsed GetMemoryUsage.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
 
#Collect "FreePhysicalMemorySize" >> GetOperatingSystem.csv
#cat TimeStamps.csv >> GetOperatingSystem.csv.tmp
grep FreePhysicalMemorySize OperatingSystem.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
 
#Collect "PeakThreadCount, DaemonThreadCount" from java.lang.Threading MBEAN>> GetThreading.csv
#cat TimeStamps.csv >> GetThreading.csv.tmp
grep PeakThreadCount Threading.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep DaemonThreadCount Threading.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
 
 
#Collect "maxThreads, currentThreadCount, currentThreadsBusy " from TomCatEngine.ThreadPool MBEAN >> GetThreadPool.csv.tmp
#cat TimeStamps.csv >> GetThreadPool.csv.tmp
grep maxThreads ThreadPool.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep currentThreadCount ThreadPool.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
grep currentThreadsBusy ThreadPool.text | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> BW.csv.tmp
 
 
#Turn rows in to CSV columns
echo "Time, CommittedBytes_Heap, InitialBytes_Heap, MaxBytes_Heap, UsedBytes_Heap, TotalBytes_BWEngine, FreeBytes_BWEngine, UsedBytes_BWEngine, Percent_Memory_Used_BWEngine, Free_OS_Memory, PeakThreadCount_Java.lang.Threading, DaemonThreadCount_Java.lang.Threading, MaxThreads_TomCatEngine.ThreadPool, CurrentThreadCount_TomcatEngine.ThreadPool, CurrentThreadsBusy_TomCatEngine.ThreadPool " >> $HOSTNAME"_Totals.csv"
./awks.sh BW.csv.tmp $HOSTNAME"_Totals.csv"
 
#echo "Time, Total Bytes, Free Bytes, UsedBytes, PercentUsed" >>  $HOSTNAME"_MemoryUsage.csv"
#./awks.sh GetMemoryUsage.csv.tmp $HOSTNAME"_MemoryUsage.csv"
 
#echo "Time,FreePhysicalMemorySize" >> $HOSTNAME"_OperatingSystem.csv"
#./awks.sh GetOperatingSystem.csv.tmp $HOSTNAME"_OperatingSystem.csv"
 
#echo "Time, PeakThreadCount, DaemonThreadCount" >> $HOSTNAME"_Threading.csv"
#./awks.sh  GetThreading.csv.tmp $HOSTNAME"_Threading.csv"
 
#echo "Time, maxThreads, CurrentThreadCount, CurrentThreadsBusy" >> $HOSTNAME"_ThreadPool.csv"
#./awks.sh  GetThreadPool.csv.tmp $HOSTNAME"_ThreadPool.csv"
 
mkdir -p $OUTPUTDIR/output

#clean up
rm -f *.tmp
rm -f *.text
rm -f TimeStamps.csv

mv  $HOSTNAME"_Totals.csv" $OUTPUTDIR/output/
