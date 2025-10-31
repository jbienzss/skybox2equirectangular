#!/bin/bash

if [ "$#" -lt "7" ] || [ "$#" -gt "8" ] ; then
	echo "usage: 		 ./sky2equi.sh <front> <back> <right> <left> <top> <bottom> <equirectangular> [<width>]"
	echo "e.g: 		./sky2equi.sh f.jpg b.jpg r.jpg l.jpg t.jpg b.jpg equi.jpg"
	echo "		./sky2equi.sh f.jpg b.jpg r.jpg l.jpg t.jpg b.jpg equi.jpg 4096"
	exit 0
fi

if [ -f "$7" ]; then
	echo "$7 already exists"
	exit 0
fi

if [ "$#" -eq "7" ] ; then
	WIDTH_SRC0=$(identify "$1"  | awk ' { print $3; } ' | awk -F x ' { print $1; } ')
	let "WIDTH = $WIDTH_SRC0 * 4"
else
	WIDTH=$8
fi

let "HEIGHT = $WIDTH / 2"

if [ "$HEIGHT" -lt "100" ] || [ "$HEIGHT" -gt "100000" ] ; then
	echo "size out of range"
	exit 0
fi

convert -size $(identify -format "%wx%h" "$4") xc:none empty.png

montage "empty.png" "$5" "empty.png" "empty.png" "$3" "$1" "$4" "$2" "empty.png" "$6" "empty.png" "empty.png" -tile 4x3 -geometry +0+0 -background none "$7"

echo "$7 created"


