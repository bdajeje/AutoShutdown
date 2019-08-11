#!/usr/bin/env bash

if [ "$#" -ne 4 ]; then
  echo "Usage:

  install.sh load after_time before_time frequency

Note: Please check run.sh help for parameters documentation."
  exit 1
fi

service_name=autoshutdown_load.service
service_filepath=/lib/systemd/system/$service_name

service_content=`cat autoshutdown_load.service`
service_content=`echo ${service_content/__LOAD__/$1}`
service_content=`echo ${service_content/__AFTER_TIME__/$2}`
service_content=`echo ${service_content/__BEFORE_TIME__/$3}`
service_content=`echo ${service_content/__FREQUENCY__/$4}`

echo $service_content >> $service_filepath
chmod u+x $service_filepath
sudo systemctl start $service_name
sudo systemctl enable $service_name
