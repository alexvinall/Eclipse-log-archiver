#!/bin/bash
# archive.sh
# (C) Alex Vinall 2017
# Archives log files into a 7-zip archive per month, using Ultra compression.
# Intended to be used with log files where the filename ends with:
# ${current_date}.out

# Archives log files into 7z archives per month
echo "Archiving log files..."

# Find months to archive
months=($(ls -l | egrep [0-9]{8}_[0-9]{4}.out | egrep -o 20[0-9]{4} | sort | uniq))

# Check for any months to archive
size=${#months[@]}
if [ $size -lt 1 ]
then
  echo "Nothing to archive."
else
  # Archive each month
  for i in "${months[@]}"
  do
    year=$(echo $i | cut -c1-4)
    month=$(echo $i | cut -c5-6)
    echo "Archiving $year-$month..."
    status=$(7z a -t7z -mx=9 Archive/$year-$month-Logs.7z *$i*.out | tail -n 1)
    echo "7-zip reports: $status"
    if [ "$status" == "Everything is Ok" ]
    then
      echo "$year-$month: archived OK, removing log files."
      rm *$i*.out
    else
      echo "$year-$month: archive error, log files will not be removed."
    fi
  done
fi
