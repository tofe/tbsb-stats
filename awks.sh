INPUTFILE=$1
OUTPUTFILE=$2
awk '{ for (i = 1; i <= NF; i++) f[i] = f[i] " " $i ;
       if (NF > n) n = NF }
 END { for (i = 1; i <= n; i++) sub(/^  */, "", f[i]) ;
       for (i = 1; i <= n; i++) print f[i] }
    ' $INPUTFILE >> $OUTPUTFILE
    #' GetMemoryUsage.csv > GetMemoryUsage.csv.sorted

