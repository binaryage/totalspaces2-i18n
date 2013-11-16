#!/bin/bash

pushd . > /dev/null
cd "$(dirname "$0")"
cd ..

# quit TotalSpaces
osascript -e "tell application \"TotalSpaces\" to quit"

killall -SIGINT TotalSpacesCrashWatcher

# start TotalSpaces agan
open /Applications/TotalSpaces.app

popd > /dev/null
