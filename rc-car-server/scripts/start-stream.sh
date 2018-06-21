#! /bin/bash

uv4l -nopreview --auto-video_nr --driver raspicam --encoding mjpeg --width 640 --height 480 --framerate 20 --rotation 180 --server-option --port=9090 --server-option --max-queued-connections=30 --server-option --max-streams=25 --server-option --max-threads=29