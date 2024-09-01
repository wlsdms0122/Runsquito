//
//  Runsquito.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/24.
//

import Foundation
import Combine

open class Runsquito {
    // MARK: - Property
    public static let `default` = Runsquito(description: "Default runsquito.")
    
    public private(set) var slots: [String: AnySlot] = [:]
    public let description: String?
    
    private let _valueWillChange = PassthroughSubject<String, Never>()
    public var valueWillChange: AnyPublisher<String, Never> { _valueWillChange.eraseToAnyPublisher() }
    
    public var cancellableBag: [String: AnyCancellable] = [:]
    
    // MARK: - Intiailzer
    public init(
        description: String? = nil,
        slots: [String: AnySlot] = [:]
    ) {
        self.description = description
        self.slots = slots
    }
    
    // MARK: - Public
    open func updateSlot<Value>(_ slot: Slot<Value>, forKey key: String) {
        slots[key] = slot.eraseToAnySlot()
        
        let cancellable = slot.valueWillChange
            .map { key }
            .multicast(subject: _valueWillChange)
            .connect()
        
        cancellableBag[key] = AnyCancellable(cancellable)
    }
    
    open func removeSlot(forKey key: String) {
        slots[key] = nil
        
        cancellableBag.removeValue(forKey: key)
    }
    
    open func removeAllSlots() {
        slots.forEach { key, _ in removeSlot(forKey: key) }
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
