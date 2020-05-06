#!/bin/bash

SCRIPT_DIR=$(dirname $(which ${0}))
${SCRIPT_DIR}/create-camtwist-profile.sh "iPhone"

# cat ~/Library/Preferences/com.allocinit.CamTwist.plist | plutil -convert xml1 - -o -

plutil -replace autoload -string iPhone ~/Library/Preferences/com.allocinit.CamTwist.plist 
plutil -replace noVirtualDriver -bool false ~/Library/Preferences/com.allocinit.CamTwist.plist 
plutil -replace usingCustomVideoSize -bool false ~/Library/Preferences/com.allocinit.CamTwist.plist 
plutil -replace videoSize -string "{1280, 720}" ~/Library/Preferences/com.allocinit.CamTwist.plist 
plutil -replace frameRate -integer 30 ~/Library/Preferences/com.allocinit.CamTwist.plist 
