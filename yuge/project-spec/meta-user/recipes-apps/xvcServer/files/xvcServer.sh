#! /bin/sh
# starts the virtual cable server
# YUGE 
# wittich
# 2/1/2018

#dropbear-inspired

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/xvcServer
NAME=xvcServer.sh
DESC="Xilinx Virtual Cable server"
PIDFILE=/var/run/xvcServer.pid

set -e


test ! -r /etc/default/xvcServer || . /etc/default/xvcServer
test "$NO_START" = "0" || exit 0
test -x "$DAEMON" || exit 0
test ! -h /var/service/xvcServer || exit 0


case "$1" in
  start)
	echo -n "Starting $DESC: "
	gen_keys
	start-stop-daemon -S -p $PIDFILE \
	  -x "$DAEMON" 
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	start-stop-daemon -K -x "$DAEMON" -p $PIDFILE
	echo "$NAME."
	;;
  restart|force-reload)
	echo -n "Restarting $DESC: "
	start-stop-daemon -K -x "$DAEMON" -p $PIDFILE
	sleep 1
	start-stop-daemon -S -p $PIDFILE \
	  -x "$DAEMON" 
	echo "$NAME."
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload}" >&2
	exit 1
	;;
esac

exit 0
