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

public extension OutputSource {
    static func from(_ fileno: Int32) -> OutputSource {
        switch fileno {
        case STDOUT_FILENO:
            return .stdout
        case STDERR_FILENO:
            return .stderr
        default:
            return .other(fileno :fileno)
        }
    }
}

extension OutputSource: CustomStringConvertible {
    public var description: String {
        switch self {
        case .stdout: return "stdout"
        case .stderr: return "stderr"
        case .other(let fileno): return "fileno \(fileno)"
        }
    }
}
