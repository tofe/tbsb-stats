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
    exit 0
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
    if [ -z "$2" ]
        then
        echo "No Number of pending messages supplied. Usage <hawktolog.sh> EMSPendingMessageCountt_alert messages transportname"
        exit 1
    fi
    if [ -z "$3" ]
        then
        echo "No topic or queue name supplied. Usage <hawktolog.sh> EMSPendingMessageCountt_alert messages transportname"
        exit 1
    fi
    echo $Date " Hawk: EMS Server has more than 100 pending messages of" $2 " " $3  >> $HawkLogFile
    exit 0
fi

if [ "$1" == "EMSPendingMessageCount_clear" ]; then
    #--------------------------------------------------------------------------------
    # The EMS microagent has returned a count of more than 100 pending messages
    #-------------------------------------------------------------------------------
    if [ -z "$2" ]
        then
        echo "No topic or queue name supplied. Usage <hawktolog.sh> EMSPendingMessageCountt_alert transportname"
        exit 1
    fi
    echo $Date " Hawk: EMS Server has less than 100 pending messages on" $2 >> $HawkLogFile
    exit 0
fi

if [ "$1" == "BWGetProcessStarters_alert" ]; then
    #--------------------------------------------------------------------------------
    # The BW TBSB microagent has returned a TBSB Proces Starter (Service) is not Active
    #-------------------------------------------------------------------------------
    if [ -z "$2" ]
        then
        echo "No Process Starter set defined to alert on. Usage <hawktolog.sh> GetProcessStarterst_alert ProcessStarter"
        exit 1
    fi
    echo $Date "  Hawk: A Process within the TBSB-Archive application instance is not active. Process:" $2  >> $HawkLogFile
    exit 0
fi

if [ "$1" == "BWGetProcessStarters_clear" ]; then
    #--------------------------------------------------------------------------------
    # The BW TBSB microagent has returned the TBSB Proces Starter is Active
    #-------------------------------------------------------------------------------

    if [ -z "$2" ]
        then
        echo "No Process Starter set defined to alert on. Usage <hawktolog.sh> GetProcessStarterst_clear ProcessStarter"
        exit 1
    fi
    echo $Date "  Hawk: The Process within the TBSB-Archive application is now active. Process:" $2  >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessBWEngine_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned 0 Running BW Engines
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: BW Process Engine Process bwengine is not running" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessBWEngine_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned Running BW Engines
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: 1 or more BW Process Engine Processes are running" >> $HawkLogFile
    exit 0
fi


if [ "$1" == "ProcessSecEngine_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned 0 Running Security Engines
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: Security Engine Process is not running" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessSecEngine_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned Running Security Engines
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: Security Engine Process is running" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessEMSHealthCheck_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned incorrect number
    # of  Running EMS HealthCheckers
    #-------------------------------------------------------------------------------
    if [ -z "$2" ]
        then
        echo "No number of running EMS health checkers supplied. Usage <hawktolog.sh> ProcessEMSHealthCheck_alert runninghealthcheckers"
        exit 1
    fi
    echo $Date " Hawk: A required instance of EMS Health Checker process is not running. Currently Running:" $2 >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessEMSHealthCheck_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned the correct number
    # of  Running EMS HealthCheckers
    #-------------------------------------------------------------------------------
    if [ -z "$2" ]
        then
        echo "No number of running EMS health checkers supplied. Usage <hawktolog.sh> ProcessEMSHealthCheck_clear runninghealthcheckers"
        exit 1
    fi
    echo $Date " Hawk: The required number of EMS Health Checker processes are running. Currently Running:" $2 >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessEMSDaemon_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned the ems deamon process is not running
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: The TIBCO EMS Daemon process is not running" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessEMSDaemon_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned the ems deamon process is running
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: The TIBCO EMS Daemon process is running" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "SystemCPU_alert" ]; then
    #--------------------------------------------------------------------------------
    # The System microagent method getCpuInfo() has returned less than 15% idle time
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: CPU utilization at >= 85%" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "SystemCPU_clear" ]; then
    #--------------------------------------------------------------------------------
    # The System microagent method getCpuInfo() has returned greater than 15% idle time
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: CPU utilization at < 85%" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "FileSystem_alert" ]; then
    #--------------------------------------------------------------------------------
    # The FileSystem microagent method getByMountPoint() has returned less than 15% Free Space
    #-------------------------------------------------------------------------------
    if [ -z "$2" ]
        then
        echo "No mount point name supplied. Usage <hawktolog.sh> FileSystem_alert mountpoint percentfree"
        exit 1
    fi
    if [ -z "$3" ]
        then
        echo "No % Free value supplied. Usage <hawktolog.sh> FileSystem_alert mountpoint percentfree"
        exit 1
    fi
    echo $Date " Hawk: %Free space on mount point " $2 $3 >> $HawkLogFile
    exit 0
fi

if [ "$1" == "FileSystem_clear" ]; then
    #--------------------------------------------------------------------------------
    # The FileSystem microagent method getByMountPoint() has returned more than 15% Free Space
    #-------------------------------------------------------------------------------
    if [ -z "$2" ]
        then
        echo "No mount point name supplied. Usage <hawktolog.sh> FileSystem_clear mountpoint percentfree"
        exit 1
    fi
    if [ -z "$3" ]
        then
        echo "No % Free value supplied. Usage <hawktolog.sh> FileSystem_clear mountpoint percentfree"
        exit 1
    fi
    echo $Date " Hawk: %Free space on mount point " $2 $3 >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessPolicyAgent_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned incorrect number
    # of  Running Policy Agents
    #-------------------------------------------------------------------------------
    if [ -z "$2" ]
        then
        echo "No number of currently running Policy Agents supplied. Usage <hawktolog.sh> ProcessPolicyAgent_alert runningprocesses"
        exit 1
    fi
    echo $Date " Hawk: A required instance of Policy Agent processes is not running. Currently Running:" $2 >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessPolicyAgent_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned incorrect number
    # of  Running Policy Agents
    #-------------------------------------------------------------------------------
   if [ -z "$2" ]
        then
        echo "No number of currently running Policy Agents supplied. Usage <hawktolog.sh> ProcessPolicyAgent_clear runningprocesses"
        exit 1
    fi
    echo $Date " Hawk: The required number of Policy Agent processes are running. Currently Running:" $2 >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessAdministrator_alert" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned TIBCO Administrator
    # is not running
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: The TIBCO Administrator process is not running" >> $HawkLogFile
    exit 0
fi

if [ "$1" == "ProcessAdministrator_clear" ]; then
    #--------------------------------------------------------------------------------
    # The Service microagent method GetInstanceCount() has returned TIBCO Administrator
    # is running
    #-------------------------------------------------------------------------------
    echo $Date " Hawk: The TIBCO Administrator process is running" >> $HawkLogFile
    exit 0
fi

echo "You have not entered a valid alert method"

