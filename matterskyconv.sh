#!/bin/bash

if [ "$#" -lt "1" ] || [ "$#" -gt "3" ] ; then
	echo "usage: 		 ./mattersky2equi.sh <one matterport skybox> [<width>] [<format>]"
	echo "e.g: 		./mattersky2equi.sh pan-high-1-skybox0.jpg"
	echo "		./mattersky2equi.sh pan-high-1-skybox0.jpg 4096"
	echo "		./mattersky2equi.sh pan-high-1-skybox0.jpg 4096 strip"
	echo "formats:	equi (default) | strip | cross"
	exit 0
fi

name=$(echo $* | awk -F skybox ' { print $1; } ')

# Parse arguments more flexibly
width=""
format="equi"  # default format

# Check if we have a second argument
if [ "$2" != "" ]; then
    # If it's numeric, it's the width, otherwise it's the format
    if [[ $2 =~ ^[0-9]+$ ]]; then
        width=$2
        format=${3:-equi}
    else
        format=$2
        width=$3
    fi
fi

echo "name is $name"
echo "format is $format"
echo "width is $width"

ts0=$(date +%s)

case $format in
    "equi")
        ./sky2equi.sh "$name"skybox1.jpg "$name"skybox3.jpg "$name"skybox4.jpg "$name"skybox2.jpg "$name"skybox0.jpg "$name"skybox5.jpg "$name"equi.jpg $width
        ;;
    "strip")
        ./sky2strip.sh "$name"skybox1.jpg "$name"skybox3.jpg "$name"skybox4.jpg "$name"skybox2.jpg "$name"skybox0.jpg "$name"skybox5.jpg "$name"strip.jpg $width
        ;;
    "cross")
        ./sky2cross.sh "$name"skybox1.jpg "$name"skybox3.jpg "$name"skybox4.jpg "$name"skybox2.jpg "$name"skybox0.jpg "$name"skybox5.jpg "$name"cross.jpg $width
        ;;
    *)
        echo "Invalid format: $format. Using default (equi)"
        script="./sky2equi.sh"
        ;;
esac

ts1=$(date +%s)
let "dif = $ts1 - $ts0"
echo "Time elapsed $dif seconds"
