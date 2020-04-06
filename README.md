# iPhone to macOS camera

If you're anything like me, you've probably got an iPhone that is a couple of generations old sitting unused in a box. Now that you're locked in your home becuase of the little SARS-CoV-2 virii floating around these days, you may need video conferencing _and_ screen sharing on the same call; the days of flubbing it with your iPad are over. Of course, you MacBook has a camera built in, but it sucks, and more importantly, opening your MacBook will mess up you windows on your big monitor.

The solution? Buy a webcam on Amazon... But delivery is now over 1 month becuase Amazon only delivers toilet paper and pasta, and [apparently can't afford to pay their driver's sick leave](https://www.snopes.com/fact-check/amazon-donations-sick-leave/)? Whatever.

You know there is a better way... You know you that 12-megapixel Sony Exmos RS camera with it's six-element lens on your old iPhone 7 is a gazillion times better than whatever top-of-line webcam Logitech is trying to sell you. Also, you're webcam now has resale value and it's 2GHz+ quad-core processor. If that is your predicament, then this repo is for you.

**Note: I wrote this for my own use... And right now I only use Zoom. This won't work with 1st-party apps like Facetime. Your milage may vary with other 3rd-party apps.**

## Method 1: Quick, cheap, and nasty

I'm on macOS Catalina 10.15.3, so by all measures this shouldn't work due to code signing and SIP, but it does, and it's really easy. I suspect that is becuase Zoom are bosses when it comes to going out of there way to ensure compatibility. Here are the requirements:

* Download and install Zoom.us: https://zoom.us/download
* Download and install CamTwist Studio: http://camtwiststudio.com/download/

_On your iPhone:_

1. Download and install Hyperlapse: https://apps.apple.com/us/app/hyperlapse-from-instagram/id740146917 _(Why Hyperlapse? It is very very supported, has great image stabilization for older iPhones, and most of all, it has very simple uncluttered interface for screen sharing.)_
2. Enable Airplane mode, turn off Wi-fi, and turn off notifications _(This is so that you don't get notifications popping up during your camera, and don't have any unexpected updates downloading in the background.)_
3. Open Hyperlapse, and configure it point at whatever you want to show up on your camera
4. Plug your iPhone into your Mac
5. When prompted with "Trust This Computer?", select "Trust" _(This is what allows the screen to be shared natively via USB with macOS.)_

_On your Mac:_

1. Open CamTwist, from Video Sources select Webcam, then click on the Select button
2. From Settings, go to Camera, and select your iPhone
3. Open Zoom, go to Preferences..., and select Video
4. From Camera, select CamTwist

That is all you need for bare-bones setup with Zoom! However, you may have a mid-week and week-end meeting where you have to look nice and act appropriately. It you close CamTwist at this point, you'll notice the camera has a cool looking test pattern, and an ugly looking logo on the top. Want that logo to go away? Here's how:

1. Open Terminal
2. Type in the following command, then press enter: `sudo zsh -c 'echo iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII= | base64 -d -o /Library/CoreMediaIO/Plug-Ins/DAL/CamTwist.plugin/Contents/Resources/splash.png'` _(This overwrites the "splash" image the camera uses with a 1x1px transparent PNG that was decoded from a base64 string.)_
3. Type in your password when prompted

## Method 2: Cumbersome, low-cost, and little more polished

This is a just-as-if-not-more-so janky as the previous method, but it relies on a video stream overe USB from the iPhone rather than screen sharing, which is then processed by some real broadcast software. What does that mean? It'll chew up way more resources, but you have options for much higher resolution video (i.e. 4K), and you won't have issues with notifications or extra artifacts in your feed. Here are the requirements:

* Download and install Camera for OBS Studio (iOS): https://apps.apple.com/ca/app/camera-for-obs-studio/id1352834008 **$21.99**
* Download and install OBS Studio (macOS): https://obsproject.com/download
* Download and install isOS Camera plugin for OBS Studio (macOS): https://obs.camera/docs/getting-started/ios-camera-plugin-usb/
* Download and install Zoom.us: https://zoom.us/download
* Download and install CamTwist Studio: http://camtwiststudio.com/download/
* Purchase and install an HDMI dummy plug: https://www.amazon.ca/gp/product/B0788HYC1S/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&th=1 **~$10.99**

_On your iPhone:_

1. Download and install Camera for OBS Studio
2. Open Camera for OBS Studio
3. Plug your iPhone into your Mac
4. When prompted with "Trust This Computer?", select "Trust" _(This is what allows the screen to be shared natively via USB with macOS.)_

_On your Mac:_

Go to System Preferences, select Mission Control, then uncheck Displays have separate Spaces. You will need to log out, then log back in again. This removes the menu bar on the dummy display, so that we can extract the native 1080p video that is getting streamed to it without any unwanted visual artifacts. It also prevents apps from opening on second "display".

The command below should do the same thing, although your milage may vary:

```
sudo defaults write com.apple.spaces spans-displays 1
```

1. Plug in your HDMI dummy plug into a spare HDMI port _(You might need an extra dongle for this one.)_
2. Set your dummy display to separate display, and set the resolution of the dummy display to whatever you want your camera resolution to be
3. Open OBS Studio
4. Set up the iOS camera
5. Set right click on the preview and select send to display
6. Open CamTwist, from Video Sources select Display, then click on the Select button
7. From Settings, go to ???, and select ???
8. Open Zoom, go to Preferences..., and select Video
9. From Camera, select CamTwist

_More to come..._