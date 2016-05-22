#!/bin/bash

case "$1" in
	start)
		nohup java -jar /opt/webscan/lib/webscan-0.1.0.jar > /var/log/webscan.log &
		;;

	stop)
		;;

	*)
		echo "Usage: $NAME {start|stop|restart|reload|force-reload|status|configtest}" >&2
		exit 1
		;;
esac

exit 0
