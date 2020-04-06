This is just-as-if-not-more-so janky as the previous method, but it relies on a video stream overe USB from the iPhone rather than screen sharing, which is then processed by some real broadcast software. What does that mean? It'll chew up way more resources, but you have options for much higher resolution video (i.e. 4K), and you won't have issues with notifications or extra artifacts in your feed. Here are the requirements:

* **Hardware**: Purchase and install an HDMI dummy plug: https://www.amazon.ca/gp/product/B0788HYC1S/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&th=1 **~$10.99** _(Fast delivery despite COVID-19!)_
* **iOS**: Download and install Camera for OBS Studio (iOS): https://apps.apple.com/ca/app/camera-for-obs-studio/id1352834008 **$21.99**
* **macOS**: Download and install OBS Studio (macOS): https://obsproject.com/download
* **macOS**: Download and install iOS Camera plugin for OBS Studio (macOS): https://obs.camera/docs/getting-started/ios-camera-plugin-usb/
* **macOS**: Download and install Zoom.us: https://zoom.us/download
* **macOS**: Download and install CamTwist Studio: http://camtwiststudio.com/download/

## On your iPhone...

1. Download and install Camera for OBS Studio
2. Open Camera for OBS Studio
3. Connect your iPhone to your Mac via USB
4. When prompted with "Trust This Computer?", select "Trust" _(This is what allows the screen to be shared natively via USB with macOS.)_

## On your Mac...

Go to System Preferences, select Mission Control, then uncheck Displays have separate Spaces. You will need to log out, then log back in again. This removes the menu bar on the dummy display, so that we can extract the native 1080p video that is getting streamed to it without any unwanted visual artifacts. It also prevents apps from opening on second "display".

The command below should do the same thing, although your milage may vary:

```
sudo defaults write com.apple.spaces spans-displays 1
```

Follow these instructions to set up OBS:

1. Plug in your HDMI dummy plug into a spare HDMI port _(You might need an extra dongle for this one.)_
2. Set your dummy display to separate display, and set the resolution of the dummy display to whatever you want your camera resolution to be
3. Open OBS Studio
4. Set up the iOS camera
5. Right click on the preview window, expand the Fullscreen Projector (Source) sub menu, then select the 1920x1080 display _(Likely "Display 2: 1920x1080 @ ..." or something to that effect.)_
6. Go to the OBS menu, select Preferences..., and select the General tab
7. Go to the Projectors heading, and check Save projectors on exit
8. Right click on the preview window, and uncheck the Enable preview menu item _(Optional: This will conserve resources.)_

This will ensure that configuration consumes the least amount of resources, and also opens up pre-configured by default.

Follow these instructions to set up CamTwist:

1. Open CamTwist, go to the Preferences... menu, and select the General tab
2. Select Custom from the Video Size select list, and enter 1920x1080 as the resolution _(This is so that no scaling is required when the 1080p desktop is captured.)_
3. Open CamTwist, from Video Sources select Display, then click on the Select button
4. Go to the Settings section, then select the additional display from the Screen select list
5. Go to the Adjust settings section, click on the Save Setup button, and give the setup and appropriate name
6. Go to the Saved Setups select box, select the newly created setup, and then click on the Auto load button so that the name of the setup is bolded

This will ensure that the virtual camera is configured to pull from the secondary display automatically when it is opened.

Follow these instructions to set up Zoom:

1. Open Zoom, go to Preferences..., and select Video
2. From Camera, select CamTwist

That is all you need for bare-bones setup with Zoom! However, you may have a mid-week and week-end meeting where you have to look nice and act appropriately. It you close CamTwist at this point, you'll notice the camera has a cool looking test pattern, and an ugly looking logo on the top. Want that logo to go away? Here's how:

1. Open Terminal
2. Type in the following command, then press enter: `sudo zsh -c 'echo iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII= | base64 -d -o /Library/CoreMediaIO/Plug-Ins/DAL/CamTwist.plugin/Contents/Resources/splash.png'` _(This overwrites the "splash" image the camera uses with a 1x1px transparent PNG that was decoded from a base64 string.)_
3. Type in your password when prompted

## Troubleshooting

### Camera for OBS Studio won't connect.

This is a bit of annoying one... Not sure what is causing it, but here is the process I've found you need to follow in order to get it to connect: Disconnect the USB cable, then force close OBS Camera on the device, and close OBS Studio on your Mac. After that open OBS Camera on iOS, orient the display appropriately, plug in the USB cable, then open OBS Studio on your Mac. You may need to open the iOS Camera source settings and reconnect the camera.
