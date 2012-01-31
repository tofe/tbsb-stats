#!/bin/bash
#
#####################################################################################
# A script invkoed by local Hawk Agents to send Alerts to local log file to be
# monitored by NSM Agents
#####################################################################################

HawkLogFile=/tbsb/logs/hawkagent_TBSB.log
Date=`date +%F\ %T`

if [ -z "$1" ]
then
 echo "No method called. Usage <hawktolog.sh> RuletoLog"
 exit 1
fi

if [ "$1" == "BWGetExecInfo_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetExecInfo has reported the TBSB Process
    # Engine's status is not 'ACTIVE'
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: process engine is not active" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "BWGetExecInfo_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetExecInfo has reported the TBSB Process
    # Engine's status is now 'ACTIVE'
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: process engine is active" >> $HawkLogFile
    exit 0
fi


if [ "$1" == "BWGetHostInformtion_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetHostInformation has reported the TBSB
    # deployed Application TBSB is not 'RUNNING'.
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: TBSB-Archive application instance is not running" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "BWGetHostInformtion_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetHostInformation has reported the TBSB
    # deployed Application TBSB is 'RUNNING'.
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: TBSB-Archive application instance is running" >> $HawkLogFile
    exit 0
fi


if [ "$1" == "BWGetMemoryUsage_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetMemoryUsage has reported the TBSB
    # Process Engine is utilizing 85% or greater of its allocated memory.
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: BW Engine memory usage is over 85%" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "BWGetMemoryUsage_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetMemoryUsage has reported the TBSB
    # Process Engine is utilizing less that 85% of its allocated memory.
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: BW Engine memory usage is below 85%" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "BWGetStatus_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetStatus has reported one or more errors
    # on the TBSB Process Engine.
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: BW Engine is reporting 1 or more Errors" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "BWGetStatus_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Business Works microagent method GetStatus has reported no errors
    # on the TBSB Process Engine.
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: BW Engine is reporting 0 errors" >> $HawkLogFile
    ext 0
fi


if [ "$1" == "EMSIsRunning_alert" ]; then
    #--------------------------------------------------------------------------------
    # The EMS microagent method isRunning() has returned false
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: EMS Server is not in running state" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "EMSIsRunning_clear" ]; then
    #--------------------------------------------------------------------------------
    # The EMS microagent method isRunning() has returned true
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: EMS Server is running " >> $HawkLogFile
    exit 0
fi


if [ "$1" == "EMSPendingMessageCount_alert" ]; then
    #--------------------------------------------------------------------------------
    # The EMS microagent has returned a count of more than 100 pending messages
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: EMS Server has more than 100 pending messages" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "EMSPendingMessageCount_clear" ]; then
    #--------------------------------------------------------------------------------
    # The EMS microagent has returned a count of more than 100 pending messages
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: EMS Server has less than 100 pending messages" >> $HawkLogFile
    exit 0
fi



