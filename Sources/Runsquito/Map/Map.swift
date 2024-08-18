//
//  SlotEncoder.swift
//
//
//  Created by jsilver on 8/18/24.
//

import Foundation

public protocol Map<Value> {
    associatedtype Value
    
    func encode(_ value: Value) throws -> Data
    func decode(from data: Data) throws -> Value
}

public struct Mapper<Value>: Map {
    // MARK: - Property
    private let map: any Map<Value>
    
    // MARK: - Initializer
    public init<M: Map>(_ map: M) where M.Value == Value {
        self.map = map
    }
    
    // MARK: - Public
    public func encode(_ value: Value) throws -> Data {
        try map.encode(value)
    }
    
    public func decode(from data: Data) throws -> Value {
        try map.decode(from: data)
    }
    
    // MARK: - Private
}
