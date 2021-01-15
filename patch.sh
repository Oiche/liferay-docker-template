#!/bin/sh

echo PATCHING: Starting...

cd /opt/liferay/patching-tool

# echo PATCHING: Reverting...

# ./patching-tool.sh revert

echo PATCHING: Installing...

./patching-tool.sh install

echo PATCHING: Completed