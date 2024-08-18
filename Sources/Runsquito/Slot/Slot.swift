//
//  Slot.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/31.
//

import Foundation

public protocol Slot {
    associatedtype Value
    
    /// The current set value.
    var value: Value? { get }
    /// The description of the slot.
    var description: String? { get }
    
    /// Set the current value.
    func setValue(_ value: Value?) throws
}

extension Slot {
    func eraseToAnySlot() -> AnySlot {
        AnySlot(self)
    }
}
