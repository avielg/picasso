#!/bin/bash

# Following: https://developer.apple.com/documentation/xcode/creating-a-multi-platform-binary-framework-bundle
# Run this in Xcode Cloud? https://developer.apple.com/documentation/xcode/writing-custom-build-scripts

BUILD_DIR="_build_framework"
if [ ! -d $BUILD_DIR ]
then
	echo "Creating folder $BUILD_DIR/"
	mkdir $BUILD_DIR
fi

####################
# BUILD FRAMEWORKS #
####################

echo -n "Building iOS..."
xcodebuild archive \
  -project Picasso.xcodeproj \
  -scheme PicassoKit \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/PicassoKit-iOS" \
  &> "$BUILD_DIR/report_ios.log"

returnval=$?
if [ $returnval -eq 0 ]; then
  echo " ✔︎ Done"
else
  echo "FAILED: $returnval"
fi


echo -n "Building iOS Simulator..."
xcodebuild archive \
	-project Picasso.xcodeproj \
	-scheme PicassoKit \
	-destination "generic/platform=iOS Simulator" \
	-archivePath "$BUILD_DIR/PicassoKit-iOS_Simulator" \
	&> "$BUILD_DIR/report_ios_sim.log"

returnval=$?
if [ $returnval -eq 0 ]; then
  echo " ✔︎ Done"
else
  echo "FAILED: $returnval"
fi


echo -n "Building macOS..."
xcodebuild archive \
	-project Picasso.xcodeproj \
	-scheme PicassoKit \
	-destination "generic/platform=macOS" \
	-archivePath "$BUILD_DIR/PicassoKit-macOS" \
	&> "$BUILD_DIR/report_macos.log"
	
returnval=$?
if [ $returnval -eq 0 ]; then
  echo " ✔︎ Done"
else
  echo "FAILED: $returnval"
fi

#####################
# BUILD XCFRAMEWORK #
#####################

XCF_DIR="$BUILD_DIR/PicassoKit.xcframework"
if [ -e "$XCF_DIR" ]; then
	echo "Deleteing old xcframework..."
	rm -rf "$XCF_DIR"
fi  

echo "Building xcframework..."
xcodebuild -create-xcframework \
	-archive "$BUILD_DIR/PicassoKit-iOS.xcarchive" -framework PicassoKit.framework \
	-archive "$BUILD_DIR/PicassoKit-iOS_Simulator.xcarchive" -framework PicassoKit.framework \
	-archive "$BUILD_DIR/PicassoKit-macOS.xcarchive" -framework PicassoKit.framework \
	-output "$XCF_DIR"
