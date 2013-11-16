#!/bin/bash

pushd . > /dev/null
cd "$(dirname "$0")"
cd ..

# quit TotalSpaces
osascript -e "tell application \"TotalSpaces2\" to quit"

killall -SIGINT TotalSpacesCrashWatcher

# start TotalSpaces agan
open /Applications/TotalSpaces2.app

popd > /dev/null
