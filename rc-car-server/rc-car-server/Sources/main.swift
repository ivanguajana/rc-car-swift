import Sockets
import Dispatch

enum Proto {
  case udp
  case tcp
}

let port = Port(8080)
let car = DependencyContainer.car
car.parameterListeners = [LoggingParameterListener(), GPIOActuatorParameterListener()]

let handler = DependencyContainer.handler

// Reference: https://github.com/vapor-community/sockets/tree/2.2.3/Tests/SocketsTests

DependencyContainer.logger.info("Starting server on UDP port \(port)")

let group = DispatchGroup()
group.enter()

background {
    do {
        let address = InternetAddress(hostname: "0.0.0.0", port: port)
        let serverStream = try UDPInternetSocket(address: address)

        try serverStream.bind()

        while true {
        let (data, sender) = try serverStream.recvfrom(maxBytes: 2048)
        let stringData = String(bytes: data, encoding: String.Encoding.ascii)!
        handler.handleRequest(req: stringData)

        }

        group.leave()

        try serverStream.close()

    } catch {
        DependencyContainer.logger.error("Error: \(error)")
    }
}

group.wait()