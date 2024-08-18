//
//  RunsquitoError.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/29.
//

import Foundation

public enum RunsquitoError: LocalizedError {
    case typeMismatch
    
    public var errorDescription: String? {
        switch self {
        case .typeMismatch:
            return "Failed to update because the value doesn't match the slot's value type."
        }
    }
}
