## Development

Start swift 3.1.1 container with

```
docker run -it --rm --cap-add sys_ptrace -p 8080:8080 --volume $PWD:/src --name swift-car swift:3.1.1 bash

cd /src/rc-car-server/rc-car-server
swift build && ./.build/debug/rc-car-server
```

See https://hub.docker.com/_/swift/. This will allow development on swift 3.1.1 on linux. Note that this is not the RPi architecture, so the best way to actually to it is

* directly on the Pi (see next section)
* using QEMU

### Remotely to the RPi

```
./devinit.sh
```

The script will watch for code changes and synchronize them to the RPi. You can develop locally and have a shell to the Pi open to build and run the program.

## Dependencies

https://www.uraimo.com/2017/09/06/A-small-update-on-Swift-for-raspberry-pi-zero-1-2-3/

* swift 3.1.1 (swift 4.x is not ready for ARM platforms yet)
* Vapor sockets 2.x (v3 requires swift 4)

# Camera

If you want to stream a live video feed from a camera attached to the RPi, proceed as follows

**Install uv4l**

http://www.linux-projects.org/uv4l/installation/

```
curl http://www.linux-projects.org/listing/uv4l_repo/lpkey.asc | sudo apt-key add -

# add this line to /etc/apt/sources.list
deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/stretch stretch main

sudo apt-get update
sudo apt-get install uv4l uv4l-raspicam uv4l-raspicam-extras uv4l-webrtc
```

**Start/Stop/Restart uv4l**

```
./rc-car-server/scripts/start-stream.sh
```

**Note** this has been quite unstable for me on the Pi Zero W, causing complete system freezes. On a RPi 3 B, on the other hand, it has worked flawlessly. I haven't had time to look into the issue, but I suspect it's a problem of overheating / overloading the system.

## GPIO

Refer to https://pinout.xyz for the GPIO pin layout. Used pins are configured in `Sources/GPIOActuatorParameterListener.swift`.

**Servo**

orange -> PWM0 (BCM 18)
red ->  V+ (Power 5V)
yellow -> GND (Ground)

**Speed Control**

orange -> PWM1 (BCM 13)
red -> <unused>
yellow -> GND (Ground)

In order to test the connections, connect 2 servos and run `cd rc-car-server/scripts/test-all-servos.py`. Both servos are supposed to rotate at 1 second intervals until the program is ended with `crtl-c`.

