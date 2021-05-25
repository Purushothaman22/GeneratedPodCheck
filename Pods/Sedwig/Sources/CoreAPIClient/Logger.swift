//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

public protocol Logger {
    /// Logs message at `debug` level.
    func debug(message: () -> String)
    /// Logs message at `info` level.
    func info(message: () -> String)
    /// Logs message at `warning` level.
    func warn(message: () -> String)
    /// Logs message at `error` level.
    func error(message: () -> String)
}
