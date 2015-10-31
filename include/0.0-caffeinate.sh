#!/bin/sh


# Suppress Sleep

caffeinate_start() {
  caffeinate &
  caffeinate_PID=$!
  disown $caffeinate_PID
}

caffeinate_stop() {
  kill -9 $caffeinate_PID
}
