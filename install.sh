#!/bin/bash

SUBDIR=~/Code
mkdir -p $SUBDIR

source /opt/ros/lunar/setup.bash
sudo apt-get purge ros-lunar-libg2o libqglviewer-dev
rosdep update
sudo apt-get install libsuitesparse-dev libeigen3-dev
G2O_REPO_DIR=$SUBDIR/g2ofork
git clone -b c++03 https://github.com/felixendres/g2o.git $G2O_REPO_DIR
mkdir $G2O_REPO_DIR/build
cd $G2O_REPO_DIR/build
cmake .. -DCMAKE_INSTALL_PREFIX=$G2O_REPO_DIR/install -DG2O_BUILD_EXAMPLES=OFF
nice make -j2 install
WORKSPACE=$SUBDIR/rgbdslam_catkin_ws
mkdir -p $WORKSPACE/src
cd $WORKSPACE/src
catkin_init_workspace
catkin_make -C $WORKSPACE
source $WORKSPACE/devel/setup.bash
export G2O_DIR=$G2O_REPO_DIR/install
git clone -b lunar https://github.com/szymonrychu/rgbdslam_v2.git $WORKSPACE/src/rgbdslam
rosdep install rgbdslam
catkin_make -C $WORKSPACE -j2

