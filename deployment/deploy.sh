#!/bin/bash
cp miew_*.tar.gz versions

echo "cleanup"
rm -r miew/
echo "unzip"
tar -xzf miew_*.tar.gz
rm miew_*.tar.gz
echo "start"
systemctl stop miew
systemctl start miew
echo "started"
