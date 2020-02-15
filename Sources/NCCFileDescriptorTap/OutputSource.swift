//
//  File.swift
//  
//
//  Created by Andrew Benson on 2/14/20.
//

import Foundation

public enum OutputSource {
    case stdout
    case stderr
    case other(fileno: Int32)

    public var fileno: Int32 {
        switch self {
        case .stdout: return STDOUT_FILENO
        case .stderr: return STDERR_FILENO
        case .other(let fileno): return fileno
        }
    }
}
