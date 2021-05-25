//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// A dummy logger which always executes a no-op.
public struct NoOpLogger: Logger {
    public func debug(message _: () -> String) {}

    public func info(message _: () -> String) {}

    public func warn(message _: () -> String) {}

    public func error(message _: () -> String) {}

    public init() {}
}
