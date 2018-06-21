This repository contains material relevant to SwiftAveiro's 2018 Swift and IoT presentation. The goal is to control an RC car with an iOS app via WiFi. The code on the RC car is running on a Raspberry Pi Zero W and is written in Swift.

Refer to the readme files in each project's directory.

**NOTE** This is a proof of concept and is not meant to be used in any productive way. Have fun with it.

## rc-car-server

Contains the server-side implementation (i.e. the car's program). It listens on a UDP socket for commands to accelerate / steer and applies the relevant changes to the Raspberry's GPIO pins.

## RcCar-iOS

Contains an iOS application rendering two virtual joysticks to send acceleration/steering commands to the car.

If the car provides a video feed, it is displayed in the background.

## presentation

The `presentation` directory contains the actual presentation slides in markdown (Deckset) format.

## Credits

The virtual joystick implementation is by Cole Dunsby (original at https://github.com/Coledunsby/CDJoystick, via @BontoJR).