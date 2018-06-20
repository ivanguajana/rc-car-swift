
import Foundation

public protocol CarParameterListener {
    func car(_ car: Car, didSetSteeringAngle: Float)
    func car(_ car: Car, didSetSpeed: Float)
    func carDidIssuePanic(_ car: Car)
}

public class Car {
    public var parameterListeners: [CarParameterListener]? = nil

    public var steeringAngle: Float {
        didSet {
            parameterListeners?.forEach { $0.car(self, didSetSteeringAngle: steeringAngle) }
        }
    }

    public var speed: Float {
        didSet {
            parameterListeners?.forEach { $0.car(self, didSetSpeed: speed) }
        }
    }

    public func panic() {
        parameterListeners?.forEach { $0.carDidIssuePanic(self) }
    }

    public init() {
        steeringAngle = 0
        speed = 0
    }

    public init(withParameterListeners carParameterListeners: [CarParameterListener]) {
        steeringAngle = 0
        speed = 0
        parameterListeners = carParameterListeners
    }
}

