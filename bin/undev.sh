#!/bin/bash

CHOSENLANG=$1

if [ -z "$CHOSENLANG" ]; then
  echo "Language specifier missing"
  exit
fi

TOTALSPACES_RESOURCES='/Applications/TotalSpaces2.app/Contents/Resources'

# need absolute path of the repo's root
pushd . > /dev/null
cd "$(dirname "$0")"
cd ..
ROOT=$PWD

TS_LANG_FOLDER=$TOTALSPACES_RESOURCES/$CHOSENLANG.lproj
TS_LANG_FOLDER_BACKUP=$TOTALSPACES_RESOURCES/$CHOSENLANG.lproj.backup
LOCAL_LANG_FOLDER=$ROOT/app/$CHOSENLANG.lproj

if [ -d "$TOTALSPACES_RESOURCES" ]; then # is it a folder?
  if [ -L "$TS_LANG_FOLDER" ]; then # is it a symlink?
    sudo rm "$TS_LANG_FOLDER"
    if [ -d "$TS_LANG_FOLDER_BACKUP" ]; then
      sudo mv "$TS_LANG_FOLDER_BACKUP" "$TS_LANG_FOLDER"
    fi
    exit
  fi
fi

echo "Failed: TotalSpaces2 is not installed or not in dev mode"
