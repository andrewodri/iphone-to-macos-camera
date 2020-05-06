This is just-as-if-not-more-so janky as the previous method, but it relies on a video stream overe USB from the iPhone rather than screen sharing, which is then processed by some real broadcast software. What does that mean? It'll chew up way more resources, but you have options for much higher resolution video (i.e. 4K), and you won't have issues with notifications or extra artifacts in your feed. Here are the requirements:

* **iOS**: Download and install [Camera for OBS Studio](https://apps.apple.com/ca/app/camera-for-obs-studio/id1352834008): **$21.99**
* **macOS**: Download and install [OBS Studio](https://obsproject.com/download)
* **macOS**: Download and install [iOS Camera plugin for OBS Studio](https://obs.camera/docs/getting-started/ios-camera-plugin-usb/)
* **macOS**: Download and install [Zoom.us](https://zoom.us/download)
* **macOS**: Download and install [CamTwist Studio](http://camtwiststudio.com/download/)

## On your iPhone...

1. Download and install Camera for OBS Studio
2. Open Camera for OBS Studio
3. Connect your iPhone to your Mac via USB
4. When prompted with "Trust This Computer?", select "Trust" _(This is what allows the screen to be shared natively via USB with macOS.)_

## On your Mac...

It assumed that you have opened OBS, and added the desired iOS Camera to the default scene.

Follow these instructions to set up OBS and CamTwist:

1. Open Terminal
2. Run `git clone https://github.com/andrewodri/iphone-to-macos-camera.git && cd iphone-to-macos-camera`
3. Run `./scripts/configure-obs.sh`
4. Run `./scripts/configure-camtwist.sh`

This will tell OBS to always open with a windowed projector where the content is exactly 1280 x 720px. It will then configure CamTwist with a fixed window profile that finds the projector, and captures the exact content region. It then sets the virtual camera created by CamTwist to 1280 x 720px. This should allow you to capture clear video with minimal scaling overhead or loss of quality.

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
