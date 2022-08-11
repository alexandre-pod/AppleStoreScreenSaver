#!/bin/bash

####################################################################################################
# How to run:
#
# cp .env.template .env
# # Fill .env.template
# source .env
# ./distribute.sh
####################################################################################################


xcodebuild archive -scheme AppleStoreScreenSaver \
	-archivePath "output/archive.xcarchive" \
	-derivedDataPath "tmp_derived_data"


SCREEN_SAVER_OUTPUT_DIRECTORY="output/archive.xcarchive/Products"
SCREEN_SAVER_GENERATED="$SCREEN_SAVER_OUTPUT_DIRECTORY/AppleStoreScreenSaver.saver"

codesign \
	-s "$DEVELOPER_ID_CERTIFICATE" \
	-i fr.podlewski.alexandre.appleStoreScreenSaver \
	--timestamp \
	--options=runtime \
	--force \
	"$SCREEN_SAVER_GENERATED"

pushd "$SCREEN_SAVER_OUTPUT_DIRECTORY"
zip -r ../../screensaver.zip "AppleStoreScreenSaver.saver"
popd

xcrun notarytool submit output/screensaver.zip \
	--key $API_KEY_PATH \
	--key-id $API_KEY_ID \
	--issuer $API_KEY_ISSUER \
	--wait
xcrun stapler staple "$SCREEN_SAVER_GENERATED"

pushd "$SCREEN_SAVER_OUTPUT_DIRECTORY"
rm ../../screensaver.zip
zip -r ../../screensaver.zip "AppleStoreScreenSaver.saver"
popd
