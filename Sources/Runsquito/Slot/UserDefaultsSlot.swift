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

open class UserDefaultsSlot<Value>: Slot<Value> {
    // MARK: - Prorperty
    private let userDefaults: UserDefaults?
    private let key: String
    private let mapper: any Map<Value>
    
    open override var value: Value? {
        guard let data = userDefaults?.data(forKey: key) else { return nil }
        return try? mapper.decode(from: data)
    }
    
    // MARK: - Initializer
    public init(
        key: String,
        mapper: Mapper<Value>,
        in userDefaults: UserDefaults? = Runsquito.userDefaults,
        description: String? = nil
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.mapper = mapper
        
        super.init(nil, description: description)
    }
    
    public convenience init(
        key: String,
        in userDefaults: UserDefaults? = Runsquito.userDefaults,
        description: String? = nil
    ) where Value: Codable {
        self.init(
            key: key,
            mapper: .codable,
            in: userDefaults,
            description: description
        )
    }
    
    // MARK: - Public
    open override func setValue(_ value: Value?) throws {
        guard let value else {
            userDefaults?.removeObject(forKey: key)
            try super.setValue(nil)
            return
        }
        
        userDefaults?.set(try mapper.encode(value), forKey: key)
        try super.setValue(value)
    }
    
    // MARK: - Private
}
