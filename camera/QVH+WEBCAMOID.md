Low latency, low sync proven working with Webcamoid:

```
go run main.go gstreamer --pipeline "queue name=audio_target ! wavparse ignore-length=true ! audioconvert ! faac ! aacparse ! mux.
  queue name=video_target ! h264parse ! vtdec ! videoconvert ! aspectratiocrop aspect-ratio=16/9 ! videoscale ! video/x-raw,width=1280,height=720 ! videorate ! video/x-raw,framerate=15/1 ! x264enc tune=zerolatency speed-preset=superfast ! h264parse ! mux.
  mpegtsmux name=mux ! tcpserversink host=localhost port=7000 sync=false"
```

High latency, high sync proven working with Webcamoid:

```
go run main.go gstreamer --pipeline "queue name=audio_target ! wavparse ignore-length=true ! audioconvert ! faac ! aacparse ! queue2 ! mux.
  queue name=video_target ! h264parse ! vtdec ! videoconvert ! aspectratiocrop aspect-ratio=16/9 ! videoscale ! video/x-raw,width=1280,height=720 ! videorate ! video/x-raw,framerate=15/1 ! x264enc tune=zerolatency speed-preset=superfast ! h264parse ! queue2 ! mux.
  mpegtsmux name=mux ! tcpserversink host=localhost port=7000 recover-policy=keyframe sync-method=latest-keyframe"
```

Hyperlapse capture with colour correction:

```
go run main.go gstreamer --pipeline "queue name=audio_target ! wavparse ignore-length=true ! audioconvert ! faac ! aacparse ! mux.
  queue name=video_target ! h264parse ! vtdec ! videoconvert ! aspectratiocrop aspect-ratio=16/9 ! videobalance hue=-0.1 ! videoscale ! video/x-raw,width=1280,height=720 ! videorate ! video/x-raw,framerate=30/1 ! x264enc tune=zerolatency speed-preset=superfast ! h264parse ! mux.
  mpegtsmux name=mux ! tcpserversink host=localhost port=7000 sync=false"
```

Camera app capture with cropping on iPhone 11:

```
go run main.go gstreamer --pipeline "queue name=audio_target ! wavparse ignore-length=true ! audioconvert ! faac ! aacparse ! mux.
  queue name=video_target ! h264parse ! vtdec ! videoconvert ! videoflip method=counterclockwise ! videocrop left=242 right=446 ! videoscale ! video/x-raw,width=640,height=480 ! videorate ! video/x-raw,framerate=30/1 ! x264enc tune=zerolatency speed-preset=superfast ! h264parse ! mux.
  mpegtsmux name=mux ! tcpserversink host=localhost port=7000 sync=false"
```
