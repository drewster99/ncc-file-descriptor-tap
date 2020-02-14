//
//  ProcessingMode.swift
//  Copyright (C) 2020 Nuclear Cyborg Corp
//
//  Created by Andrew Benson on 2/14/20.
//

import Foundation

/// The processing mode to be employed.
public enum ProcessingMode {
    /// Data is also passed along to its original destination
    case tap

    /// Data is redirected only.  No data will be sent to the original destination.
    case redirect
}
