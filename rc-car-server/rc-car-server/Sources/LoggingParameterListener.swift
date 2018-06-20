
import Foundation

public struct LoggingParameterListener: CarParameterListener {
    public func car(_ car: Car, didSetSteeringAngle steeringAngle: Float) {
        DependencyContainer.logger.info("[\(car)] Setting steering angle to \(steeringAngle)")
    }

    public func car(_ car: Car, didSetSpeed speed: Float) {
        DependencyContainer.logger.info("[\(car)] Setting speed to \(speed)")
    }

    public func carDidIssuePanic(_ car: Car) {
        DependencyContainer.logger.info("[\(car)] Panic!")
    }

    public init() {}
}
