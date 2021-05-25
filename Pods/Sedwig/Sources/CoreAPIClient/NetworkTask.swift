//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines a networking task.
public protocol NetworkTask {
    /// Used to proceed with the networking task.
    func resume()
    /// Used to cancel the networking task.
    func cancel()
}
