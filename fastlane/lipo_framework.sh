#!/bin/bash -e

dir=`pwd`
echo "dir = ${dir}"
cd ../Carthage/Build/iOS/
lipo -info  ./Neptune.framework/Neptune
if [ ! -d "${dir}" ]; then
  mkdir ./bak
fi
cp -r Neptune.framework ./bak
lipo Neptune.framework/Neptune -thin armv7 -output Neptune_armv7
lipo Neptune.framework/Neptune -thin arm64 -output Neptune_arm64
lipo -create Neptune_armv7  Neptune_arm64 -output Neptune
mv Neptune Neptune.framework/
lipo -info ./Neptune.framework/Neptune

cd ${dir}
cd ../Carthage/Build/iOS/
lipo -info  ./Platinum.framework/Platinum
if [ ! -d "${dir}" ]; then
   mkdir ./bak
fi
cp -r Platinum.framework ./bak
lipo Platinum.framework/Platinum -thin armv7 -output Platinum_armv7
lipo Platinum.framework/Platinum -thin arm64 -output Platinum_arm64
lipo -create Platinum_armv7  Platinum_arm64 -output Platinum
mv Platinum Platinum.framework/
lipo -info ./Platinum.framework/Platinum


echo `pwd`
echo "dir = ${dir}"
cd ${dir}
cd  ../SmartHome/Resources/
lipo -info  ./DMH.framework/DMH
if [ ! -d "${dir}" ]; then
   mkdir ./bak
fi
cp -r DMH.framework ./bak
lipo DMH.framework/DMH -thin armv7 -output DMH_armv7
lipo DMH.framework/DMH -thin arm64 -output DMH_arm64
lipo -create DMH_armv7  DMH_arm64 -output DMH
mv DMH DMH.framework/
lipo -info ./DMH.framework/DMH

exit 0
