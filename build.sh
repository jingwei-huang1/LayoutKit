#!/bin/sh
# Builds all targets and runs tests.

# Defined default derived data location
DERIVED_DATA=${1:-/tmp/LayoutKit}
echo "Derived data location: $DERIVED_DATA";

    #-destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \
    #-destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=8.4' \

set -o pipefail &&
echo "Install 9.3 simulators" &&
xcrun simctl create 'iPhone 6' \
    com.apple.CoreSimulator.SimDeviceType.iPhone-5 \
    com.apple.CoreSimulator.SimRuntime.iOS-9-3 &&
xcrun simctl create 'iPhone 6 Plus' \
    com.apple.CoreSimulator.SimDeviceType.iPhone-5 \
    com.apple.CoreSimulator.SimRuntime.iOS-9-3 &&

echo "Run test on iOS..." &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-iOS \
    -sdk iphonesimulator10.3 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.3' \
    -destination 'platform=iOS Simulator,name=iPhone 7 Plus,OS=10.3' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh