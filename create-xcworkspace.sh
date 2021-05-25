#!/bin/bash

set -eu

rm -rf TestRpc.xcodeproj
rm -rf TestRpc.xcworkspace
./download-tools.sh
./bin/xcodegen/bin/xcodegen generate
xcodebuild -alltargets clean
cp IDETemplateMacros.plist TestRpc.xcodeproj/xcshareddata/.
bundle exec pod install
open TestRpc.xcworkspace
