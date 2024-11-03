//
//  Slot.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/31.
//

import Foundation
import Combine

public final class SlotPublisher: Publisher {
    public typealias Output = Void
    public typealias Failure = Never
    
    // MARK: - Property
    private let subject = PassthroughSubject<Output, Failure>()
    
    // MARK: - Initializer
    init() { }
    
    // MARK: - Lifecycle
    public func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        subject.subscribe(subscriber)
    }
    
    // MARK: - Public
    public func send() {
        subject.send(Void())
    }
    
    // MARK: - Private
}

open class Slot<Value> {
    public typealias ValueWillChangePublisher = SlotPublisher
    
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
