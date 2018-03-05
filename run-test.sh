#!/bin/bash

#start xvfb
XVFB=/usr/bin/Xvfb
XVFBARGS=":1 -screen 0 1336x768x24"
XVFBPIDFILE=/tmp/xvfb.pid
echo starting Xvfb...
start-stop-daemon --start --quiet --pidfile $XVFBPIDFILE --make-pidfile --background --exec $XVFB -- $XVFBARGS
echo started Xvfb.
sleep 2

#start recorder
LOCAL=$(pwd)
RECORDER=/usr/bin/ffmpeg
RECORDERARGS="-y -framerate 25 -video_size 1336x768 -f x11grab -i :1.0 -c:v libx264rgb -crf 0 -preset ultrafast $LOCAL/out.mkv"

RECORDERPIDFILE=/tmp/recorder.pid
echo starting recorder...
start-stop-daemon --start --quiet --pidfile $RECORDERPIDFILE --make-pidfile --background --exec $RECORDER -- $RECORDERARGS
echo started recorder.

#run test
echo running test...
DISPLAY=:1.0 node test.js
echo runned test.


#stop
echo stopping recorder...
start-stop-daemon --stop --quiet --pidfile $RECORDERPIDFILE
echo stopped recorder.

echo stopping Xvfb...
start-stop-daemon --stop --quiet --pidfile $XVFBPIDFILE
echo stopped Xvfb.

echo remasterizando...
ffmpeg -y -i $LOCAL/out.mkv -vf scale=1024:860 -c:v libx264 -preset fast -c:a aac $LOCAL/output.mp4 -hide_banner
echo remasterizado.
rm $LOCAL/out.mkv