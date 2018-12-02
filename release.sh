#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
VERSION=$(cat VERSION)
echo "creating release for version $VERSION"
./build.sh
RELEASE=nacl-cli-linux-64bit-$VERSION
rm -rf $RELEASE
mkdir -p $RELEASE
cp nacl-cli install.sh uninstall.sh $RELEASE
rm -f $RELEASE.tar.gz
tar cvzf $RELEASE.tar.gz $RELEASE/
rm -rf $RELEASE

