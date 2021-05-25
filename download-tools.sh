#!/bin/sh

#  download-tools.sh
#  
#
#  Copyright © 2020 Surya Software Systems Pvt. Ltd.
#  

XOCDE_GEN=./bin/xcodegen/bin/xcodegen
if [ ! -f "$XOCDE_GEN" ]; then
    curl -LJ https://github.com/yonaskolb/XcodeGen/releases/download/2.18.0/xcodegen.zip \
     -o /tmp/xcodegen.zip

    unzip -o /tmp/xcodegen.zip -d ./bin/
fi
