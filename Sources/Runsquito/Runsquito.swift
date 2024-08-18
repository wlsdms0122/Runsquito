//
//  Runsquito.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/24.
//

import Foundation

open class Runsquito {
    // MARK: - Property
    public static let `default` = Runsquito(description: "Default runsquito.")
    
    public private(set) var slots: [String: AnySlot] = [:]
    public let description: String?
    
    // MARK: - Intiailzer
    public init(
        description: String? = nil,
        slots: [String: AnySlot] = [:]
    ) {
        self.description = description
        self.slots = slots
    }
    
    // MARK: - Public
    open func updateSlot<S>(_ slot: S, forKey key: String) where S: Slot {
        slots[key] = slot.eraseToAnySlot()
    }
    
    open func removeSlot(forKey key: String) {
        slots[key] = nil
    }
    
    open func removeAllSlots() {
        slots.removeAll()
    }
    
    open func setValue<Value>(_ value: Value?, forKey key: String) throws {
        try slots[key]?.setValue(value)
    }
    
    open func value<T>(_ type: T.Type = T.self, forKey key: String) -> T? {
        slots[key]?.value as? T
    }
    
    open func value<T>(_ type: T.Type = T.self, forKey key: String, default value: T) -> T {
        slots[key]?.value as? T ?? value
    }
    
    // MARK: - Private
}
