
import Foundation

struct DependencyContainer {
    static let logger = Logging(level: .verbose)
    static let car = Car(withParameterListeners: [LoggingParameterListener()])
}


struct Config {
    static let carIP = "192.168.1.34"
}
