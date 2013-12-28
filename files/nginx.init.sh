#! /bin/sh

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon. Stops/reloads using nginx's -s flag
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/nginx/sbin/nginx
DAEMON_OPTS="-c /etc/nginx/nginx.conf"
NAME=nginx
DESC=nginx

test -x $DAEMON || exit 0

# Include nginx defaults if available
if [ -f /etc/default/nginx ] ; then
  . /etc/default/nginx
fi

set -e

case "$1" in
  start)
        if [ ! -f /var/run/nginx.pid ] ; then
          echo -n "Starting $DESC: "
          start-stop-daemon --start --quiet --pidfile /var/run/nginx.pid --exec $DAEMON -- $DAEMON_OPTS
        fi
        echo "$NAME."
        ;;

  stop)
        echo -n "Stopping $DESC: "
        if [ -f /var/run/nginx.pid ] ; then
          $DAEMON $DAEMON_OPTS -s stop
        fi
        echo "$NAME."
        ;;

  restart|force-reload)
        echo -n "Restarting $DESC: "
        if [ -f /var/run/nginx.pid ] ; then
          $DAEMON -s stop
          sleep 2
        fi

        start-stop-daemon --start --pidfile /var/run/nginx.pid --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;

  reload)
      echo -n "Reloading $DESC configuration: "
      if [ -f /var/run/nginx.pid ] ; then
        $DAEMON $DAEMON_OPTS -s reload
      else
        echo -n "Starting $DESC: "
        start-stop-daemon --start --quiet --pidfile /var/run/nginx.pid --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
      fi
      echo "$NAME."
      ;;

  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0
