#! /usr/bin/env nix-shell
#! nix-shell -p ffmpeg_6-full -i bash

# takes a camera feed from a web address
# and converts it into a webcam feed

if [[ -z $1 ]]; then
    echo "Usage: cam [IPCamera address]"
    false
else
    ffmpeg -f mjpeg -i "http://$1/live" -pix_fmt yuv420p -f v4l2 /dev/video0
fi
