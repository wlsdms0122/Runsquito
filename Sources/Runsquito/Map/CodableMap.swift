//
//  CodableMap.swift
//
//
//  Created by jsilver on 8/18/24.
//

import Foundation

public struct CodableMap<Value: Codable>: Map {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Public
    public func encode(_ value: Value) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }
    
    public func decode(from data: Data) throws -> Value {
        let decoder = JSONDecoder()
        return try decoder.decode(Value.self, from: data)
    }
    
    // MARK: - Private
}

public extension Mapper where Value: Codable {
    static var codable: Mapper<Value> { Mapper(CodableMap()) }
}
