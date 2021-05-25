//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

enum BodySource: Equatable {
    case inMemory(Data)
    case onDisk(URL)
}
