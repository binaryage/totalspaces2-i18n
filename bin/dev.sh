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

if [ ! -d "$TOTALSPACES_RESOURCES" ]; then # is it a folder?
  echo "Please install TotalSpaces2. Folder '$TOTALSPACES_RESOURCES' not found".
  popd > /dev/null
  exit
fi

TS_LANG_FOLDER=$TOTALSPACES_RESOURCES/$CHOSENLANG.lproj
TS_LANG_FOLDER_BACKUP=$TOTALSPACES_RESOURCES/$CHOSENLANG.lproj.backup
LOCAL_LANG_FOLDER=$ROOT/app/$CHOSENLANG.lproj

if [ ! -d "$LOCAL_LANG_FOLDER" ]; then
  mkdir "$LOCAL_LANG_FOLDER"
  cp "$ROOT/app/en.lproj/"* "$LOCAL_LANG_FOLDER"
fi

if [ -L "$TS_LANG_FOLDER" ]; then # is is a symlink?
  echo "TotalSpaces2 is already in dev mode for this language. Folder '$TS_LANG_FOLDER' is a symlink! Exiting.".
  popd > /dev/null
  exit
fi

# ok, we should be safe to do the replacement
if [ -d "$TS_LANG_FOLDER" ]; then
  sudo mv "$TS_LANG_FOLDER" "$TS_LANG_FOLDER_BACKUP"
fi
sudo ln -s "$LOCAL_LANG_FOLDER" "$TS_LANG_FOLDER"

popd > /dev/null
