cription: Starts, stops and gets status of the ems health check monitor

PROC="EmsHealthCheck"
PROC_HOME="$HOME/ems-healthcheck"

start() {
        echo -n $"Starting $PROC services: "
        cd $PROC_HOME
        ./run.sh
        cd -
}

stop() {
        echo -n $"Shutting down $PROC services: "
        cd $PROC_HOME
        /tbsb/ems-healthcheck/shutdown.sh
        cd -
}

restart() {
        stop
        sleep 5
        start
}

status() {
        STATUS=`ps -ef | grep 8090 | grep v | wc -l`
        if (( STATUS == 1 )) ; then
            echo "$PROC is running..."
        else
            echo "$PROC is not running..."
        fi
        exit 0
}


case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  status)
        status
        ;;
  *)
        echo $"Usage: $0 {start|stop|status}"
        exit 2
esac

exit $?
