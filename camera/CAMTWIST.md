This method is crazy simple... The only hiccup you might encounter is having to [jump through some of macOS Catalina's new security hoops](https://support.apple.com/en-ca/HT202491). Here are the requirements:

* **macOS**: Download and install [Zoom.us](https://zoom.us/download)
* **macOS**: Download and install [CamTwist Studio](http://camtwiststudio.com/download/)
* **iOS**: Download and install [Hyperlapse](https://apps.apple.com/us/app/hyperlapse-from-instagram/id740146917) _(Why Hyperlapse? It is very very well supported, has great image stabilization for older iPhones, and most of all, it has a very simple uncluttered interface for screen sharing. It will also prevent your iPhone from automatically locking after a specific period of time.)_

## On your iPhone...

1. Enable Airplane mode, turn off Wi-fi, and turn off notifications _(This is so that you don't get notifications popping up over your camera, and don't have any unexpected updates downloading in the background choking up your connection.)_
2. Open Hyperlapse, and configure it to point at whatever you want to show up on your camera
3. Connect your iPhone to your Mac via USB
4. When prompted with "Trust This Computer?", select "Trust" _(This is what allows the screen to be shared natively via USB with macOS.)_

## On your Mac...

Follow these instructions to set up CamTwist:

1. Open CamTwist, go to the Preferences... menu, and select the General tab
2. Select Custom from the Video Size select list, and enter 1920x1080 as the resolution
3. Open CamTwist, from Video Sources select Webcam, then click on the Select button
4. From Settings, go to Camera, and select your iPhone

Follow these instructions to set up Zoom:

1. Open Zoom, go to Preferences..., and select Video
2. From Camera, select CamTwist

That is all you need for bare-bones setup with Zoom! However, you may have a mid-week and week-end meeting where you have to look nice and act appropriately. It you close CamTwist at this point, you'll notice the camera has a cool looking test pattern, and an ugly looking logo on the top. Want that logo to go away? Here's how:

1. Open Terminal
2. Type in the following command, then press enter: `sudo zsh -c 'echo iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII= | base64 -d -o /Library/CoreMediaIO/Plug-Ins/DAL/CamTwist.plugin/Contents/Resources/splash.png'` _(This overwrites the "splash" image the camera uses with a 1x1px transparent PNG that was decoded from a base64 string.)_
3. Type in your password when prompted