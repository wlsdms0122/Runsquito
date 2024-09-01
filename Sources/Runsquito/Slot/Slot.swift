//
//  Slot.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/31.
//

import Foundation
import Combine

open class Slot<Value> {
    public final class ValueChangePublisher: Publisher {
        public typealias Output = Void
        public typealias Failure = Never
        
        // MARK: - Property
        private let subject = PassthroughSubject<Void, Never>()
        
        // MARK: - Initializer
        init() { }
        
        // MARK: - Lifecycle
        public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            subject.subscribe(subscriber)
        }
        
        // MARK: - Public
        public func send() {
            subject.send(Void())
        }
        
        // MARK: - Private
    }
    
    // MARK: - Property
    /// The current set value.
    open private(set) var value: Value?
    /// The description of the slot.
    public let description: String?
    /// The value change event publisher.
    public let valueWillChange = ValueChangePublisher()
    
    // MARK: - Initializer
    public init(_ value: Value? = nil, description: String?) {
        self.value = value
        self.description = description
    }
    
    // MARK: - Public
    /// Set the current value.
    func setValue(_ value: Value?) throws {
        valueWillChange.send()
        self.value = value
    }
    
    // MARK: - Private
}

extension Slot {
    func eraseToAnySlot() -> AnySlot {
        AnySlot(self)
    }
}
