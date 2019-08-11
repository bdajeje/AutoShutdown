#!/usr/bin/env bash

function showHelp()
{
  echo "Usage:
  \n
    run.sh [load] [shutdown after] [shutdown before] [check frequency]
  \n
    Arguments:
    \n
      load: Will shutdown only under given load from last 15 mins (as given by /proc/loadavg).\n
      shutdown after: Will shutdown only after given time (format %H:%M).\n
      shutdown before: Will shutdown only before given time (format %H:%M).\n
      check frequency: Program's check up every X seconds.
  "
}

if [ "$#" -ne 4 ]; then
  showHelp
  exit 1
fi

shutdown_under_load=$1
shutdown_after_hour=`echo $2 | sed -e 's/:/\n/g' | sed -n 1p`
shutdown_after_mins=`echo $2 | sed -e 's/:/\n/g' | sed -n 2p`
shutdown_before_hour=`echo $3 | sed -e 's/:/\n/g' | sed -n 1p`
sleep_time=$4

echo "Shutdown programed between: '$shutdown_after_hour:$shutdown_after_mins' and '$shutdown_before_hour:$shutdown_before_mins' under a load of '$shutdown_under_load'"
echo "Check frequency: $sleep_time seconds"

while true; do
  current_hour=`date +"%H"`
  current_mins=`date +"%M"`

  echo "current time: $current_hour:$current_mins"

  if [ "$current_hour" -ge "$shutdown_after_hour" ] &&
     [ "$current_mins" -ge "$shutdown_after_mins" ] &&
     [ "$current_hour" -lt "$shutdown_before_hour" ]; then
    load=`cut -d ' ' -f3 <<< cat /proc/loadavg`
    echo "current load: $load"

    is_under_load=`echo $load'<'$shutdown_under_load | bc -l`
    if [ "$is_under_load" -eq 1 ]; then
      shutdown now
    fi
  fi

  sleep $sleep_time
done
