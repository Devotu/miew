#!/bin/bash

echo "-- restore from backup --"
echo -e "date"
read date
echo -e "custom tag"
read tag

backup_path="backup/data_$date$tag.pack"

echo "-- removing current data --"
rm -r "data"

echo "-- restarting application --"
systemctl restart miew

echo "-- unpacking backup --"
tar -xzf $backup_path

echo "-- restored from backup --"
