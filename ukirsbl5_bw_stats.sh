#!/bin/bash
#
# A Script to collect MBean stats from Java / BW Enging / Tomcat
#
#
# Uses jmxterm:
# http://wiki.cyclopsgroup.org/jmxterm

JMXTERM_JAR=/tbsb/monitoring/jmxterm-1.0-alpha-4-uber.jar
INPUTFILE=/tbsb/monitoring/ukirsbl5_bw_mbean_cmds_ppe.txt
DATETIME=$(date +%H%M%S_%d%m%Y)
#OUTPUTFILE=/tbsb/monitoring/bw_stats.log
OUTPUTFILE=/tbsb/monitoring/ukirsbl5_bw_jmx_stats__${DATETIME}.log
JMXURL=ukirsbl5a.ukpre.tescobank.org:33000

echo "JMX MBean Stats Gather, " + $(date +%d-%m-%Y)  > ${OUTPUTFILE}

while true
do
        date +%H:%M:%S >> ${OUTPUTFILE}
        java -jar ${JMXTERM_JAR} -i ${INPUTFILE} --url ${JMXURL} -v brief >> ${OUTPUTFILE} 2>&1
        sleep 10
done

