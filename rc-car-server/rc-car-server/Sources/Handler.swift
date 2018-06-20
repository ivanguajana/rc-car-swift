
import Foundation

enum Command {
  case steer(angle: Float)
  case speed(value: Float)
  case panic
  case unknown(cmd: String)
}

class Handler {
  private let car: Car

  init(_ car: Car) {
    self.car = car
  }

  private func parseRequest(req: String) throws -> Command {
    let components = req.components(separatedBy: "/")
    DependencyContainer.logger.verbose(" -> \(components)")

    let command: String?
    let argument: Float?

    if components.count > 1 {
      command = components[1]
    } else {
      command = nil
      return .unknown(cmd: req)
    }

    if components.count > 2 {
      argument = Float(components[2])
    } else {
      argument = nil
    }

    switch command {
      case .some("steer"):
        return .steer(angle: argument ?? 0)
      case .some("speed"):
        return .speed(value: argument ?? 0)
      case .some("panic"):
        return .panic
      case .none:
        return .unknown(cmd: "<not parsed>")
      default:
        return .unknown(cmd: command!)
    }
  }

  func handleRequest(req: String) {
    DependencyContainer.logger.verbose("Incoming: \(req)")

    do {
      let cmd = try parseRequest(req: req)

      switch cmd {
        case .steer(let angle):
          car.steeringAngle = angle
        case .speed(let value):
          car.speed = value
        case .panic:
          car.steeringAngle = 0
          car.speed = 0
        case .unknown(let cmd):
          DependencyContainer.logger.error("Unknown command: \(cmd)")
      }
    } catch {
      DependencyContainer.logger.error("Error parsing request: \(error)")
    }
  }
}