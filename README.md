# iPhone to macOS camera

If you're anything like me, you've probably got an iPhone that is a couple of generations old sitting unused in a box. Now that you're locked in your home becuase of the little SARS-CoV-2 virii floating around these days, you may need video conferencing _and_ screen sharing on the same call; the days of flubbing it with your iPad are over. Of course, you MacBook has a camera built in, but it sucks, and more importantly, opening your MacBook will mess up you windows on your big monitor.

The solution? Buy a webcam on Amazon... But delivery is now over 1 month becuase Amazon only delivers toilet paper and pasta, and [apparently can't afford to pay their driver's sick leave](https://www.snopes.com/fact-check/amazon-donations-sick-leave/)? Whatever.

You know there is a better way... You know you that 12-megapixel Sony Exmos RS camera with it's six-element lens on your old iPhone 7 is a gazillion times better than whatever top-of-line webcam Logitech is trying to sell you. Also, you're webcam now has resale value and it's 2GHz+ quad-core processor. If that is your predicament, then this repo is for you.

_**Note**: I wrote this for my own use... And right now I only use Zoom. This won't work with 1st-party apps like Facetime. Your milage may vary with other 3rd-party apps._

_**Note**: All of these techniques try to take advantage of direct connections between the device and the host computer. This reduces the liklihood of connection errors, latency issues, and bottlenecks due to router performance or internet bandwidth limitations._

## Configuring your iPhone as a macOS camera

This is intended to be become a list of all various ways you can configure an iOS device as a webcam/camera. Hopefully it'll inspire the development of some more elegant solutions as time goes on.

You may also be thinking what I did the first couple of times I saw this... I'm on macOS Catalina 10.15.3, so CamTwist will not work due to code signing and SIP. It does, and it's really easy. I suspect that part of the solution is install these apps the old-school way; i.e. not using the App Store. If you haven't install an app this way for a while, it might seem like macOS gives you a hard no when you attempt to open one of these apps. **You will need to [go to System Preferences, Security & Privacy, General, and select Open Anyway](https://support.apple.com/en-ca/HT202491) _after_ getting denied in order to proceed.** After you've done that, you'll be able to open the app normally moving forward.

* [Less configuration, less polished result](camera/CAMTWIST.md) (Using only CamTwist)
* [More configuration, more polished result](camera/OBS+CAMTWIST.md) (Using OBS Studio and CamTwist)

## Screen sharing your iPad via Zoom for macOS

This is another one of my specific use cases... I have a application that only has an iOS client, which I need to share during Zoom meetings. These are the methods you can use to share your iPad's screen:

* [Over USB](https://support.zoom.us/hc/en-us/articles/201379235-iOS-Screen-Sharing-with-the-Zoom-Desktop-Client) (When an iOS camera **is not** being utilized)
* [Over USB via AirPlay](screen-sharing/USB+AIRPLAY.md) (When an iOS camera **is** being utilized)
