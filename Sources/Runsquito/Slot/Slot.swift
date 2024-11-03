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

public protocol Slot {
    associatedtype Value
    
    typealias ValueWillChangePublisher = SlotPublisher
    
    var value: Value? { get }
    var description: String? { get }
    var valueWillChange: ValueWillChangePublisher { get }
    
    func setValue(_ value: Value?) throws
}

public protocol KeyPresentable {
    associatedtype Value
    
    var key: String { get }
}
