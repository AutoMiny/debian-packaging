#!/bin/bash

apt-get update
apt-get install -y python-catkin-tools
cd /opt
git clone https://github.com/autominy/autominy.git
cd /opt/autominy/catkin_ws
source /opt/ros/melodic/setup.bash
rosdep install --from-paths . --ignore-src --rosdistro=melodic --simulate | awk 'NF>1{print $NF}' | sed '1d' | paste -sd "," - > DEPS
DEPENDENCIES=$(cat DEPS)
VERSION=$(git rev-parse --short HEAD)
BUILDDATE=$(date +"%Y%m%d%H%M")
rosdep install --from-paths . --ignore-src --rosdistro=melodic -y
catkin build

cd /opt
git clone https://github.com/autominy/debian-packaging.git
cd debian-packaging
sed -i -e "s/DEPS/$DEPENDENCIES/g" autominy-basic-packages/DEBIAN/control
sed -i -e "s/DATE/$BUILDDATE-$VERSION/g" autominy-basic-packages/DEBIAN/control
cp -r /opt/autominy autominy-basic-packages/opt/ 
dpkg-deb --build autominy-basic-packages

exec "$@"
