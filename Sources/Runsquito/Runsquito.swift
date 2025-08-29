//
//  Runsquito.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/24.
//

import Foundation
import Combine

public final class RunsquitoPublisher: Publisher {
    public typealias Output = String
    public typealias Failure = Never
    
    // MARK: - Property
    private let subject = PassthroughSubject<Output, Failure>()
    
    // MARK: - Initializer
    
    // MARK: - Lifecycle
    public func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        subject.subscribe(subscriber)
    }
    
    // MARK: - Public
    func send(_ input: Output) {
        subject.send(input)
    }
    
    // MARK: - Private
}

public final class Runsquito: Sendable {
    public typealias ValueWillChangePublisher = RunsquitoPublisher
    
    // MARK: - Property
    public static let `default` = Runsquito(description: "Default runsquito.")
    
    public private(set) nonisolated(unsafe) var slots: [String: AnySlot] = [:]
    public let description: String?
    
    public nonisolated(unsafe) let valueWillChange = ValueWillChangePublisher()
    
    private nonisolated(unsafe) var cancellableBag: [String: AnyCancellable] = [:]
    
    // MARK: - Intiailzer
    public init(
        description: String? = nil,
        slots: [String: AnySlot] = [:]
    ) {
        self.description = description
        self.slots = slots
    }
    
    // MARK: - Public
    public func updateSlot<S: Slot>(_ slot: S, for key: TypedKey<S.Value>) {
        slots[key.rawValue] = AnySlot(slot)
        
        cancellableBag[key.rawValue] = slot.valueWillChange
            .sink { [weak self] in self?.valueWillChange.send(key.rawValue) }
    }
    
    public func updateSlot<S: KeySlot>(_ slot: S) {
        slots[slot.key] = AnySlot(slot)
        
        cancellableBag[slot.key] = slot.valueWillChange
            .sink { [weak self] in self?.valueWillChange.send(slot.key) }
    }
    
    public func removeSlot<Value>(for key: TypedKey<Value>) {
        slots[key.rawValue] = nil
        cancellableBag.removeValue(forKey: key.rawValue)
    }
    
    public func removeAllSlots() {
        slots.map { key, _  in TypedKey<Any>(key) }
            .forEach { key in removeSlot(for: key) }
    }
    
    public func setValue<Value>(_ value: Value?, for key: TypedKey<Value>) throws {
        guard let slot = slots[key.rawValue] else { throw RunsquitoError.slotNotRegistered(key.rawValue) }
        try slot.setValue(value)
    }
    
    public func value<Value>(for key: TypedKey<Value>) -> Value? {
        slots[key.rawValue]?.value as? Value
    }
    
    public func value<Value>(for key: TypedKey<Value>, default value: Value) -> Value {
        slots[key.rawValue]?.value as? Value ?? value
    }
    
    // MARK: - Private
}
