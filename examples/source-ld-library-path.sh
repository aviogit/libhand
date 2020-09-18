#!/bin/bash

curr_pwd=`pwd`
dist_dir=`echo ${curr_pwd%%examples}dist`

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/OGRE-1.8.0/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/OGRE-1.9.0/:$dist_dir

