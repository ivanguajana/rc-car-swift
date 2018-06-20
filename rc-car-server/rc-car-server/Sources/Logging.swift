
import Foundation

enum LogLevel: Int {
    case verbose = 0
    case info
    case debug
    case warn
    case error
}

struct Logging {
    let level: LogLevel

    private let timeFormatter: DateFormatter = {
        // return ISO8601DateFormatter() // nope, not on linux
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()

    func verbose(_ msg: String) {
        ifLogLevel(.verbose) { log(msg) }
    }

    func debug(_ msg: String) {
        ifLogLevel(.debug) { log(msg) }
    }

    func info(_ msg: String) {
        ifLogLevel(.info) { log(msg) }
    }
    func warn(_ msg: String) {
        ifLogLevel(.warn) { log(msg) }
    }

    func error(_ msg: String) {
        ifLogLevel(.error) { log(msg) }
    }

    private func ifLogLevel(_ level: LogLevel, fun: () -> ()) {
        if level.rawValue >= self.level.rawValue {
            fun()
        }
    }

    private func log(_ msg: String) {
        print("[\(timeFormatter.string(from: Date()))] \(msg)")
    }
}
