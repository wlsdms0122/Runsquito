//
//  AnySlot.swift
//  Runsquito
//
//  Created by jsilver on 2021/08/31.
//

import Foundation

/// Type erased `Slot`
public class AnySlot: Slot<Any> {
    // MARK: - Property
    private let _value: () -> Any?
    public override var value: Any? { _value() }
    
    private let _setValue: (Any?) throws -> Void
    
    // MARK: - Initializer
    public init<Value>(_ slot: Slot<Value>) {
        self._value = { slot.value }
        self._setValue =  { value in
            switch value {
            case let .some(value):
                guard let value = value as? Value else { throw RunsquitoError.typeMismatch }
                try slot.setValue(value)
                
            case .none:
                try slot.setValue(nil)
            }
        }
        
        super.init(slot.value, description: slot.description)
    }
    
    // MARK: - Public
    public override func setValue(_ value: Any?) throws {
        try _setValue(value)
    }
    
    // MARK: - Private
}
