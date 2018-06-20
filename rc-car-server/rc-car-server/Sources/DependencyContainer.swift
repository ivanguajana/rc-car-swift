
import Foundation

struct DependencyContainer {
    static let logger = Logging(level: .verbose)
    static let car = Car()
    static let handler = Handler(car)
}
