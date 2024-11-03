//
//  RunsquitoError.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/29.
//

import Foundation

public enum RunsquitoError: LocalizedError {
    case typeMismatch
    case slotNotRegistered(String)
    
    public var errorDescription: String? {
        switch self {
        case .typeMismatch:
            "Failed to update the value of the slot because the value doesn't match the slot's type."
            
        case let .slotNotRegistered(key):
            "The slot registered as (\(key)) does not exist."
        }
    }
}
