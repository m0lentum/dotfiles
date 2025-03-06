#! /usr/bin/env nix-shell
#! nix-shell -p busybox file imagemagick -i bash

A4_ASPECT=1.4142

src=$1
if [ -z "$src" ]; then
    echo "source file pls"
    exit 1
fi
dest=$2
if [ -z "$dest" ]; then
    dest=$src
fi

dims=$(file "$src" | rg '^.*, ([0-9]+\s?x\s?[0-9]+),.*$' -r '$1')
w=$(echo $dims | rg '^([0-9]+)\s?x.*$' -r '$1')
h=$(echo $dims | rg '^[0-9]+\s?x\s?([0-9]+)$' -r '$1')
if [ $h -gt $w ]; then
    echo "portrait"
    aspect_error=$(echo "($h/$w)-$A4_ASPECT" | bc -l)
    if [ "${aspect_error:0:1}" != "-" ]; then
	target_h=$h
	target_w=$(echo "$h/$A4_ASPECT" | bc -l | xargs printf "%.0f")
	echo "padding horizontally to ${target_w}x${target_h}"
    else
	target_w=$w
	target_h=$(echo "$w*$A4_ASPECT" | bc -l | xargs printf "%.0f")
	echo "padding vertically to ${target_w}x${target_h}"
    fi
else
    echo "landscape"
    aspect_error=$(echo "($w/$h)-$A4_ASPECT" | bc -l)
    if [ "${aspect_error:0:1}" != "-" ]; then
	target_w=$w
	target_h=$(echo "$w/$A4_ASPECT" | bc -l | xargs printf "%.0f")
	echo "padding vertically to ${target_w}x${target_h}"
    else
	target_h=$h
	target_w=$(echo "$h*$A4_ASPECT" | bc -l | xargs printf "%.0f")
	echo "padding horizontally to ${target_w}x${target_h}"
    fi
fi

dims="${target_w}x${target_h}"
magick "$src" -resize "$dims" -background white -gravity northwest -extent "$dims" "$dest"
