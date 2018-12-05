#!/usr/bin/env bash
#-------------------------------------------------------
#      admin
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
PROGRAM=$(cat PROGRAM)
VERSION=$(cat VERSION)
echo "creating release for version $VERSION"
./admin.sh build
RELEASE=$PROGRAM-linux-64bit-$VERSION
rm -rf $RELEASE
mkdir -p $RELEASE
cp $PROGRAM install/install.sh install/uninstall.sh \
     _smoketest.sh $RELEASE
rm -f $RELEASE.tar.gz
tar cvzf $RELEASE.tar.gz $RELEASE/
rm -rf $RELEASE

