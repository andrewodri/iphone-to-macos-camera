# iPhone to macOS camera

If you're anything like me, you've probably got an iPhone that is a couple of generations old sitting unused in a box. Now that you're locked in your home becuase of the little SARS-CoV-2 virii floating around these days, you may need video conferencing _and_ screen sharing on the same call; the days of flubbing it with your iPad are over. Of course, you MacBook has a camera built in, but it sucks, and more importantly, opening your MacBook will mess up you windows on your big monitor.

The solution? Buy a webcam on Amazon... But delivery is now over 1 month becuase Amazon only delivers toilet paper and pasta, and [apparently can't afford to pay their driver's sick leave](https://www.snopes.com/fact-check/amazon-donations-sick-leave/)? Whatever.

You know there is a better way... You know you that 12-megapixel Sony Exmos RS camera with it's six-element lens on your old iPhone 7 is a gazillion times better than whatever top-of-line webcam Logitech is trying to sell you. Also, you're webcam now has resale value and it's 2GHz+ quad-core processor. If that is your predicament, then this repo is for you.

_**Note**: I wrote this for my own use... And right now I only use Zoom. This won't work with 1st-party apps like Facetime. Your milage may vary with other 3rd-party apps._

_**Note**: All of these techniques try to take advantage of direct connections between the device and the host computer. This reduces the liklihood of connection errors, latency issues, and bottlenecks due to router performance or internet bandwidth limitations._

## Configuring your iPhone as a macOS camera

This is intended to be become a list of all various ways you can configure an iOS device as a webcam/camera. Hopefully it'll inspire the development of some more elegant solutions as time goes on.

If your video conferencing application does not allow access to virtual cameras (e.g. Zoom), you will need to self sign it. I've tested this on Zoom 5.0.2 _without an Apple Developer Certificate_, and it worked great. This can be done via the following command:

```
sudo codesign -f -s - /Applications/zoom.us.app
```

You will need to enter your password when prompted.

You may also be thinking what I did the first couple of times I saw this... I'm on macOS Catalina 10.15.3, so CamTwist will not work due to code signing and SIP. It does, and it's really easy. I suspect that part of the solution is install these apps the old-school way; i.e. not using the App Store. If you haven't install an app this way for a while, it might seem like macOS gives you a hard no when you attempt to open one of these apps. **You will need to [go to System Preferences, Security & Privacy, General, and select Open Anyway](https://support.apple.com/en-ca/HT202491) _after_ getting denied in order to proceed.** After you've done that, you'll be able to open the app normally moving forward.

* [Less configuration, less polished result](camera/CAMTWIST.md) (Using only CamTwist)
* [More configuration, more polished result (1080p via hardware)](camera/OBS+CAMTWIST_1080P.md) (Using OBS Studio, CamTwist, and an HDMI dummy adapter)
* [More configuration, more polished result (720p via software)](camera/OBS+CAMTWIST_720P.md) (Using OBS Studio, CamTwist, and crazy software configs)

## Screen sharing your iPad via Zoom for macOS

This is another one of my specific use cases... I have a application that only has an iOS client, which I need to share during Zoom meetings. These are the methods you can use to share your iPad's screen:

* [Over USB](https://support.zoom.us/hc/en-us/articles/201379235-iOS-Screen-Sharing-with-the-Zoom-Desktop-Client) (When an iOS camera **is not** being utilized)
* [Over USB via AirPlay](screen-sharing/USB+AIRPLAY.md) (When an iOS camera **is** being utilized)

## Solution imagineering

The techniques below are high-level notes on a few existing and possibly compatible approaches that could used to put together a dedicated solution with the lowest possible overhead.

The headings below will eventually get moved into the following documents:

* [CoreMediaIO DAL Plug-in approach](camera/QVH+WEBCAMOID.md)
* [Single-board-computer UVC gadget approach](camera/QVH+SBC-UVC.md)

### Capturing video and audio from iOS via USB

The best (i.e. most grokkable) implementation of video and audio capture I've seen to date is the [quicktime video hack](https://github.com/danielpaulus/quicktime_video_hack) project by [Daniel Paulus](https://github.com/danielpaulus). It's written in [Go](https://golang.org/), and outputs to [gstreamer](https://gstreamer.freedesktop.org/documentation/plugins_doc.html?gi-language=c), which makes output manipulation _extremely_ easy and flexible. The process it employs along with a changelog of challenges encountered and conquered is also available.

From what I can tell, the things you need to do are:

1. You need to enable ["Quicktime Capture" mode](https://github.com/danielpaulus/quicktime_video_hack/blob/master/doc/technical_documentation.md#13-hidden-configuration) via USB,
2. [Work your way back from the gstreamer targets](https://github.com/danielpaulus/quicktime_video_hack/blob/master/screencapture/gstadapter/gst_adapter_macos.go) to get the least processed usable streams you need for integration

### Creating a macOS virtual camera

Virtual cameras are actually a bona-fide thing in macOS. They utilize [CoreMedia API "Device Abstraction Layer" (DAL) plug-ins](https://developer.apple.com/library/archive/samplecode/CoreMediaIO/Introduction/Intro.html), as opposed to the Hardware Abstraction Layer (HAL). If you have some installed, you can poke around here: `/Library/CoreMediaIO/Plug-Ins/DAL/YourFancyVirtualCamera.plugin/`

While SIP prevents unsigned cameras from being used in 1st party apps in newer versions of macOS, they can be used with all 3rd party apps under Catalina (as far as I've tested at the time of writing anyway).

[Webcamoid](https://github.com/webcamoid/webcamoid/) provides this functionality... It's clunky and leans hard into QT, so I'd probably need to convinced for using that code without heavy refactoring for a macOS specific solution. But it's the only open source thing out there that works. The code is pretty tough (for me) to grok, but from what I can tell, the party starts in the [IpcBridge](https://github.com/webcamoid/webcamoid/blob/4000735bd2f5678153b44d6133d1a9307964772a/libAvKys/Plugins/VirtualCamera/src/dshow/VCamIPC/src/ipcbridge.cpp).

### Creating an SBC UVC camera device

I feel like this could be a really slick solution... Provided performance was adequate, if a modified QVH could be run on a small SBC, like a Raspberry Pi Zero, and register as UVC camera, then you could have a sub-$20 adapter that registers as a hardware camera and gives macOS (and every other OS for that matter) a trusted camera device to work with.

The only gotcha there is that there is very little high-level code that handles registration/de-registration as a gadget... This is a probably the place to start: https://stackoverflow.com/questions/42895950/usb-gadget-device-mode-configfs-uvc-and-mass-storage-on-single-configurat
