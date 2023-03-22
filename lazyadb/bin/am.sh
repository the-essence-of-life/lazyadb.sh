## Notice
# This script references the termux script
# Later, it will be modified by this idea

#!/bin/bash
DIR=`cd $(dirname $0) && pwd`
FONTS_DIR=$DIR/am
count=0

echo -e "The default font is Ubuntu font.\nYou can choose another one from list below.";

for font in $(ls ${DIR}/am/*.sh); do
	font_file[count]=$font;
	echo "[$count] $( echo ${font_file[count]} | awk -F'/' '{print $NF}' )";
	count=$(( $count + 1));
done;
count=$(( $count - 1 ));

while true; do
	read -p 'Enter a number, leave blank to not to change:' number;

	if [[ -z "$number" ]]; then
		break;
	elif ! [[ $number =~ ^[0-9]+$ ]]; then
		echo "Please enter the right number.";
	elif (( $number >= 0 && $number <= $count )); then
		bash "${font_file[number]}"
		break;
	else
		echo "Please enter the right number.";
	fi
done;
