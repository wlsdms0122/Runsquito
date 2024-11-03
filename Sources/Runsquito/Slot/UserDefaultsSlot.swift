//
//  UserDefaultsSlot.swift
//
//
//  Created by jsilver on 8/18/24.
//

import Foundation

public extension Runsquito {
    static var userDefaults: UserDefaults? { UserDefaults(suiteName: "_runsquito") }
}

open class UserDefaultsSlot<Value>: Slot, KeyPresentable {
    // MARK: - Prorperty
    private let userDefaults: UserDefaults?
    public let key: String
    private let mapper: any Map<Value>
    
    open var value: Value? {
        guard let data = userDefaults?.data(forKey: key) else { return nil }
        return try? mapper.decode(from: data)
    }
    public let description: String?
    public let valueWillChange = ValueWillChangePublisher()
    
    // MARK: - Initializer
    public init(
        forKey key: String,
        mapper: Mapper<Value>,
        in userDefaults: UserDefaults? = Runsquito.userDefaults,
        description: String? = nil
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.mapper = mapper
        self.description = description
    }
    
    public convenience init(
        forKey key: String,
        in userDefaults: UserDefaults? = Runsquito.userDefaults,
        description: String? = nil
    ) where Value: Codable {
        self.init(
            forKey: key,
            mapper: .codable,
            in: userDefaults,
            description: description
        )
    }
    
    public convenience init(
        for key: TypedKey<Value>,
        mapper: Mapper<Value>,
        in userDefaults: UserDefaults? = Runsquito.userDefaults,
        description: String? = nil
    ) {
        self.init(
            forKey: key.rawValue,
            mapper: mapper,
            in: userDefaults,
            description: description
        )
    }
    
    public convenience init(
        for key: TypedKey<Value>,
        in userDefaults: UserDefaults? = Runsquito.userDefaults,
        description: String? = nil
    ) where Value: Codable {
        self.init(
            for: key,
            mapper: .codable,
            in: userDefaults,
            description: description
        )
    }
    
    // MARK: - Public
    open func setValue(_ value: Value?) throws {
        guard let value else {
            userDefaults?.removeObject(forKey: key)
            valueWillChange.send()
            return
        }
        
        userDefaults?.set(try mapper.encode(value), forKey: key)
        valueWillChange.send()
    }
    
    // MARK: - Private
}
