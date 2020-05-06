#!/bin/bash

if [[ "${1}" = "--help" || -z "${1}" ]]
then
  echo -e 'Example usage:\n  ./create-camtwist-profile.sh [PROFILE_NAME]'
  exit 0
fi

PROFILE_NAME=${1}

# perl -0777 -pe 's/\s//gm and s/.+<data>(.+)<\/data>.+/\1/g' "$@" | base64 -D | plutil -convert xml1 - -o -

PROFILE_PLIST="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>\$archiver</key>
	<string>NSKeyedArchiver</string>
	<key>\$objects</key>
	<array>
		<string>\$null</string>
		<string>DesktopPlus</string>
		<string>This screen</string>
		<string>{{0, 0}, {1280, 720}}</string>
		<string>Windowed Projector</string>
		<string>OBS</string>
		<string>Windowed Projector (Preview)</string>
		<string>{{0, 0}, {1280, 720}}</string>
	</array>
	<key>\$top</key>
	<dict>
		<key>appName</key>
		<dict>
			<key>CF\$UID</key>
			<integer>5</integer>
		</dict>
		<key>appTitle</key>
		<dict>
			<key>CF\$UID</key>
			<integer>6</integer>
		</dict>
		<key>class</key>
		<dict>
			<key>CF\$UID</key>
			<integer>1</integer>
		</dict>
		<key>confine</key>
		<true/>
		<key>cropRect</key>
		<dict>
			<key>CF\$UID</key>
			<integer>7</integer>
		</dict>
		<key>doNotScale</key>
		<true/>
		<key>enabled</key>
		<true/>
		<key>filterWindows</key>
		<true/>
		<key>fullScreen</key>
		<false/>
		<key>regex</key>
		<dict>
			<key>CF\$UID</key>
			<integer>4</integer>
		</dict>
		<key>regexSearch</key>
		<false/>
		<key>resizable</key>
		<false/>
		<key>screen</key>
		<dict>
			<key>CF\$UID</key>
			<integer>2</integer>
		</dict>
		<key>showMouse</key>
		<false/>
		<key>viewPortRect</key>
		<dict>
			<key>CF\$UID</key>
			<integer>3</integer>
		</dict>
	</dict>
	<key>\$version</key>
	<integer>100000</integer>
</dict>
</plist>"

BASE64_BINARY_PLIST=$(echo "${PROFILE_PLIST}" | plutil -convert binary1 - -o - | base64)

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>encoded</key>
	<array>
		<data>${BASE64_BINARY_PLIST}</data>
	</array>
	<key>midiKey</key>
	<integer>0</integer>
</dict>
</plist>" > ~/Library/Application\ Support/CamTwist/Saved\ Setups/${PROFILE_NAME}
