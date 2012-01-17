INPUTLOG=$1
HOSTNAME=$2
PAPORT=$3
OUTPUTDIR=$4
#DATEOFTEST=15122011
#TEST=GetSCV

#Source Log File Directory
#SOURCEDIR=`pwd $INPUTLOG`
#echo $SOURCEDIR

if [ -z "$1" ]
then
  echo "No input file"; echo "usage <script.sh> file_name host_name pa_port OUTPUT_DIR"
  exit
fi

if [ -z "$2" ]
then
  echo "No Host Name"; echo "usage <script.sh> file_name host_name pa_port OUTPUT_DIR"
  exit
fi

if [ -z "$3" ]
then
  echo "No Policy Agent Port"; echo "usage <script.sh> file_name host_name pa_port OUTPUT_DIR"
  exit
fi

if [ -z "$4" ]
then
  echo "No Output Directory"; echo "usage <script.sh> file_name host_name pa_port OUTPUT_DIR"
  exit
fi


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

#Collect "ThreadCount, PeakThreadCount, DaemonThreadCount" >> GetThreading.csv
#cat TimeStamps.csv >> GetThreading.csv.tmp
grep ^ThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep PeakThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp
grep DaemonThreadCount Threading.txt | awk '{print $3}' | sed 's/\;/\,/g' | sed -n -e ":a" -e "$ s/\n/ /gp;N;b a" >> Get.csv.tmp

##Turn rows in to CSV columns
echo "Time, CommittedHeap, InitialHeap, MaxHeap, UsedHeap, threadCount, peakThreadCount, DeamonThreadCount" >> $HOSTNAME$PAPORT"_Totals.csv"
./awks.sh Get.csv.tmp $HOSTNAME$PAPORT"_Totals.csv"

mkdir -p $OUTPUTDIR/output

rm -f *.tmp
rm -f *.txt
rm -f TimeStamps.csv

mv  $HOSTNAME$PAPORT"_Totals.csv" $OUTPUTDIR/output/

