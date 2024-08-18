//
//  ValueSlot.swift
//  Runsquito
//
//  Created by jsilver on 2021/09/03.
//

import Foundation

open class ValueSlot<Value>: Slot {
    // MARK: - Prorperty
    public private(set) var value: Value?
    public let description: String?
    
    // MARK: - Initializer
    public init(
        value: Value? = nil,
        description: String? = nil
    ) {
        self.value = value
        self.description = description
    }
    
    // MARK: - Public
    open func setValue(_ value: Value?) {
        self.value = value
    }
    
    // MARK: - Private
}
