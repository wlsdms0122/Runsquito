//
//  AnySlot.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/31.
//

import Foundation

/// Type erased `Slot`
public class AnySlot: Slot {
    // MARK: - Property
    private let _value: () -> Any?
    public var value: Any? { _value() }
    
    private let _description: () -> String?
    public var description: String? { _description() }
    private let _valueWillChange: () -> ValueWillChangePublisher
    public var valueWillChange: ValueWillChangePublisher { _valueWillChange() }
    
    private let _setValue: (Any?) throws -> Void
    
    // MARK: - Initializer
    public init<S: Slot>(_ slot: S) {
        self._value = { slot.value }
        self._description = { slot.description }
        self._valueWillChange = { slot.valueWillChange }
        self._setValue =  { value in
            switch value {
            case let .some(value):
                guard let value = value as? S.Value else { throw RunsquitoError.typeMismatch }
                try slot.setValue(value)
                
            case .none:
                try slot.setValue(nil)
            }
        }
    }
    
    // MARK: - Public
    public func setValue(_ value: Any?) throws {
        try _setValue(value)
    }
    
    // MARK: - Private
}
