First, download and unzip Raspbian:

```
mkdir assets
curl -o assets/raspbian_2019-07-10.zip http://director.downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-07-12/2019-07-10-raspbian-buster-lite.zip
unzip -p assets/raspbian_2019-07-10.zip > assets/raspbian_2019-07-10.img

curl -o assets/raspbian_2020-02-05.zip http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-07/2020-02-05-raspbian-buster-lite.zip
unzip -p assets/raspbian_2020-02-05.zip > assets/raspbian_2020-02-05.img

curl -o assets/raspbian_2020-02-13.zip http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/2020-02-13-raspbian-buster-lite.zip
unzip -p assets/raspbian_2020-02-13.zip > assets/raspbian_2020-02-13.img
```

Next, flash the image to a TF card:

```
diskutil list
diskutil unmountDisk /dev/disk4
sudo dd bs=1m if=assets/raspbian_2019-07-10.img of=/dev/rdisk4
```

Upload the `wpa_supplicant.conf` file to the Pi Zero's boot partition, enable SSH, and disable all the cruft we don't need:

```
echo "country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev

network={
  ssid=\"SSID\"
  scan_ssid=1
  psk=\"password\"
  key_mgmt=WPA-PSK
}" > /Volumes/boot/wpa_supplicant.conf

cp cmdline.txt /Volumes/boot/cmdline.txt
cp config.txt /Volumes/boot/config.txt
touch /Volumes/boot/ssh
```

Unmount the TF card and insert it in the Pi Zero. The following command will unmount the TF card:

```
diskutil unmountDisk /dev/disk4
```

Power up the Pi Zero, and connect to to the Pi Zero via SSH using the following command: _(The password is `raspberry` by default)_

```
ssh-keygen -R raspberrypi && ssh pi@raspberrypi
sudo apt-get install -y v4l2loopback-dkms
sudo modprobe v4l2loopback
sudo modprobe g_webcam
curl -L -o uvc.gz https://github.com/jdonald/uvc-gadget/files/1443504/uvc-gadget.gz && gunzip uvc.gz && chmod 755 uvc
sudo ./uvc -d -r 1 -s 2 -u /dev/video1 -v /dev/video0
```