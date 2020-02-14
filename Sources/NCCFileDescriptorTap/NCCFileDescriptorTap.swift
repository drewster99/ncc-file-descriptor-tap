//  NCCFileDescriptorTap.swift
//
//  Created by Andrew Benson on 2/13/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
class NCCFileDescriptorTap {

    private(set) var taps: [Tap] = []

    public func add(_ tap: Tap) {
        taps.append(tap)
    }

    public func remove(_ id: Tap.ID) {
        taps.removeAll { (profile) -> Bool in
            profile.id == id
        }
    }

    public func remove(_ tap: Tap) {
        remove(tap.id)
    }
}


