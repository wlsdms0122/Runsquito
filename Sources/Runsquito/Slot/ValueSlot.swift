//
//  ValueSlot.swift
//  Runsquito
//
//  Created by JSilver on 11/3/24.
//

import Foundation

open class ValueSlot<Value>: Slot {
    // MARK: - Property
    /// The current set value.
    open private(set) var value: Value?
    /// The description of the slot.
    public let description: String?
    /// The value change event publisher.
    public let valueWillChange = ValueWillChangePublisher()
    
    // MARK: - Initializer
    public init(_ value: Value? = nil, description: String? = nil) {
        self.value = value
        self.description = description
    }
    
    // MARK: - Public
    open func setValue(_ value: Value?) throws {
        valueWillChange.send()
        self.value = value
    }
    
    // MARK: - Private
}
