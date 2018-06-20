

import UIKit
import WebKit
import SwiftSocket

class ViewController: UIViewController {

    @IBOutlet weak var leftJoystick: CDJoystick!
    @IBOutlet weak var rightJoystick: CDJoystick!
    @IBOutlet weak var webView: WKWebView!

    let carCommunication = CarCommunication(withHost: Config.carIP, port: 8080)

    var threshold: Float = 0.05

    fileprivate(set) var car: Car!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupJoysticks()
        setupCameraView()

        DependencyContainer.car.parameterListeners?.append(self)
    }

    @IBAction func doPanic(_ sender: Any) {
        DependencyContainer.car.panic()
    }
}

extension ViewController: CarParameterListener {
    public func car(_ car: Car, didSetSteeringAngle steeringAngle: Float) {
       carCommunication.set(steeringAngle: steeringAngle)
    }

    public func car(_ car: Car, didSetSpeed speed: Float) {
       carCommunication.set(speed: speed)
    }

    public func carDidIssuePanic(_ car: Car) {
        carCommunication.panic()
    }
}

class CarCommunication {
    let host: String
    let port: Int32

    let socket: UDPClient

    fileprivate(set) var connected: Bool = false

    init(withHost host: String, port: Int32) {
        self.host = host
        self.port = port
        self.socket = UDPClient(address: host, port: port)
    }

    func set(steeringAngle angle: Float) {
        let dataString = "GET /steer/\(angle)"
        send(string: dataString)
    }

    func set(speed: Float) {
        let dataString = "GET /speed/\(speed)"
        send(string: dataString)

    }

    func panic() {
        let dataString = "GET /panic"
        send(string: dataString)

    }

    private func send(string: String) {
        _ = socket.send(string: string)
    }

}


extension ViewController {
    private func setupJoysticks() {
        leftJoystick.trackingHandler =  { data in
            let car = DependencyContainer.car
            let newVal = -1.0 * Float(data.velocity.x)
            if (fabsf(car.steeringAngle - newVal) > self.threshold) {
                car.steeringAngle = newVal * 90
            }
        }

        rightJoystick.trackingHandler =  { data in
            let car = DependencyContainer.car
            let newVal = Float(data.velocity.y) * 0.5
            if (fabsf(car.speed - newVal) > self.threshold) {
                car.speed = newVal
            }
        }
    }

    private func setupCameraView() {
        let url = URL(string:"http://\(Config.carIP):9090/stream/video.mjpeg")!
        let req = URLRequest(url:url)
        self.webView.navigationDelegate = self
        self.webView!.load(req)
    }
}


extension ViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DependencyContainer.logger.verbose("Started loading camera view")
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DependencyContainer.logger.verbose("Failed loading camera view: \(error)")
    }
}
