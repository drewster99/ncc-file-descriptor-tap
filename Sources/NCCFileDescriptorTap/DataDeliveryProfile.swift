//
//  DataDeliveryProfile.swift
//  Copyright (C) 2020 Nuclear Cyborg Corp
//
//  Created by Andrew Benson on 2/14/20.
//

import Foundation
import SwiftUI

public struct DataDeliveryProfile {
    /// Receives raw data as it is read
    var rawReceiver: ((_ data: Data, _ profile: Tap) -> Void)?

    /// Incoming data is parsed into individual lines (separated by newline), and
    /// is delivered to the callback 1 line at a time, with trailing newline removed.
    var stringReceiver: ((_ text: String, _ profile: Tap) -> Void)?

    /// Data is delivered in the same way as stringReceiver callback, but through a
    /// Binding<String>, suitable for use with SwiftUI
    var binding: Binding<String>

    public init(rawReceiver: ((_ data: Data, _ profile: Tap) -> Void)? = nil,
                stringReceiver: ((_ text: String, _ profile: Tap) -> Void)? = nil,
                binding: Binding<String> = Binding<String>(get: {""}, set: {_ in})) {
        self.rawReceiver = rawReceiver
        self.stringReceiver = stringReceiver
        self.binding = binding
    }
}
