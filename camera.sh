#!/bin/sh
fswebcam -r 960x720 -d /dev/video1 webcam.jpg
sleep 10
python /home/pi/Work/wayterm tweet "私はいまこんな景色をみてるよ。今日も早く帰ってきてね♡" "webcam.jpg"
