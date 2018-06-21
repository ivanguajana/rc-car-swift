import Foundation
import SwiftyGPIO

public class GPIOActuatorParameterListener: CarParameterListener {

    let pwmSteering: PWMOutput
    let pwmAcceleration: PWMOutput

    init() {
        //let pwms = SwiftyGPIO.hardwarePWMs(for: .RaspberryPi3)!
        let pwms = SwiftyGPIO.hardwarePWMs(for: .RaspberryPiPlusZero)!
        pwmSteering = (pwms[0]?[.P18])!
        pwmSteering.initPWM()

        pwmAcceleration = (pwms[1]?[.P13])!
        pwmAcceleration.initPWM()
    }

    deinit {
        pwmSteering.stopPWM()
    }

    public func car(_ car: Car, didSetSteeringAngle steeringAngle: Float) {
        steer(to: steeringAngle)
    }

    public func car(_ car: Car, didSetSpeed speed: Float) {
        accelerate(to: speed)
    }

    public func carDidIssuePanic(_ car: Car) {
        steer(to: 0)
        accelerate(to: 0)
    }

    private func steer(to angle: Float) {
        let min: Float = 5
        let max: Float = 12
        let range = max - min

        let mappedAngle = range / Float(180) * (angle + Float(90)) + min

        pwmSteering.startPWM(period:20_000_000, duty: mappedAngle)

        if angle == 0 {
            pwmSteering.stopPWM()
        }
    }

    private func accelerate(to speed: Float) {
        let min: Float = 5
        let max: Float = 12
        let range = max - min

        let mappedSpeed = range / Float(180) * (speed + Float(90)) + min

        pwmAcceleration.startPWM(period:20_000_000, duty: mappedSpeed)

        if speed == 0 {
            pwmAcceleration.stopPWM()
        }
    }
}
