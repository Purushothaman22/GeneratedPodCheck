//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

// Lazy variables are not thread safe in Swift.
// This is a work-around for a thread safe implementation.
class LazyProvider<T> {
    private var lock: NSLock?
    private var initialized: Bool
    private var lazyParameter: T?

    init() {
        lock = NSLock()
        initialized = false
    }

    func getLazyParameter(onRetrieval: () -> T?) -> T? {
        defer {
            lock?.unlock()
            lock = nil
        }
        lock?.lock()
        if initialized {
            return lazyParameter
        } else {
            lazyParameter = onRetrieval()
            initialized = true
            return lazyParameter
        }
    }
}
