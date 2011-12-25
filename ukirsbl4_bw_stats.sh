#!/bin/bash
#
# A Script to collect MBean stats from Java / BW Enging / Tomcat
#
#
# Uses jmxterm:
# http://wiki.cyclopsgroup.org/jmxterm

JMXTERM_JAR=/tbsb/monitoring/jmxterm-1.0-alpha-4-uber.jar
INPUTFILE_8590=/tbsb/monitoring/pa_mbean_cmds_ppe_8590.txt
INPUTFILE_8381=/tbsb/monitoring/pa_mbean_cmds_ppe_8381.txt
DATETIME=$(date +%H%M%S_%d%m%Y)
OUTPUTFILE_8590=/tbsb/monitoring/ukirsbm1_pa_jmx_stats__${DATETIME}_8590.log
OUTPUTFILE_8381=/tbsb/monitoring/ukirsbm1_pa_jmx_stats__${DATETIME}_8381.log
#OUTPUTFILE_8590=/tbsb/monitoring/ukirsbm1_pa_jmx_stats_8590.log
#OUTPUTFILE_8381=/tbsb/monitoring/ukirsbm1_pa_jmx_stats_8381.log
JMXURL_8590=ukirsbm1a.ukpre.tescobank.org:33001
JMXURL_8381=ukirsbm1a.ukpre.tescobank.org:33002

echo "JMX MBean Stats Gather, "  $(date +%d-%m-%Y)  > ${OUTPUTFILE_8590}
echo "JMX MBean Stats Gather, "  $(date +%d-%m-%Y)  > ${OUTPUTFILE_8381}

while true
do
        echo `date +%H:%M:%S` " Policy Agent 8590 " >> ${OUTPUTFILE_8590}
        java -jar ${JMXTERM_JAR} -i ${INPUTFILE_8590} --url ${JMXURL_8590} -v brief >> ${OUTPUTFILE_8590} 2>&1
        sleep 3
        echo `date +%H:%M:%S` " Policy Agent 8381 " >> ${OUTPUTFILE_8381}
        java -jar ${JMXTERM_JAR} -i ${INPUTFILE_8381} --url ${JMXURL_8381} -v brief >> ${OUTPUTFILE_8381} 2>&1
        sleep 10
done


[tbsbrun@ukirsbm5 monitoring]$ cat ukirsbl4_bw_stats.sh
#!/bin/bash
#
# A Script to collect MBean stats from Java / BW Enging / Tomcat
#
#
# Uses jmxterm:
# http://wiki.cyclopsgroup.org/jmxterm

JMXTERM_JAR=/tbsb/monitoring/jmxterm-1.0-alpha-4-uber.jar
INPUTFILE=/tbsb/monitoring/ukirsbl4_bw_mbean_cmds_ppe.txt
DATETIME=$(date +%H%M%S_%d%m%Y)
#OUTPUTFILE=/tbsb/monitoring/bw_stats.log
OUTPUTFILE=/tbsb/monitoring/ukirsbl4_bw_jmx_stats__${DATETIME}.log
JMXURL=ukirsbl4a.ukpre.tescobank.org:33000

echo "JMX MBean Stats Gather, " + $(date +%d-%m-%Y)  > ${OUTPUTFILE}

while true
do
        date +%H:%M:%S >> ${OUTPUTFILE}
        java -jar ${JMXTERM_JAR} -i ${INPUTFILE} --url ${JMXURL} -v brief >> ${OUTPUTFILE} 2>&1
        sleep 10
done

